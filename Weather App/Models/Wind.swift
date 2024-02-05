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
            return NSLocalizedString("N", comment: "N")
        case 12...34:
            return NSLocalizedString("NNE", comment: "NNE")
        case 35...56:
            return NSLocalizedString("NE", comment: "NE")
        case 57...79:
            return NSLocalizedString("ENE", comment: "ENE")
        case 80...101:
            return NSLocalizedString("E", comment: "E")
        case 102...124:
            return NSLocalizedString("ESE", comment: "ESE")
        case 125...146:
            return NSLocalizedString("SE", comment: "SE")
        case 147...169:
            return NSLocalizedString("SSE", comment: "SSE")
        case 170...191:
            return NSLocalizedString("S", comment: "S")
        case 192...214:
            return NSLocalizedString("SSW", comment: "SSW")
        case 215...236:
            return NSLocalizedString("SW", comment: "SW")
        case 237...259:
            return NSLocalizedString("WSW", comment: "WSW")
        case 260...281:
            return NSLocalizedString("W", comment: "W")
        case 282...304:
            return NSLocalizedString("WNW", comment: "WNW")
        case 305...326:
            return NSLocalizedString("NW", comment: "NW")
        case 327...348:
            return NSLocalizedString("NNW", comment: "NNW")
        default:
            return ""
        }
    }
}
