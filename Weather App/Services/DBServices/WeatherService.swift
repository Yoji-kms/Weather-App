//
//  WeatherService.swift
//  Weather App
//
//  Created by Yoji on 14.02.2024.
//

import Foundation
import CoreData

final class WeatherService: WeatherServiceProtocol {
    private let coreDataService: CoreDataService
    internal let coordinatesService: CoordinatesService
    private(set) var data: [WeatherEntity] = []
    
    private lazy var backgroundContext: NSManagedObjectContext = {
        let context = self.coreDataService.persistentContaner.newBackgroundContext()
        context.mergePolicy = NSOverwriteMergePolicy
        return context
    }()
    
    init (coreDataService: CoreDataService, coordinatesService: CoordinatesService) {
        self.coreDataService = coreDataService
        self.coordinatesService = coordinatesService
        self.fetch() { weathers in
            self.data = weathers
        }
    }
    
    func fetch(completion: @escaping ([WeatherEntity]) -> Void) {
        self.backgroundContext.perform { [weak self] in
            guard let self else { return }
            let fetchRequest = WeatherEntity.fetchRequest()
            do {
                self.data = try backgroundContext.fetch(fetchRequest).map { $0 }
                self.coreDataService.mainContext.perform { [weak self] in
                    guard let self else { return }
                    
                    completion(self.data)
                }
            } catch {
                print("🔻 Weather Error: \(error.localizedDescription)")
                self.data = []
                completion(self.data)
            }
        }
    }
    
    func saveWeather(
        coordinates: Coordinates?,
        response: WeatherResponse,
        completion: @escaping ([WeatherEntity])->Void
    ) {
        let context = self.backgroundContext
        context.perform { [weak self] in
            guard let self else { return }
            if self.data.contains(where: { dbWeather in
                let dbCoordinates = dbWeather.coordWeather?.toCoordinates()
                
                let isDbCoordinatesNotNil = dbCoordinates != nil
                let isCoordinatesEqual = dbCoordinates == coordinates
                let isCurrentLocation = coordinates?.isCurrentLocation ?? false
                
                return isCoordinatesEqual && isDbCoordinatesNotNil || isCurrentLocation
            }) {
                guard let coordinates else { return }
                self.getWeatherBy(coordinates: coordinates) { dbWeather in
                    guard let dbWeather else { return }
                    self.updateWeather(dbWeather, context: context, response: response) { _ in
                        do {
                            if context.hasChanges {
                                try context.save()
                                self.coreDataService.mainContext.perform { [weak self] in
                                    guard let self else { return }
                                    completion(self.data)
                                }
                            }
                        } catch {
                            print("🔴 Weather update Core data error:\(error.localizedDescription)")
                        }
                    }
                }
            } else {
                self.createWeather(context: context, response: response, coordinates: coordinates) { newDbWeather in
                    do {
                        if context.hasChanges {
                            try context.save()
                            self.coreDataService.mainContext.perform { [weak self] in
                                guard let self else { return }
                                self.data.append(newDbWeather)
                                completion(self.data)
                            }
                        }
                    } catch {
                        print("🔴 Weather create Core data error:\(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func getWeatherBy(coordinates: Coordinates, completion: @escaping (WeatherEntity?)->Void) {
        self.backgroundContext.perform { [weak self] in
            guard let self else { return }
            if self.data.contains(where: { dbWeather in
                guard let dbCoord = dbWeather.coordWeather?.toCoordinates() else {
                    return false
                }
                if coordinates.isCurrentLocation {
                    return dbCoord.isCurrentLocation
                }
                return dbCoord == coordinates
            }) {
                let fetchRequest = WeatherEntity.fetchRequest()
                let predicate = NSPredicate(
                    format: "coordWeather.lat == %f AND coordWeather.lon == %f",
                    coordinates.lat,
                    coordinates.lon
                )
                fetchRequest.predicate = predicate
                let weathers = try? self.backgroundContext.fetch(fetchRequest) as [WeatherEntity]
                self.coreDataService.mainContext.perform {
                    completion(weathers?.first)
                }
            }
        }
    }
    
    private func updateWeather(
        _ weather: WeatherEntity,
        context: NSManagedObjectContext,
        response: WeatherResponse,
        completion: @escaping (WeatherEntity)->Void
    ) {
        let dbWeatherItem = self.createWeatherItem(context: context, response: response)
        let dbMain = self.createMainData(context: context, response: response)
        let dbClouds = self.createClouds(context: context, response: response)
        let dbWind = self.createWind(context: context, response: response)
        let dbSys = self.createSys(context: context, response: response)
        let dbName = response.name
        
        guard let dbWeather = context.object(with: weather.objectID) as? WeatherEntity else { return }
        
        let dbCoord = self.coordinatesService.data.filter {
            guard let coordinates = weather.coordWeather else { return false }
            if coordinates.isCurrentLocation {
                return $0.isCurrentLocation
            }
            return $0 == coordinates
        }.first
        if let dbCoord {
            context.refreshAllObjects()
            let dbCoordinates = context.object(with: dbCoord.objectID) as? CoordinatesEntity
            dbWeather.coordWeather = dbCoordinates
        } else {
            dbWeather.coordWeather = nil
        }
        
        dbWeather.dt = Date(timeIntervalSince1970: response.dt)
        dbWeather.pop = response.pop ?? 0.0
        dbWeather.weatherItem = context.object(with: dbWeatherItem.objectID) as? WeatherItemEntity
        dbWeather.mainData = context.object(with: dbMain.objectID) as? MainDataEntity
        dbWeather.clouds = context.object(with: dbClouds.objectID) as? CloudsEntity
        dbWeather.wind = context.object(with: dbWind.objectID) as? WindEntity
        dbWeather.sys = context.object(with: dbSys.objectID) as? SysEntity
        dbWeather.name = dbName
        completion(dbWeather)
    }
}
