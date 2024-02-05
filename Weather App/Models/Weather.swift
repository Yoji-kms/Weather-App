//
//  Weather.swift
//  Weather App
//
//  Created by Yoji on 01.02.2024.
//

import Foundation

struct Weather {
    let coord: Coordinates?
    let weatherItem: WeatherItem
    let main: MainData
    let clouds: Clouds
    let wind: Wind
    let dt: Date
    let pop: Float?
    let sys: Sys?
    let name: String?
    
    init(
        coord: Coordinates?,
        weatherItem: WeatherItem,
        main: MainData,
        clouds: Clouds,
        wind: Wind,
        dt: Date,
        pop: Float?,
        sys: Sys?,
        name: String?
    ) {
        self.coord = coord
        self.weatherItem = weatherItem
        self.main = main
        self.clouds = clouds
        self.wind = wind
        self.dt = dt
        self.pop = pop
        self.sys = sys
        self.name = name
    }
    
    init() {
        self.coord = Coordinates()
        self.weatherItem = WeatherItem()
        self.main = MainData()
        self.clouds = Clouds()
        self.wind = Wind()
        self.dt = Date.distantPast
        self.pop = nil
        self.sys = nil
        self.name = nil
    }
}
