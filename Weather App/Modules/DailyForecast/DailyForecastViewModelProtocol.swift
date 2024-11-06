//
//  DailyForecastViewModelProtocol.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import Foundation

protocol DailyForecastViewModelProtocol: ViewModelProtocol {
    var forecast: Forecast { get }
    func popViewController()
}
