//
//  ForecastResponse.swift
//  Weather App
//
//  Created by Yoji on 25.10.2023.
//

import Foundation

struct ForecastResponse: Decodable {
    let list: [WeatherResponse]
    let city: CityResponse
}
