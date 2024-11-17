//
//  OnboardingCoordinator.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit
import Swinject

final class OnboardingCoordinator: ModuleCoordinatable {
    let moduleType: Module.ModuleType
    
    private let assembler = Assembler([
        OnboardingAssembly()
    ])
    private let locationService: LocationService
    private let coordinatesService: CoordinatesService
    private let coreDataService: CoreDataService
    
    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?
    
    init(
        moduleType: Module.ModuleType,
        locationService: LocationService,
        coordinatesService: CoordinatesService,
        coreDataService: CoreDataService
    ) {
        self.moduleType = moduleType
        self.locationService = locationService
        self.coordinatesService = coordinatesService
        self.coreDataService = coreDataService
    }
    
    func start() -> UIViewController {
        guard let module = assembler.resolver.resolve(
            Module.self,
            name: self.moduleType.name,
            arguments: self.locationService, self.coordinatesService, self.coreDataService
        )
        else {
            return UIViewController()
        }

        let viewController = module.viewController
        (module.viewModel as? OnboardingViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
    
    func pushViewController(coordinatesService: CoordinatesService, locationService: LocationService, coreDataService: CoreDataService) {
        let childCoordinator = MainScreenPageCoordinator(
            moduleType: .mainScreenPage,
            coordinatesService: coordinatesService,
            locationService: locationService,
            coreDataService: coreDataService
        )
        
        self.addChildCoordinator(childCoordinator)
        
        let viewControllerToPush = childCoordinator.start()
        guard let navController = module?.viewController as? UINavigationController else { return }
        navController.pushViewController(viewControllerToPush, animated: true)
    }
}
