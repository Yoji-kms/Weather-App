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

private extension String {
    enum WeatherIcons: String {
        case thunderstorm = "Thunderstorm"
        case drizzle = "Drizzle"
        case rain = "Rain"
        case snow = "Snow"
        case clear = "Clear"
        case clouds = "Clouds"
        
        case mist = "Mist"
        case smoke = "Smoke"
        case haze = "Haze"
        case fog = "Fog"
        case sand = "Sand"
        case dust = "Dust"
        case ash = "Ash"
        case squall = "Squall"
        case tornado = "Tornado"
    }
    
    var icon: UIImage {
        let weatherIcon = WeatherIcons(rawValue: self)
        var img: UIImage
        switch weatherIcon {
        case .thunderstorm:
            img = UIImage(resource: .coloredSmallLightning)
        case .drizzle:
            img = UIImage(resource: .coloredSmallCloudsRain)
        case .rain:
            img = UIImage(resource: .coloredSmallRain)
        case .snow:
            img = UIImage(resource: .coloredSnow)
        case .clear:
            img = UIImage(resource: .coloredSmallSun)
        case .clouds:
            img = UIImage(resource: .coloredSmallClouds)
        case .mist:
            img = UIImage(resource: .coloredMist)
        case .smoke:
            img = UIImage(resource: .coloredMist)
        case .haze:
            img = UIImage(resource: .coloredMist)
        case .fog:
            img = UIImage(resource: .coloredMist)
        case .sand:
            img = UIImage(resource: .coloredMist)
        case .dust:
            img = UIImage(resource: .coloredMist)
        case .ash:
            img = UIImage(resource: .coloredMist)
        case .squall:
            img = UIImage(resource: .coloredMist)
        case .tornado:
            img = UIImage(resource: .coloredMist)
        default:
            img = UIImage()
        }

        return img
    }
}
