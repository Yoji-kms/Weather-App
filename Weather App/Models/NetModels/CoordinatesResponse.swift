//
//  Coordinates.swift
//  Weather App
//
//  Created by Yoji on 25.10.2023.
//

import Foundation

struct CoordinatesResponse: Decodable, Equatable {
    let lat: Float
    let lon: Float
}

extension CoordinatesResponse {
    func toCoordinates() -> Coordinates {
        return Coordinates(lat: self.lat, lon: self.lon)
    }
}
