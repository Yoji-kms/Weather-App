//
//  MainScreenPageAssembly.swift
//  Weather App
//
//  Created by Yoji on 15.11.2024.
//

import UIKit
import CoreLocation
import Swinject
import SwinjectAutoregistration

final class MainScreenPageAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.autoregister(
            MainScreenPageViewModelProtocol.self,
            arguments: CoordinatesService.self, LocationService.self, CoreDataService.self,
            initializer: MainScreenPageViewModel.init
        )
        
        let moduleType = Module.ModuleType.mainScreenPage
        
        container.register(Module.self, name: moduleType.name) {(
            resolver, coordinatesService: CoordinatesService, locationService: LocationService, coreDataService: CoreDataService
            ) in
            let viewModel = resolver.resolve(
                MainScreenPageViewModelProtocol.self,
                arguments: coordinatesService, locationService, coreDataService
            )!
            let viewController = MainScreenPageViewController(viewModel: viewModel)
            let navController = UINavigationController(rootViewController: viewController)
            let controller = UserDefaults
                .standard
                .bool(forKey: UserDefaultKeys.isLocationRequested.rawValue) ? navController : viewController
            let module = Module(type: moduleType, viewModel: viewModel, viewController: controller)
            return module
        }
    }
}
