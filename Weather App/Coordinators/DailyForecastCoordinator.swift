//
//  DailyForecastCoordinator.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit

final class DailyForecastCoordinator: Coordinatable {
    let moduleType: Module.ModuleType
    
    private let factory: AppFactory
    
    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?
    
    init(moduleType: Module.ModuleType, factory: AppFactory) {
        self.moduleType = moduleType
        self.factory = factory
    }
    
    func start() -> UIViewController {
        let module = self.factory.makeModule(ofType: self.moduleType)
        let viewController = module.viewController
        (module.viewModel as? DailyForecastViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
}

