//
//  ForecastService.swift
//  Weather App
//
//  Created by Yoji on 14.02.2024.
//

import Foundation
import CoreData

final class ForecastService: WeatherServiceProtocol {
    private let coreDataService: CoreDataService
    internal let coordinatesService: CoordinatesService
    private(set) var data: [ForecastEntity] = []
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.coreDataService.persistentContaner.newBackgroundContext()
        return context
    }()
    
    init (coreDataService: CoreDataService, coordinatesService: CoordinatesService) {
        self.coreDataService = coreDataService
        self.coordinatesService = coordinatesService
        self.fetch() { forecasts in
            self.data = forecasts
        }
    }
    
    func fetch(completion: @escaping ([ForecastEntity]) -> Void) {
        self.backgroundContext.perform { [weak self] in
            guard let self else { return }
            let fetchRequest = ForecastEntity.fetchRequest()
            do {
                self.data = try backgroundContext.fetch(fetchRequest).map { $0 }
                self.coreDataService.mainContext.perform { [weak self] in
                    guard let self else { return }
                    
                    completion(self.data)
                }
            } catch {
                print("🔻 Error: \(error.localizedDescription)")
                self.data = []
                completion(self.data)
            }
        }
    }
    
    func getForecastBy(coordinates: Coordinates, completion: @escaping (ForecastEntity?)->()) {
        self.backgroundContext.perform { [weak self] in
            guard let self else { return }
            if self.data.contains(where: { dbForecast in
                guard let dbCoord = dbForecast.city?.coordCity?.toCoordinates() else { return false }
                return dbCoord == coordinates
            }) {
                let fetchRequest = ForecastEntity.fetchRequest()
                let latKey = #keyPath(ForecastEntity.city.coordCity.lat)
                let lonKey = #keyPath(ForecastEntity.city.coordCity.lon)
                let predicate = NSPredicate(
                    format: "ANY %K == %f AND ANY %K == %f",
                    latKey, lonKey, 
                    coordinates.lat, coordinates.lon
                )
                fetchRequest.predicate = predicate
                let forecasts = try? backgroundContext.fetch(fetchRequest) as [ForecastEntity]
                self.coreDataService.mainContext.perform {
                    completion(forecasts?.first)
                }
            }
        }
        
    }
    
    func saveForecast(
        coordinates: Coordinates,
        newCoordinates: Coordinates? = nil,
        response: ForecastResponse,
        completion: @escaping ([ForecastEntity]) -> Void
    ) {
        let context = self.backgroundContext
        
        context.perform { [weak self] in
            guard let self else { return }
            if self.data.contains(where: { dbForecast in
                let dbCoordinates = dbForecast.city?.coordCity?.toCoordinates()
                return dbCoordinates == coordinates
            }) {
                self.getForecastBy(coordinates: coordinates) { dbForecast in
                    guard let dbForecast else { return }
                    self.updateForecast(dbForecast, context: context, response: response, newCoordinates: newCoordinates) { newDbForecast in
                        do {
                            if context.hasChanges {
                                try context.save()
                                self.coreDataService.mainContext.perform { [weak self] in
                                    guard let self else { return }
                                    self.data.replace([dbForecast], with: [newDbForecast])
                                    completion(self.data)
                                }
                            }
                        } catch {
                            print("🔴 Core data error:\(error.localizedDescription)")
                        }
                    }
                }
            } else {
                self.createForecast(context: context, response: response, coordinates: coordinates) { newDbForecast in
                    do {
                        if context.hasChanges {
                            try context.save()
                            self.coreDataService.mainContext.perform { [weak self] in
                                guard let self else { return }
                                self.data.append(newDbForecast)
                                completion(self.data)
                            }
                        }
                    } catch {
                        print("🔴 Core data error:\(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func createCity(
        context: NSManagedObjectContext, response: ForecastResponse, coordinates: Coordinates
    ) -> CityEntity? {
        let dbCoordinates = self.coordinatesService.getCoordinates(coordinates)
        guard let dbCoordinates else { return nil }
        
        let dbCity = CityEntity(context: context)
        dbCity.name = response.city.name
        dbCity.sunrise = Date(timeIntervalSince1970: response.city.sunrise)
        dbCity.sunset = Date(timeIntervalSince1970: response.city.sunset)
    
        dbCity.coordCity = context.object(with: dbCoordinates.objectID) as? CoordinatesEntity
        return dbCity
    }
    
    private func updateCity(
        _ city: CityEntity, context: NSManagedObjectContext, response: ForecastResponse, newCoordinates: Coordinates?
    ) -> CityEntity? {
        let dbCity = context.object(with: city.objectID) as? CityEntity
        
        if 
            let newCoordinates,
            newCoordinates.isCurrentLocation,
            let coordinates = dbCity?.coordCity?.toCoordinates()
        {
            self.coordinatesService.updateCoordinates(coordinates, newCoordinates: newCoordinates) { newCoordinatesData in
                let dbCoordinates = newCoordinatesData.filter {
                    $0.toCoordinates() == newCoordinates
                }.first
                if let dbCoordinates {
                    dbCity?.coordCity = context.object(with: dbCoordinates.objectID) as? CoordinatesEntity
                }
            }
        }
        
        dbCity?.name = response.city.name
        dbCity?.sunrise = Date(timeIntervalSince1970: response.city.sunrise)
        dbCity?.sunset = Date(timeIntervalSince1970: response.city.sunset)
        
        return dbCity
    }
    
    private func getCityBy(coordinates: Coordinates) -> CityEntity? {
        let cities = self.data.map { $0.city ?? CityEntity() }
        return cities.filter { dbCity in
            guard let dbCoord = dbCity.coordCity else { return false }
            return dbCoord.lat == coordinates.lat && dbCoord.lon == coordinates.lon
        }.first
    }
    
    private func createForecast(
        context: NSManagedObjectContext,
        response: ForecastResponse,
        coordinates: Coordinates,
        completion: @escaping (ForecastEntity) -> Void
    ) {
        let dbForecast = ForecastEntity(context: context)
        guard let dbCity = self.createCity(context: context, response: response, coordinates: coordinates) else { return }
        dbForecast.city = context.object(with: dbCity.objectID) as? CityEntity
        response.list.forEach { weatherResponse in
            self.createWeather(
                context: context, response: weatherResponse
            ) { dbWeather in
                guard let addingDbWeather = context.object(with: dbWeather.objectID) as? WeatherEntity else { return }
                dbForecast.addToWeather(addingDbWeather)
                print(dbForecast)
            }
        }
        print(dbForecast)
        completion(dbForecast)
    }
    
    private func updateForecast(
        _ forecast: ForecastEntity,
        context: NSManagedObjectContext,
        response: ForecastResponse,
        newCoordinates: Coordinates?,
        completion: @escaping (ForecastEntity) -> Void
    ) {
        guard
            let dbForecast = context.object(with: forecast.objectID) as? ForecastEntity,
            let city = dbForecast.city,
            let dbCity = context.object(with: city.objectID) as? CityEntity,
            let newDbCity = self.updateCity(dbCity, context: context, response: response, newCoordinates: newCoordinates)
        else { return }
        
        dbForecast.city = context.object(with: newDbCity.objectID) as? CityEntity
        let weathers = dbForecast.weather?.map { $0 as? WeatherEntity }
        weathers?.forEach { dbWeather in
            guard
                let dbWeather,
                let removingDbWeather = context.object(with: dbWeather.objectID) as? WeatherEntity
            else { return }
            dbForecast.removeFromWeather(removingDbWeather)
        }
        response.list.forEach { weatherResponse in
            self.createWeather(context: context, response: weatherResponse) { newDbWeather in
                guard let addingWeather = context.object(with: newDbWeather.objectID) as? WeatherEntity else {
                    return
                }
                dbForecast.addToWeather(addingWeather)
            }
        }
        completion(dbForecast)
    }
}
