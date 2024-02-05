//
//  WeatherItem.swift
//  Weather App
//
//  Created by Yoji on 25.10.2023.
//

import Foundation

struct WeatherItemResponse: Decodable {
    let main: String
    let description: String
}
