//
//  Coordinates.swift
//  Weather App
//
//  Created by Yoji on 01.02.2024.
//

import Foundation

struct Coordinates: Equatable {
    let lat: Float
    let lon: Float
    
    init(lat: Float, lon: Float) {
        self.lat = lat
        self.lon = lon
    }
    
    init(dbCoord: CoordinatesEntity) {
        self.lat = dbCoord.lat
        self.lon = dbCoord.lon
    }
    
    init() {
        self.lat = 0
        self.lon = 0
    }
}
