//
//  CoreDataService.swift
//  Weather App
//
//  Created by Yoji on 13.12.2023.
//

import Foundation
import CoreData

final class CoreDataService {
    private(set) var weathers: [WeatherEntity] = []
    private(set) var forecasts: [ForecastEntity] = []
    
    private lazy var persistentContaner: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as? NSError {
                print("🔴 Core data error: \(error.localizedDescription)")
            }
        })
        return container
    }()
    
    private lazy var weatherBackgroundContext: NSManagedObjectContext = {
        let context = self.persistentContaner.newBackgroundContext()
        return context
    }()
    
    private lazy var forecastBackgroundContext: NSManagedObjectContext = {
        let context = self.persistentContaner.newBackgroundContext()
        return context
    }()
    
    private lazy var mainContext: NSManagedObjectContext = {
        let context = self.persistentContaner.viewContext
        return context
    }()
    
    init() {
        self.fetchAll()
    }
    
    enum Action {
        case add(Decodable, ResponseType)
    }
    
    enum ResponseType {
        case weather
        case forecast
    }
    
    func fetch<T: NSManagedObject>(model: T.Type, context: NSManagedObjectContext) {
        let fetchRequest = model.fetchRequest()
        switch model.self {
        case is ForecastEntity.Type:
            self.forecasts = (try? context.fetch(fetchRequest) as? [ForecastEntity]) ?? []
        case is WeatherEntity.Type:
            self.weathers = (try? context.fetch(fetchRequest) as? [WeatherEntity]) ?? []
        default:
            return
        }
    }
    
    func fetchAll() {
        self.fetch(model: WeatherEntity.self, context: self.weatherBackgroundContext)
        self.fetch(model: ForecastEntity.self, context: self.forecastBackgroundContext)
    }
    
    func add(_ response: Decodable, type: ResponseType) {
        self.handle(.add(response, type))
        self.fetchAll()
    }
    
    private func handle(_ action: Action) {
        do {
            switch action {
            case .add(let response, let type):
                switch type {
                case .weather:
                    self.addWeather(response: response)
                    try self.weatherBackgroundContext.save()
                case .forecast:
                    self.addForecast(response: response)
                    try self.forecastBackgroundContext.save()
                }
            }
        } catch {
            print("🔴\(error)")
        }
    }
    
    func getForecastBy(coord: Coordinates) -> ForecastEntity? {
        if self.forecasts.contains(where: { dbForecast in
            guard let dbCoord = dbForecast.city?.coordCity else { return false }
            let savedCoord = Coordinates(dbCoord: dbCoord)
            return savedCoord == coord
        }) {
            let fetchRequest = ForecastEntity.fetchRequest()
            let latKey = #keyPath(ForecastEntity.city.coordCity.lat)
            let lonKey = #keyPath(ForecastEntity.city.coordCity.lon)
            let predicate = NSPredicate(
                format: "ANY %K == %f AND ANY %K == %f", 
                latKey, lonKey, coord.lat, coord.lon
            )
            fetchRequest.predicate = predicate
            let forecasts = try? forecastBackgroundContext.fetch(fetchRequest) as [ForecastEntity]
            
            return forecasts?.first
        }
        
        return nil
    }
    
    func getWeatherBy(coord: Coordinates) -> WeatherEntity? {
        if self.weathers.contains(where: { dbWeather in
            guard let dbCoord = dbWeather.coordWeather else { return false }
            let savedCoord = Coordinates(dbCoord: dbCoord)
            return savedCoord == coord
        }) {
            let fetchRequest = WeatherEntity.fetchRequest()
            let predicate = NSPredicate(format: "coordWeather.lat == %f AND coordWeather.lon == %f", coord.lat, coord.lon)
            fetchRequest.predicate = predicate
            let weathers = try? weatherBackgroundContext.fetch(fetchRequest) as [WeatherEntity]
            
            return weathers?.first
        }
        
        return nil
    }
    
    private func addWeather(response: Decodable) {
        guard let weatherResponse = response as? WeatherResponse else { return }
        let coord = weatherResponse.coord?.toCoordinates() ?? Coordinates()
        
        let context = self.weatherBackgroundContext
        
        if !self.weathers.contains(where: { dbWeather in
            if let dbCoord = dbWeather.coordWeather {
                let savedCoord = Coordinates(dbCoord: dbCoord)
                return (savedCoord == coord)
            } else {
                return false
            }
        }) {
            let _ = self.createWeather(context: context, response: weatherResponse)
        } else {
            guard let dbWeather = self.getWeatherBy(coord: coord) else { return }
            self.updateWeather(dbWeather, context: context, response: weatherResponse)
        }
    }
    
    private func addForecast(response: Decodable) {
        guard let forecastResponse = response as? ForecastResponse else { return }
        let coord = forecastResponse.city.coord.toCoordinates()
        
        let context = self.forecastBackgroundContext
        
        if !self.forecasts.contains(where: { dbForecast in
            if let dbCoord = dbForecast.city?.coordCity {
                let savedCoord = Coordinates(dbCoord: dbCoord)
                return (savedCoord == coord)
            } else {
                return false
            }
        }) {
            let _ = self.createForecast(context: context, response: forecastResponse)
        } else {
            guard let dbForecast = self.getForecastBy(coord: coord) else { return }
            self.updateForecast(dbForecast, context: context, response: forecastResponse)
        }
    }
    
    private func createCoord(context: NSManagedObjectContext, response: Decodable) -> CoordinatesEntity {
        let dbCoord = CoordinatesEntity(context: context)
        var coordNet: Coordinates?
        if let weatherResponse = response as? WeatherResponse {
            coordNet = weatherResponse.coord?.toCoordinates()
        }
        if let forecastResponse = response as? ForecastResponse {
            coordNet = forecastResponse.city.coord.toCoordinates()
        }
        dbCoord.lat = coordNet?.lat ?? 0.0
        dbCoord.lon = coordNet?.lon ?? 0.0
        return dbCoord
    }
    
    private func createWeatherItem(context: NSManagedObjectContext, response: WeatherResponse) -> WeatherItemEntity {
        let dbWeatherItem = WeatherItemEntity(context: context)
        dbWeatherItem.weatherDescription = response.weather.first?.description
        dbWeatherItem.main = response.weather.first?.main
        return dbWeatherItem
    }
    
    private func createMainData(context: NSManagedObjectContext, response: WeatherResponse) -> MainDataEntity {
        let dbMain = MainDataEntity(context: context)
        dbMain.temp = response.main.temp
        dbMain.tempMin = response.main.tempMin
        dbMain.tempMax = response.main.tempMax
        dbMain.feelsLike = response.main.feelsLike
        dbMain.humidity = Int16(response.main.humidity)
        return dbMain
    }
    
    private func createClouds(context: NSManagedObjectContext, response: WeatherResponse) -> CloudsEntity {
        let dbClouds = CloudsEntity(context: context)
        dbClouds.all = Int16(response.clouds.all)
        return dbClouds
    }
    
    private func createWind(context: NSManagedObjectContext, response: WeatherResponse) -> WindEntity {
        let dbWind = WindEntity(context: context)
        dbWind.deg = Int16(response.wind.deg)
        dbWind.speed = response.wind.speed
        return dbWind
    }
    
    private func createSys(
        context: NSManagedObjectContext, response: WeatherResponse) -> SysEntity {
        let dbSys = SysEntity(context: context)
        dbSys.pod = response.sys?.pod
        let sunset = response.sys?.sunset ?? 0
        let sunrise = response.sys?.sunrise ?? 0
        dbSys.sunset = Date(timeIntervalSince1970: sunset)
        dbSys.sunrise = Date(timeIntervalSince1970: sunrise)
        return dbSys
    }
    
    private func createWeather(
        context: NSManagedObjectContext, response: WeatherResponse) -> WeatherEntity {
        
        let dbCoord = self.createCoord(context: context, response: response)
        let dbWeatherItem = createWeatherItem(context: context, response: response)
        let dbMain = self.createMainData(context: context, response: response)
        let dbClouds = self.createClouds(context: context, response: response)
        let dbWind = createWind(context: context, response: response)
        let dbSys = createSys(context: context, response: response)
        
        let dbWeather = WeatherEntity(context: context)
        dbWeather.name = response.name
        
        dbWeather.dt = Date(timeIntervalSince1970: response.dt)
        dbWeather.pop = response.pop ?? 0.0
        dbWeather.coordWeather = context.object(with: dbCoord.objectID) as? CoordinatesEntity
        dbWeather.weatherItem = context.object(with: dbWeatherItem.objectID) as? WeatherItemEntity
        dbWeather.mainData = context.object(with: dbMain.objectID) as? MainDataEntity
        dbWeather.clouds = context.object(with: dbClouds.objectID) as? CloudsEntity
        dbWeather.wind = context.object(with: dbWind.objectID) as? WindEntity
        dbWeather.sys = context.object(with: dbSys.objectID) as? SysEntity
        return dbWeather
    }
    
    private func updateWeather(
        _ weather: WeatherEntity, 
        context: NSManagedObjectContext,
        response: WeatherResponse
    ) {
        let dbWeatherItem = self.createWeatherItem(context: context, response: response)
        let dbMain = self.createMainData(context: context, response: response)
        let dbClouds = self.createClouds(context: context, response: response)
        let dbWind = self.createWind(context: context, response: response)
        let dbSys = self.createSys(context: context, response: response)
        
        guard let dbWeather = context.object(with: weather.objectID) as? WeatherEntity else { return }
        dbWeather.name = response.name
        
        dbWeather.dt = Date(timeIntervalSince1970: response.dt)
        dbWeather.pop = response.pop ?? 0.0
        dbWeather.weatherItem = context.object(with: dbWeatherItem.objectID) as? WeatherItemEntity
        dbWeather.mainData = context.object(with: dbMain.objectID) as? MainDataEntity
        dbWeather.clouds = context.object(with: dbClouds.objectID) as? CloudsEntity
        dbWeather.wind = context.object(with: dbWind.objectID) as? WindEntity
        dbWeather.sys = context.object(with: dbSys.objectID) as? SysEntity
    }
    
    private func createCity(context: NSManagedObjectContext, response: ForecastResponse) -> CityEntity {
        let dbCoord = self.createCoord(context: context, response: response)
        let dbCity = CityEntity(context: context)
        dbCity.name = response.city.name
        dbCity.sunrise = Date(timeIntervalSince1970: response.city.sunrise)
        dbCity.sunset = Date(timeIntervalSince1970: response.city.sunset)
        dbCity.coordCity = context.object(with: dbCoord.objectID) as? CoordinatesEntity
        return dbCity
    }
    
    private func createForecast(context: NSManagedObjectContext, response: ForecastResponse) {
        let dbForecast = ForecastEntity(context: context)
        let dbCity = self.createCity(context: context, response: response)
        dbForecast.city = context.object(with: dbCity.objectID) as? CityEntity
        response.list.forEach { weatherResponse in
            let dbWeather = self.createWeather(context: context, response: weatherResponse)
            guard let addingWeather = context.object(with: dbWeather.objectID) as? WeatherEntity else {
                return
            }
            dbForecast.addToWeather(addingWeather)
        }
    }
    
    private func updateForecast(
        _ forecast: ForecastEntity,
        context: NSManagedObjectContext,
        response: ForecastResponse)
    {
        guard let dbForecast = context.object(with: forecast.objectID) as? ForecastEntity else { return }
        let dbCity = self.createCity(context: context, response: response)
        dbForecast.city = context.object(with: dbCity.objectID) as? CityEntity
        let weathers = dbForecast.weather?.map { $0 as? WeatherEntity }
        weathers?.forEach { dbWeather in
            guard let unwrappedDbWeather = dbWeather else { return }
            guard let removingDbWeather = context.object(with: unwrappedDbWeather.objectID) as? WeatherEntity else { return }
            dbForecast.removeFromWeather(removingDbWeather)
        }
        response.list.forEach { weatherResponse in
            let dbWeather = self.createWeather(context: context, response: weatherResponse)
            guard let addingWeather = context.object(with: dbWeather.objectID) as? WeatherEntity else {
                return
            }
            dbForecast.addToWeather(addingWeather)
        }
    }
}
