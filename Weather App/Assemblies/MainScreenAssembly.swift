//
//  MainScreenAssembly.swift
//  Weather App
//
//  Created by Yoji on 15.11.2024.
//

import UIKit
import CoreLocation
import Swinject
import SwinjectAutoregistration

final class MainScreenAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.register(MainScreenViewModelProtocol.self) { (
            resolver,
            weatherService: WeatherService,
            forecastService: ForecastService,
            coordinatesService: CoordinatesService,
            locationService: LocationService,
            coordinates: Coordinates
        ) in
            let viewModel = MainScreenViewModel(
                weatherService: weatherService,
                forecastService: forecastService,
                coordinatesService: coordinatesService,
                locationService: locationService,
                coordinates: coordinates
            )
            return viewModel
        }
        
        let moduleType = Module.ModuleType.mainScreen
        
        container.register(Module.self, name: moduleType.name) { (
            resolver,
            weatherService: WeatherService,
            forecastService: ForecastService,
            coordinatesService: CoordinatesService,
            locationService: LocationService,
            coordinates: Coordinates
        ) in
            let viewModel = resolver.resolve(MainScreenViewModelProtocol.self, arguments: weatherService, forecastService, coordinatesService, locationService, coordinates)!
            let viewController = MainScreenViewController(viewModel: viewModel)
            let module = Module(type: moduleType, viewModel: viewModel, viewController: viewController)
            return module
        }
    }
}
