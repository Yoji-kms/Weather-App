//
//  GeoResponce.swift
//  Weather App
//
//  Created by Yoji on 03.04.2024.
//

import Foundation

struct GeoResponse: Decodable {
    let lat: String
    let lon: String
}

extension GeoResponse {
    var coordinates: Coordinates {
        return Coordinates(lat: self.lat.float, lon: self.lon.float)
    }
}

private extension String {
    var float: Float {
        guard let result = Float(self) else { return 0 }
        return result
    }
}
