//
//  WeatherServiceProtocol.swift
//  Weather App
//
//  Created by Yoji on 15.02.2024.
//

import Foundation
import CoreData

protocol WeatherServiceProtocol {
    var coordinatesService: CoordinatesService { get }
    
    func createWeatherItem(
        context: NSManagedObjectContext, response: WeatherResponse
    ) -> WeatherItemEntity
    func createMainData(
        context: NSManagedObjectContext, response: WeatherResponse
    ) -> MainDataEntity
    func createClouds(
        context: NSManagedObjectContext, response: WeatherResponse
    ) -> CloudsEntity
    func createWind(
        context: NSManagedObjectContext, response: WeatherResponse
    ) -> WindEntity
    func createSys(
        context: NSManagedObjectContext, response: WeatherResponse
    ) -> SysEntity
}

extension WeatherServiceProtocol {
    func createWeatherItem(context: NSManagedObjectContext, response: WeatherResponse) -> WeatherItemEntity {
        let dbWeatherItem = WeatherItemEntity(context: context)
        dbWeatherItem.weatherDescription = response.weather.first?.description
        dbWeatherItem.main = response.weather.first?.main
        return dbWeatherItem
    }
    
    func removeWeatherItem(from dbWeather: WeatherEntity, context: NSManagedObjectContext) {
        guard let dbWeatherItem = dbWeather.weatherItem else { return }
        guard context.object(with: dbWeatherItem.objectID) is WeatherItemEntity else {
            return
        }
    }
    
    func createMainData(context: NSManagedObjectContext, response: WeatherResponse) -> MainDataEntity {
        let dbMain = MainDataEntity(context: context)
        dbMain.temp = response.main.temp
        dbMain.tempMin = response.main.tempMin
        dbMain.tempMax = response.main.tempMax
        dbMain.feelsLike = response.main.feelsLike
        dbMain.humidity = Int16(response.main.humidity)
        return dbMain
    }
    
    func createClouds(context: NSManagedObjectContext, response: WeatherResponse) -> CloudsEntity {
        let dbClouds = CloudsEntity(context: context)
        dbClouds.all = Int16(response.clouds.all)
        return dbClouds
    }
    
    func createWind(context: NSManagedObjectContext, response: WeatherResponse) -> WindEntity {
        let dbWind = WindEntity(context: context)
        dbWind.deg = Int16(response.wind.deg)
        dbWind.speed = response.wind.speed
        return dbWind
    }
    
    func createSys(
        context: NSManagedObjectContext, response: WeatherResponse
    ) -> SysEntity {
        let dbSys = SysEntity(context: context)
        dbSys.pod = response.sys?.pod
        let sunset = response.sys?.sunset ?? 0
        let sunrise = response.sys?.sunrise ?? 0
        dbSys.sunset = Date(timeIntervalSince1970: sunset)
        dbSys.sunrise = Date(timeIntervalSince1970: sunrise)
        return dbSys
    }
    
    func createWeather(
        context: NSManagedObjectContext,
        response: WeatherResponse,
        coordinates: Coordinates? = nil,
        completion: @escaping (WeatherEntity)->Void
    ) {
        let dbWeatherItem = self.createWeatherItem(context: context, response: response)
        let dbMain = self.createMainData(context: context, response: response)
        let dbClouds = self.createClouds(context: context, response: response)
        let dbWind = self.createWind(context: context, response: response)
        let dbSys = self.createSys(context: context, response: response)
        
        let dbWeather = WeatherEntity(context: context)
        
        dbWeather.name = response.name
        dbWeather.dt = Date(timeIntervalSince1970: response.dt)
        dbWeather.pop = response.pop ?? 0.0
        let dbCoord = self.coordinatesService.data.filter {
            $0.toCoordinates() == coordinates
        }.first
        if let dbCoord {
            dbWeather.coordWeather = context.object(with: dbCoord.objectID) as? CoordinatesEntity
        } else {
            dbWeather.coordWeather = nil
        }
        dbWeather.weatherItem = context.object(with: dbWeatherItem.objectID) as? WeatherItemEntity
        dbWeather.mainData = context.object(with: dbMain.objectID) as? MainDataEntity
        dbWeather.clouds = context.object(with: dbClouds.objectID) as? CloudsEntity
        dbWeather.wind = context.object(with: dbWind.objectID) as? WindEntity
        dbWeather.sys = context.object(with: dbSys.objectID) as? SysEntity
            completion(dbWeather)
    }
}
