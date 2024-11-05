//
//  GeoResponce.swift
//  Weather App
//
//  Created by Yoji on 03.04.2024.
//

import Foundation

struct GeoResponse: Decodable {
    let lat: Float
    let lon: Float
}

extension GeoResponse {
    var coordinates: Coordinates {
        return Coordinates(lat: self.lat, lon: self.lon)
    }
}

//struct Response: Decodable {
//    let 0: GeoObjectCollection
//    
//    enum CodingKeys: String, CodingKey {
//        case geoObjectCollection = "GeoObjectCollection"
//    }
//}
//
//struct GeoObjectCollection: Decodable {
//    let featureMember: [FeatureMember]
//}
//
//struct FeatureMember: Decodable {
//    let geoObject: GeoObject
//    
//    enum CodingKeys: String, CodingKey {
//        case geoObject = "GeoObject"
//    }
//}
//
//struct GeoObject: Decodable {
//    let point: Point
//    
//    enum CodingKeys: String, CodingKey {
//        case point = "Point"
//    }
//}
//
//struct Point: Decodable {
//    let pos: String
//}
//
//extension GeoResponse {
//    var coordinates: Coordinates {
//        let coordinatesString = self.response.geoObjectCollection.featureMember.first?.geoObject.point.pos ?? "0 0"
//        let coordinatesSplit = coordinatesString.split(separator: " ").map { Float($0) ?? 0 }
//        return Coordinates(lat: coordinatesSplit[1], lon: coordinatesSplit[0])
//    }
//}
