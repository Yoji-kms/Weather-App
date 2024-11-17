//
//  SettingsCoordinator.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit
import Swinject

final class SettingsCoordinator: ModuleCoordinatable {
    let moduleType: Module.ModuleType
    
    weak var delegate: RemoveChildCoordinatorDelegate?
    
    private let assembler = Assembler([SettingsAssembly()])
    
    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?
    
    init(moduleType: Module.ModuleType) {
        self.moduleType = moduleType
    }
    
    func start() -> UIViewController {
        guard let module = assembler.resolver.resolve(Module.self, name: self.moduleType.name) else {
            return UIViewController()
        }

        let viewController = module.viewController
        (module.viewModel as? SettingsViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
    
    func popViewController() {
        guard let navController = module?.viewController.navigationController else { return }
        self.delegate?.remove(childCoordinator: self)
        navController.popViewController(animated: true)
    }
}

