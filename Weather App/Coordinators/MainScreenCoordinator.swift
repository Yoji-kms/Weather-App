//
//  MainScreenCoordinator.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit
import Swinject

final class MainScreenCoordinator: ModuleCoordinatable {
    let moduleType: Module.ModuleType
    
    private let assembler = Assembler([
        MainScreenAssembly()
    ])
    private let coordinates: Coordinates
    private let weatherService: WeatherService
    private let forecastService: ForecastService
    private let coordinatesService: CoordinatesService
    private let locationService: LocationService
    
    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?
    
    init(
        moduleType: Module.ModuleType,
        weatherService: WeatherService,
        forecastService: ForecastService,
        coordinatesService: CoordinatesService,
        locationService: LocationService,
        coordinates: Coordinates
    ) {
        self.moduleType = moduleType
        self.weatherService = weatherService
        self.forecastService = forecastService
        self.coordinatesService = coordinatesService
        self.locationService = locationService
        
        self.coordinates = coordinates
    }
    
    func start() -> UIViewController {
        guard let module = assembler.resolver.resolve(
            Module.self, name: self.moduleType.name,
            arguments:
                self.weatherService,
            self.forecastService,
            self.coordinatesService,
            self.locationService,
            self.coordinates
        ) else {
            return UIViewController()
        }

        let viewController = module.viewController
        (module.viewModel as? MainScreenViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
    
    func addChildCoordinator(_ coordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinatable) {
        self.childCoordinators.removeAll(where: { $0 === coordinator })
    }
    
    func pushViewController(ofType type: Module.ModuleType, forecast: Forecast, dateId: Int = 0) {
        var childCoordinator: Coordinatable
        
        switch type {
        case .dailyWeatherReport:
            childCoordinator = DailyWeatherReportCoordinator(moduleType: type, forecast: forecast, dateId: dateId)
            (childCoordinator as? DailyWeatherReportCoordinator)?.delegate = self
        case .dailyForecast:
            childCoordinator = DailyForecastCoordinator(moduleType: type, forecast: forecast)
            (childCoordinator as? DailyForecastCoordinator)?.delegate = self
        default:
            return
        }
        
        self.addChildCoordinator(childCoordinator)
        
        let viewControllerToPush = childCoordinator.start()
        let navController = module?.viewController.navigationController
        navController?.pushViewController(viewControllerToPush, animated: true)
    }
}

extension MainScreenCoordinator: RemoveChildCoordinatorDelegate {
    func remove(childCoordinator: any Coordinatable) {
        self.removeChildCoordinator(childCoordinator)
    }
}
