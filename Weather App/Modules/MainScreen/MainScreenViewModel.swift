//
//  MainScreenViewModel.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import Foundation
import CoreData

final class MainScreenViewModel: MainScreenViewModelProtocol {
    weak var coordinator: MainScreenCoordinator?
    private let coreDataService: CoreDataService
    private let coord = Coordinates(lat: 59.8944, lon: 30.2642)
    private let key = NetworkService.shared.key ?? ""
    lazy var weather: Weather = {
        let urlWeather = NetworkService.shared.currentWeather + language + key
        
        if let weather = self.coreDataService.getWeatherBy(coord: coord)?.toWeather() {
            return weather
        } else {
            Task {
                let weatherResponse: WeatherResponse? = await urlWeather.handleAsDecodable()
                guard let unwrappedWeatherResponse = weatherResponse else { return }
                self.coreDataService.add(unwrappedWeatherResponse, type: .weather)
                self.coreDataService.fetchAll()
            }
            let weather = self.coreDataService.getWeatherBy(coord: coord)?.toWeather() ?? Weather()
            return weather
        }
    }()
    lazy var forecast: Forecast = {
        let urlForecast = NetworkService.shared.forecast + language + key
        
        if let forecast = self.coreDataService.getForecastBy(coord: coord)?.toForecast() {
            return forecast
        } else {
            Task {
                let forecastResponse: ForecastResponse? = await urlForecast.handleAsDecodable()
                guard let unwrappedForecastResponse = forecastResponse else { return }
                self.coreDataService.add(unwrappedForecastResponse, type: .forecast)
                self.coreDataService.fetchAll()
            }
            let forecast = self.coreDataService.getForecastBy(coord: coord)?.toForecast() ?? Forecast()
            return forecast
        }
    }()
    private var language = {
        "&lang=\(Locale.current.language.languageCode ?? "en")"
    }()
    
    init (coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
        self.coreDataService.fetchAll()
    }
    
    enum ViewInput {
        case settingsBtnDidTap
        case locationBtnDidTap
    }
    
    enum NetRequest {
        case updateTemperature(()->())
    }
    
    func updateStateNet(request: NetRequest) {
        switch request {
        case .updateTemperature(let closure):
            let urlWeather = NetworkService.shared.currentWeather + language + key
            let urlForecast = NetworkService.shared.forecast + language + key
            
            let currentDate = Date()
            
            Task {
                let weatherDate = weather.dt
                let forecastFirstDate = forecast.list.first?.dt ?? Date.distantPast
                
                print(urlForecast)
                
                if currentDate > weatherDate + 15 * 60 {
                    let weatherResponse: WeatherResponse? = await urlWeather.handleAsDecodable()
                    guard let weather = weatherResponse else { return }
                    self.coreDataService.add(weather, type: .weather)
                    self.weather = self.coreDataService.getWeatherBy(coord: coord)?.toWeather() ?? Weather()
                }
                
                if currentDate > forecastFirstDate {
                    let forecastResponse: ForecastResponse? = await urlForecast.handleAsDecodable()
                    guard let forecast = forecastResponse else { return }
                    self.coreDataService.add(forecast, type: .forecast)
                    self.forecast = self.coreDataService.getForecastBy(coord: coord)?.toForecast() ?? Forecast()
                }
                
                closure()
            }
        }
    }
    
    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .settingsBtnDidTap:
            ()
        case .locationBtnDidTap:
            ()
        }
    }
}
