//
//  Module.swift
//  Weather App
//
//  Created by Yoji on 24.10.2023.
//

import UIKit

struct Module {
    enum ModuleType {
        case dailyWeatherReport
        case dailyForecast
        case mainScreen
        case onboarding
        case settings
        case mainScreenPage
        
        var name: String {
            return switch self {
            case .dailyForecast:
                "daily forecast"
            case .dailyWeatherReport:
                "daily weather report"
            case .mainScreen:
                "main screen"
            case .onboarding:
                "onboarding"
            case .settings:
                "settings"
            case .mainScreenPage:
                "main screen page"
            }
        }
    }
    
    let type: ModuleType
    let viewModel: ViewModelProtocol
    let viewController: UIViewController
}
