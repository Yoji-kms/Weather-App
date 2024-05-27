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
    let isCurrentLocation: Bool
    
    init(lat: Float, lon: Float, isCurrentLocation: Bool = false) {
        self.lat = lat
        self.lon = lon
        self.isCurrentLocation = isCurrentLocation
    }
    
    init(dbCoord: CoordinatesEntity) {
        self.lat = dbCoord.lat
        self.lon = dbCoord.lon
        self.isCurrentLocation = dbCoord.isCurrentLocation
    }
    
    init(coordinates: String, isCurrentLocation: Bool = false) {
        let coordinatesSplit = coordinates
            .split(separator: " ")
            .map { Float($0) ?? 0 }
        
        self.lat = coordinatesSplit[1]
        self.lon = coordinatesSplit[0]
        self.isCurrentLocation = isCurrentLocation
    }
    
    init() {
        self.lat = 0
        self.lon = 0
        self.isCurrentLocation = false
    }
}
