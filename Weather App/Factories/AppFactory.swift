//
//  AppFactory.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit
import CoreLocation

final class AppFactory {
    private let coreDataService: CoreDataService
    private let coordinatesService: CoordinatesService
    private let weatherService: WeatherService
    private let forecastService: ForecastService
    private let locationService: LocationService
    
    init(coreDataService: CoreDataService, locationService: LocationService) {
        self.coreDataService = coreDataService
        self.coordinatesService = CoordinatesService(coreDataService: self.coreDataService)
        self.weatherService = WeatherService(coreDataService: self.coreDataService, coordinatesService: self.coordinatesService)
        self.forecastService = ForecastService(coreDataService: self.coreDataService, coordinatesService: self.coordinatesService)
        self.locationService = locationService
    }
    
    func makeModule(ofType type: Module.ModuleType) -> Module {
        switch type {
        case .dailyWeatherReport:
            let viewModel = DailyWeatherReportViewModel()
            let viewController: UIViewController = DailyWeatherReportViewController(viewModel: viewModel)
            return Module(type: .dailyWeatherReport, viewModel: viewModel, viewController: viewController)
        case .dailyForecast(let forecast):
            let viewModel = DailyForecastViewModel(forecast: forecast)
            let viewController: UIViewController = DailyForecastViewController(viewModel: viewModel)
            return Module(type: .dailyForecast(forecast), viewModel: viewModel, viewController: viewController)
        case .mainScreen(let coordinates):
            let viewModel = MainScreenViewModel(
                weatherService: self.weatherService,
                forecastService: self.forecastService,
                coordinationService: self.coordinatesService,
                locationService: self.locationService,
                coordinates: coordinates
            )
            let viewController: UIViewController = MainScreenViewController(viewModel: viewModel)
            return Module(type: .mainScreen(coordinates), viewModel: viewModel, viewController: viewController)
        case .onboarding:
            let viewModel = OnboardingViewModel(locationService: self.locationService)
            let viewController: UIViewController = OnboardingViewController(viewModel: viewModel)
            let navController = UINavigationController(rootViewController: viewController)
            return Module(type: .onboarding, viewModel: viewModel, viewController: navController)
        case .settings:
            let viewModel = SettingsViewModel()
            let viewController: UIViewController = SettingsViewController(viewModel: viewModel)
            return Module(type: .settings, viewModel: viewModel, viewController: viewController)
        case .mainScreenPage:
            let viewModel = MainScreenPageViewModel(coordinatesServise: self.coordinatesService, locationService: self.locationService)
            let viewController: UIViewController = MainScreenPageViewController(viewModel: viewModel)
            let navController = UINavigationController(rootViewController: viewController)
            let controller = UserDefaults
                .standard
                .bool(forKey: UserDefaultKeys.isLocationRequested.rawValue) ? navController : viewController
            return Module(type: .mainScreenPage, viewModel: viewModel, viewController: controller)
        }
    }
}
