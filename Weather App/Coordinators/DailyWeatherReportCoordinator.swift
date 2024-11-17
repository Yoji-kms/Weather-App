//
//  DailyWeatherReportCoordinator.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit
import Swinject

final class DailyWeatherReportCoordinator: ModuleCoordinatable {
    let moduleType: Module.ModuleType
    
    weak var delegate: RemoveChildCoordinatorDelegate?
    
    private let assembler = Assembler([
        DailyWeatherReportAssembly()
    ])
    private let forecast: Forecast
    private let dateId: Int
    
    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?
    
    init(moduleType: Module.ModuleType, forecast: Forecast, dateId: Int) {
        self.moduleType = moduleType
        self.forecast = forecast
        self.dateId = dateId
    }
    
    func start() -> UIViewController {
        guard let module = assembler.resolver.resolve(
            Module.self, name: self.moduleType.name, arguments: self.forecast, self.dateId
        ) else {
            return UIViewController()
        }
        
        let viewController = module.viewController
        (module.viewModel as? DailyWeatherReportViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
    
    func popViewController() {
        guard let navController = module?.viewController.navigationController else { return }
        self.delegate?.remove(childCoordinator: self)
        navController.popViewController(animated: true)
    }
}
