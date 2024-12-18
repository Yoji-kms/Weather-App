//
//  MainScreenCoordinator.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit

final class MainScreenCoordinator: ModuleCoordinatable {
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
    
    func pushViewController(ofType type: Module.ModuleType) {
        var childCoordinator: Coordinatable
        
        switch type {
        case .dailyWeatherReport:
            childCoordinator = DailyWeatherReportCoordinator(moduleType: type, factory: self.factory)
            (childCoordinator as? DailyWeatherReportCoordinator)?.delegate = self
        case .dailyForecast:
            childCoordinator = DailyForecastCoordinator(moduleType: type, factory: self.factory)
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
