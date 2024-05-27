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
        case mainScreen(Coordinates)
        case onboarding
        case settings
        case mainScreenPage
    }
    
    let type: ModuleType
    let viewModel: ViewModelProtocol
    let viewController: UIViewController
}
