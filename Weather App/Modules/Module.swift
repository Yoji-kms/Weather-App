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
    }
    
    let type: ModuleType
    let viewModel: ViewModelProtocol
    let viewController: UIViewController
}
