//
//  City.swift
//  Weather App
//
//  Created by Yoji on 25.10.2023.
//

import Foundation

struct CityResponse: Decodable {
    let name: String
    let sunset: TimeInterval
    let sunrise: TimeInterval
}
