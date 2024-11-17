//
//  DailyWeatherReportAssembly.swift
//  Weather App
//
//  Created by Yoji on 15.11.2024.
//

import UIKit
import CoreLocation
import Swinject
import SwinjectAutoregistration

final class DailyWeatherReportAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.autoregister(DailyWeatherReportViewModelProtocol.self, argument: Forecast.self , initializer: DailyWeatherReportViewModel.init)
        
        let moduleType = Module.ModuleType.dailyWeatherReport
        
        container.register(Module.self, name: moduleType.name) { (resolver, forecast: Forecast, dateId: Int) in
            let viewModel = resolver.resolve(DailyWeatherReportViewModelProtocol.self, argument: forecast)!
            let viewController = DailyWeatherReportViewController(viewModel: viewModel, selectedDateId: dateId)
            let module = Module(type: moduleType, viewModel: viewModel, viewController: viewController)
            return module
        }
    }
}
