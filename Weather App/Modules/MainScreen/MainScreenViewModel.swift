//
//  MainScreenViewModel.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import Foundation
import CoreLocation

final class MainScreenViewModel: MainScreenViewModelProtocol {
    weak var coordinator: MainScreenCoordinator?
    private let weatherService: WeatherService
    private let forecastService: ForecastService
    private let coordinationService: CoordinatesService
    private let locationService: LocationService
    private var prevCoordinates: Coordinates
    private var coordinates: Coordinates
    private let key = NetworkService.shared.weatherKey ?? ""
    
    var weather: Weather = Weather()
    var forecast: Forecast = Forecast()
    
    private var language = {
        "&lang=\(Locale.current.language.languageCode ?? "en")"
    }()
    
    init (
        weatherService: WeatherService,
        forecastService: ForecastService,
        coordinationService: CoordinatesService,
        locationService: LocationService,
        coordinates: Coordinates
    ) {
        self.coordinates = coordinates
        self.prevCoordinates = coordinates
        self.weatherService = weatherService
        self.forecastService = forecastService
        self.coordinationService = coordinationService
        self.locationService = locationService
        
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
        switch request {
        case .updateWeather(let completion):
            self.updateCoordinates() {
                self.updateWeather(completion: completion)
            }
            
        case .updateForecast(let completion):
            self.updateForecast(completion: completion)
        }
    }
    
    private func updateCoordinates(completion: @escaping ()->Void) {
        if
            self.coordinates.isCurrentLocation
        {
            self.prevCoordinates = self.coordinates
            self.locationService.getLocation() { [weak self] newCoordinates in
                guard let self else { return }
                self.coordinationService.updateCoordinates(self.coordinates, newCoordinates: newCoordinates) { _ in
                    self.coordinates = newCoordinates
                    completion()
                }
            }
        } else {
            completion()
        }
    }
    
    private func updateWeather(completion: @escaping ()->Void) {
        let currentDate = Date()
        
        let basicUrl = NetworkService.shared.getUrl(requestType: .currentWeather(self.coordinates))
        let urlWeather = basicUrl + language + key
        
        Task {
            let weatherDate = weather.dt
            if currentDate > weatherDate + 15.minutes {
                let weatherResponse: WeatherResponse? = await urlWeather.handleAsDecodable()
                guard let weatherResponse else { return }

                self.weatherService.saveWeather(
                    coordinates: self.coordinates, response: weatherResponse
                ) { [weak self] weathers in
                    guard
                        let self,
                        let newWeather = weathers.filter({
                            $0.coordWeather?.toCoordinates() == self.coordinates
                        }).first?.toWeather()
                    else { return }
                    
                    self.weather = newWeather
                    DispatchQueue.main.async {
                        completion()
                    }
                    self.prevCoordinates = self.coordinates
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
            
            if currentDate > forecastFirstDate || forecastCityName != self.weather.name {
                let forecastResponse: ForecastResponse? = await urlForecast.handleAsDecodable()
                guard let forecastResponse else { return }
                
                self.forecastService.saveForecast(
                    coordinates: self.coordinates, response: forecastResponse
                ) { [weak self] forecasts in
                    guard let self else { return }
                    self.forecastService.getForecastBy(coordinates: self.coordinates) { dbForecast in
                        self.forecast = dbForecast?.toForecast() ?? Forecast()
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
    
    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .moreFor24HoursBtnDidTap:
            self.coordinator?.pushViewController(ofType: .dailyForecast)
        case .daylyWeatherDidSelect:
            self.coordinator?.pushViewController(ofType: .dailyWeatherReport)
        }
    }
}

private extension Double {
    var minutes: Double {
        return self * 60
    }
}
