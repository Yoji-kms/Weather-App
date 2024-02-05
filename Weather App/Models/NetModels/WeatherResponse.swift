//
//  WeatherResponse.swift
//  Weather App
//
//  Created by Yoji on 25.10.2023.
//

import Foundation

struct WeatherResponse: Decodable {
    let coord: CoordinatesResponse?
    let weather: [WeatherItemResponse]
    let main: MainDataResponse
    let clouds: CloudsResponse
    let wind: WindResponse
    let dt: TimeInterval
    let pop: Float?
    let sys: SysResponse?
    let name: String?
}
