//
//  MainData.swift
//  Weather App
//
//  Created by Yoji on 25.10.2023.
//

import Foundation

struct MainDataResponse: Decodable {
    let temp: Float
    let feelsLike: Float
    let tempMin: Float
    let tempMax: Float
    let humidity: Int
}
