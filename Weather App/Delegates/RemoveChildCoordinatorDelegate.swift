//
//  RemoveChildCoordinatorDelegate.swift
//  Weather App
//
//  Created by Yoji on 24.10.2023.
//

import Foundation

protocol RemoveChildCoordinatorDelegate: AnyObject {
    func remove(childCoordinator: Coordinatable)
}
