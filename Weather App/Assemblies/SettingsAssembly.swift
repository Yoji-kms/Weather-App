//
//  SettingsAssembly.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit
import CoreLocation
import Swinject
import SwinjectAutoregistration

final class SettingsAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        container.autoregister(SettingsViewModelProtocol.self, initializer: SettingsViewModel.init)
        
        let moduleType = Module.ModuleType.settings
        
        container.register(Module.self, name: moduleType.name) { resolver in
            let viewModel = resolver.resolve(SettingsViewModelProtocol.self)!
            let viewController = SettingsViewController(viewModel: viewModel)
            let module = Module(type: moduleType, viewModel: viewModel, viewController: viewController)
            return module
        }
    }
}
