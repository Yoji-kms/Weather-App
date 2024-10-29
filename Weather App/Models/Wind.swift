//
//  Wind.swift
//  Weather App
//
//  Created by Yoji on 01.02.2024.
//

import Foundation

struct Wind {
    let speed: Int
    let windDirection: String
    
    init(speed: Float, deg: Int) {
        self.speed = speed.toRoundedInt
        self.windDirection = deg.windDirection
    }
    
    init() {
        self.speed = 0
        self.windDirection = ""
    }
}

extension Int {
    var windDirection: String {
        switch self {
        case 349...360, 0...11:
            return String(localized: "N")
        case 12...34:
            return String(localized: "NNE")
        case 35...56:
            return String(localized: "NE")
        case 57...79:
            return String(localized: "ENE")
        case 80...101:
            return String(localized: "E")
        case 102...124:
            return String(localized: "ESE")
        case 125...146:
            return String(localized: "SE")
        case 147...169:
            return String(localized: "SSE")
        case 170...191:
            return String(localized: "S")
        case 192...214:
            return String(localized: "SSW")
        case 215...236:
            return String(localized: "SW")
        case 237...259:
            return String(localized: "WSW")
        case 260...281:
            return String(localized: "W")
        case 282...304:
            return String(localized: "WNW")
        case 305...326:
            return String(localized: "NW")
        case 327...348:
            return String(localized: "NNW")
        default:
            return ""
        }
    }
}
