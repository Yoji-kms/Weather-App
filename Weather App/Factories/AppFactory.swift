//
//  AppFactory.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit

final class AppFactory {
    private let coreDataService: CoreDataService
    
    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }
    
    func makeModule(ofType type: Module.ModuleType) -> Module {
        switch type {
        case .dailyWeatherReport:
            let viewModel = DailyWeatherReportViewModel()
            let viewController: UIViewController = DailyWeatherReportViewController(viewModel: viewModel)
            return Module(type: .dailyForecast, viewModel: viewModel, viewController: viewController)
        case .dailyForecast:
            let viewModel = DailyForecastViewModel()
            let viewController: UIViewController = DailyForecastViewController(viewModel: viewModel)
            return Module(type: .dailyForecast, viewModel: viewModel, viewController: viewController)
        case .mainScreen:
            let viewModel = MainScreenViewModel(coreDataService: self.coreDataService)
            let viewController: UIViewController = MainScreenViewController(viewModel: viewModel)
            let navController = UINavigationController(rootViewController: viewController)
            return Module(type: .dailyForecast, viewModel: viewModel, viewController: navController)
        case .onboarding:
            let viewModel = OnboardingViewModel()
            let viewController: UIViewController = OnboardingViewController(viewModel: viewModel)
            return Module(type: .dailyForecast, viewModel: viewModel, viewController: viewController)
        case .settings:
            let viewModel = SettingsViewModel()
            let viewController: UIViewController = SettingsViewController(viewModel: viewModel)
            return Module(type: .dailyForecast, viewModel: viewModel, viewController: viewController)
        }
    }
}
