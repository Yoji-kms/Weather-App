//
//  DailyForecastCoordinator.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit
import Swinject

final class DailyForecastCoordinator: ModuleCoordinatable {
    let moduleType: Module.ModuleType
    
    weak var delegate: RemoveChildCoordinatorDelegate?
    
    private let assembler = Assembler([
        DailyForecastAssembly()
    ])
    
    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?

    private let forecast: Forecast
    
    init(moduleType: Module.ModuleType, forecast: Forecast) {
        self.moduleType = moduleType
        self.forecast = forecast
    }
    
    func start() -> UIViewController {
        guard let module = assembler.resolver.resolve(Module.self, name: "daily forecast", argument: self.forecast) else {
            return UIViewController()
        }

        let viewController = module.viewController
        (module.viewModel as? DailyForecastViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
    
    func popViewController() {
        guard let navController = module?.viewController.navigationController else { return }
        self.delegate?.remove(childCoordinator: self)
        navController.popViewController(animated: true)
    }
}

