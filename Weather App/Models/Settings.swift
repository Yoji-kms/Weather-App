//
//  Settings.swift
//  Weather App
//
//  Created by Yoji on 06.11.2024.
//

import Foundation

final class Settings {
    static let shared = Settings()
    
    private(set) var temperature: Temperature = .c
    private(set) var windSpeed: WindSpeed = .km
    private(set) var timeFormat: TimeFormat = ._24
    private(set) var isNotificationsOff: Bool = true
    
    init() {
        self.getFromUserDefaults()
    }
    
    func update(
        temperatureBool: Bool,
        windSpeedBool: Bool,
        timeFormatBool: Bool,
        notificationsBool: Bool
    ) {
        self.temperature = temperatureBool.temperature
        self.windSpeed = windSpeedBool.windSpeed
        self.timeFormat = timeFormatBool.timeFormat
        self.isNotificationsOff = notificationsBool
        
        UserDefaults.standard.set(temperature.bool, forKey: UserDefaultKeys.temperature.rawValue)
        UserDefaults.standard.set(windSpeed.bool, forKey: UserDefaultKeys.windSpeed.rawValue)
        UserDefaults.standard.set(timeFormat.bool, forKey: UserDefaultKeys.timeFormat.rawValue)
        UserDefaults.standard.set(isNotificationsOff, forKey: UserDefaultKeys.isNotificationsOff.rawValue)
    }
    
    func getFromUserDefaults() {
        self.temperature = UserDefaults.standard.bool(forKey: UserDefaultKeys.temperature.rawValue).temperature
        self.windSpeed = UserDefaults.standard.bool(forKey: UserDefaultKeys.windSpeed.rawValue).windSpeed
        self.timeFormat = UserDefaults.standard.bool(forKey: UserDefaultKeys.timeFormat.rawValue).timeFormat
        self.isNotificationsOff = UserDefaults.standard.bool(forKey: UserDefaultKeys.isNotificationsOff.rawValue)
    }
}

extension Bool {
    var temperature: Temperature {
        return self ? .f : .c
    }
    
    var windSpeed: WindSpeed {
        return self ? .km : .mi
    }
    
    var timeFormat: TimeFormat {
        return self ? ._24 : ._12
    }
}

enum Temperature {
    case c
    case f
    
    var bool: Bool {
        switch self {
        case .c:
            return false
        case .f:
            return true
        }
    }
}

enum WindSpeed {
    case mi
    case km
    
    var bool: Bool {
        switch self {
        case .mi:
            return false
        case .km:
            return true
        }
    }
}

enum TimeFormat {
    case _12
    case _24
    
    var bool: Bool {
        switch self {
        case ._12:
            return false
        case ._24:
            return true
        }
    }
}

extension Int {
    var temperature: Int {
        let temperatureFormat = Settings.shared.temperature
        
        switch temperatureFormat {
        case .c:
            return self
        case .f:
            return (self * 9 / 5) + 32
        }
    }
    
    var windSpeed: Int {
        let windSpeedFormat = Settings.shared.windSpeed
        
        switch windSpeedFormat {
        case .km:
            return self
        case .mi:
            return Int(Double(self) * 2.23694)
        }
    }
}

extension String {
    var windSpeed: String {
        let windSpeedFormat = Settings.shared.windSpeed
        
        switch windSpeedFormat {
        case .km:
            return self
        case .mi:
            return String(localized: Strings.mph.rawValue)
        }
    }
    
    var timeFormat: String {
        let timeFormat = Settings.shared.timeFormat
        
        switch timeFormat {
        case ._12:
            return self.replacing("HH", with: "hh")
        case ._24:
            return self
        }
    }
}
