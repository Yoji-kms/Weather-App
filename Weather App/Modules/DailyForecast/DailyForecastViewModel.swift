//
//  DailyForecastViewModel.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import Foundation

final class DailyForecastViewModel: DailyForecastViewModelProtocol {
    weak var coordinator: DailyForecastCoordinator?
    
    let forecast: Forecast
    
    init(forecast: Forecast) {
        self.forecast = forecast
    }
}
