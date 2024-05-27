//
//  MainScreenViewModel.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import Foundation
import CoreData
import CoreLocation


final class MainScreenViewModel: MainScreenViewModelProtocol {
    weak var coordinator: MainScreenCoordinator?
    private let weatherService: WeatherService
    private let forecastService: ForecastService
    private let locationManager: CLLocationManager
    private var prevCoordinates: Coordinates
    private var coordinates: Coordinates
    private let key = NetworkService.shared.weatherKey ?? ""
    
    var weather: Weather = Weather()
    var forecast: Forecast = Forecast()
    
    private var language = {
        "&lang=\(Locale.current.language.languageCode ?? "en")"
    }()
    
    init (weatherService: WeatherService, forecastService: ForecastService, coordinates: Coordinates, locationManager: CLLocationManager) {
        self.coordinates = coordinates
        self.prevCoordinates = coordinates
        self.weatherService = weatherService
        self.forecastService = forecastService
        self.locationManager = locationManager
        
        self.weatherService.getWeatherBy(coordinates: coordinates) { [weak self] dbWeather in
            guard let self else { return }
            self.weather = dbWeather?.toWeather() ?? Weather()
        }
        self.forecastService.getForecastBy(coordinates: coordinates) { [weak self] dbForecast in
            guard let self else { return }
            self.forecast = dbForecast?.toForecast() ?? Forecast()
        }
    }
    
    enum ViewInput {
        case moreFor24HoursBtnDidTap
        case daylyWeatherDidSelect
    }
    
    enum NetRequest {
        case updateWeather(()->Void)
        case updateForecast(()->Void)
    }
    
    func updateStateNet(request: NetRequest) {
        self.updateCoordinates()
        switch request {
        case .updateWeather(let completion):
            self.updateWeather(completion: completion)
            
        case .updateForecast(let completion):
            self.updateForecast(completion: completion)
        }
        self.prevCoordinates = self.coordinates
    }
    
    private func updateCoordinates() {
        if
            self.coordinates.isCurrentLocation
        {
            prevCoordinates = self.coordinates
            locationManager.requestLocation()
            guard
                let newCoordinates = locationManager.location?.coordinate.coordinates
            else { return }
            self.coordinates = newCoordinates
        }
    }
    
    private func updateWeather(completion: @escaping ()->Void) {
        let currentDate = Date()
        
        let basicUrl = NetworkService.shared.getUrl(requestType: .currentWeather(self.coordinates))
        let urlWeather = basicUrl + language + key
        
        Task {
            let weatherDate = weather.dt
            if currentDate > weatherDate + 15 * 60 {
                let weatherResponse: WeatherResponse? = await urlWeather.handleAsDecodable()
                guard let weatherResponse else { return }
                let newCoordinates = prevCoordinates == coordinates ? nil : coordinates
                self.weatherService.saveWeather(
                    coordinates: self.prevCoordinates, newCoordinates: newCoordinates, response: weatherResponse
                ) { [weak self] weathers in
                    guard let self else { return }
                    self.weatherService.getWeatherBy(coordinates: self.coordinates) { dbWeather in
                        self.weather = dbWeather?.toWeather() ?? Weather()
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                }
            } else {
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    private func updateForecast(completion: @escaping ()->Void) {
        let currentDate = Date()
        let basicUrl = NetworkService.shared.getUrl(requestType: .forecast(self.coordinates))
        let urlForecast = basicUrl + language + key
        
        Task {
            let forecastCityName = forecast.city.name
            let forecastFirstDate = forecast.list.first?.dt ?? Date.distantPast
                            
            if currentDate > forecastFirstDate || forecastCityName != weather.name {
                let forecastResponse: ForecastResponse? = await urlForecast.handleAsDecodable()
                guard let forecastResponse else { return }
                
                let newCoordinates = self.prevCoordinates == self.coordinates ? nil : self.coordinates
                
                self.forecastService.saveForecast(
                    coordinates: self.prevCoordinates, newCoordinates: newCoordinates, response: forecastResponse
                ) { [weak self] forecasts in
                    guard let self else { return }
                    self.forecastService.getForecastBy(coordinates: self.coordinates) { dbForecast in
                        self.forecast = dbForecast?.toForecast() ?? Forecast()
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .moreFor24HoursBtnDidTap:
            self.coordinator?.pushViewController(ofType: .dailyForecast)
        case .daylyWeatherDidSelect:
            self.coordinator?.pushViewController(ofType: .dailyWeatherReport)
        }
    }
}
