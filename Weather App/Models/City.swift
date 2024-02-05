//
//  City.swift
//  Weather App
//
//  Created by Yoji on 01.02.2024.
//

import Foundation

struct City {
    let name: String
    let coord: Coordinates
    let sunset: Date
    let sunrise: Date
    
    init(name: String, coord: Coordinates, sunset: Date, sunrise: Date) {
        self.name = name
        self.coord = coord
        self.sunset = sunset
        self.sunrise = sunrise
    }
    
    init() {
        self.name = ""
        self.coord = Coordinates()
        self.sunset = Date()
        self.sunrise = Date()
    }
}
