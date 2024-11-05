//
//  DailyWeatherReportViewModelProtocol.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import Foundation

protocol DailyWeatherReportViewModelProtocol: ViewModelProtocol {
    var dates: [Date] { get }
    var city: String { get }
    func updateWeatherBy(dateId: Int, completion: @escaping (DailyWeather?)->Void)
}
