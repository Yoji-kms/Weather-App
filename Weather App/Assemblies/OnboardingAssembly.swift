//
//  OnboardingAssembly.swift
//  Weather App
//
//  Created by Yoji on 15.11.2024.
//

import UIKit
import CoreLocation
import Swinject
import SwinjectAutoregistration

final class OnboardingAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.autoregister(
            OnboardingViewModelProtocol.self,
            arguments: LocationService.self, CoordinatesService.self, CoreDataService.self,
            initializer: OnboardingViewModel.init
        )
        
        let moduleType = Module.ModuleType.onboarding
        
        container.register(Module.self, name: moduleType.name) { (
            resolver, locationService: LocationService, coordinatesService: CoordinatesService, coreDataService: CoreDataService
        ) in
            let coordinatesService = resolver.resolve(CoordinatesService.self)!
            let locationService = resolver.resolve(LocationService.self)!
            let viewModel = resolver.resolve(
                OnboardingViewModelProtocol.self,
                arguments: locationService, coordinatesService, coreDataService
            )!
            let viewController: UIViewController = OnboardingViewController(viewModel: viewModel)
            let navController = UINavigationController(rootViewController: viewController)
            let module = Module(type: moduleType, viewModel: viewModel, viewController: navController)
            return module
        }
    }
}
