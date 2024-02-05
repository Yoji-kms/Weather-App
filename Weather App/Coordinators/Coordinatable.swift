//
//  Coordinatable.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit

protocol Coordinatable: AnyObject {
    var childCoordinators: [Coordinatable] { get }
    var module: Module? { get }
    var moduleType: Module.ModuleType { get }
    func start() -> UIViewController
    func addChildCoordinator(_ coordinator: Coordinatable)
    func removeChildCoordinator(_ coordinator: Coordinatable)
}

extension Coordinatable {
    func addChildCoordinator(_ coordinator: Coordinatable) {}
    func removeChildCoordinator(_ coordinator: Coordinatable) {}
}
