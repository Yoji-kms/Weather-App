//
//  DailyForecastAssembly.swift
//  Weather App
//
//  Created by Yoji on 15.11.2024.
//

import UIKit
import CoreLocation
import Swinject
import SwinjectAutoregistration

final class DailyForecastAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.autoregister(DailyForecastViewModelProtocol.self, argument: Forecast.self , initializer: DailyForecastViewModel.init)
        
        let moduleType = Module.ModuleType.dailyForecast
        
        container.register(Module.self, name: moduleType.name) { (resolver, forecast: Forecast) in
            let viewModel = resolver.resolve(DailyForecastViewModelProtocol.self, argument: forecast)!
            let viewController = DailyForecastViewController(viewModel: viewModel)
            let module = Module(type: moduleType, viewModel: viewModel, viewController: viewController)
            return module
        }
    }
}
