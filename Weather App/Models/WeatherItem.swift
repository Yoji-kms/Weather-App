//
//  WeatherItem.swift
//  Weather App
//
//  Created by Yoji on 01.02.2024.
//

import UIKit

struct WeatherItem {
    let description: String
    let icon: UIImage
    
    init(description: String, main: String) {
        self.description = description
        self.icon = main.icon
    }
    
    init() {
        self.description = ""
        self.icon = UIImage()
    }
}

extension String {
    var icon: UIImage {
        let weatherIcon = WeatherIcons(rawValue: self)
        var img: UIImage
        switch weatherIcon {
        case .thunderstorm:
            img = UIImage(named: Icons.coloredSmallLightning.rawValue) ?? UIImage()
        case .drizzle:
            img = UIImage(named: Icons.coloredSmallCloudsRain.rawValue) ?? UIImage()
        case .rain:
            img = UIImage(named: Icons.coloredSmallRain.rawValue) ?? UIImage()
        case .snow:
            img = UIImage(named: Icons.coloredSnow.rawValue) ?? UIImage()
        case .clear:
            img = UIImage(named: Icons.coloredSmallSun.rawValue) ?? UIImage()
        case .clouds:
            img = UIImage(named: Icons.coloredSmallClouds.rawValue) ?? UIImage()
        case .mist:
            img = UIImage(named: Icons.coloredMist.rawValue) ?? UIImage()
        case .smoke:
            img = UIImage(named: Icons.coloredMist.rawValue) ?? UIImage()
        case .haze:
            img = UIImage(named: Icons.coloredMist.rawValue) ?? UIImage()
        case .fog:
            img = UIImage(named: Icons.coloredMist.rawValue) ?? UIImage()
        case .sand:
            img = UIImage(named: Icons.coloredMist.rawValue) ?? UIImage()
        case .dust:
            img = UIImage(named: Icons.coloredMist.rawValue) ?? UIImage()
        case .ash:
            img = UIImage(named: Icons.coloredMist.rawValue) ?? UIImage()
        case .squall:
            img = UIImage(named: Icons.coloredMist.rawValue) ?? UIImage()
        case .tornado:
            img = UIImage(named: Icons.coloredMist.rawValue) ?? UIImage()
        default:
            img = UIImage()
        }

        return img
    }
}
