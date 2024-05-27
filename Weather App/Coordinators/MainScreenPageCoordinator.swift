//
//  MainScreenPageCoordinator.swift
//  Weather App
//
//  Created by Yoji on 05.02.2024.
//

import UIKit

final class MainScreenPageCoordinator: ModuleCoordinatable {
    let moduleType: Module.ModuleType
    
    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?
    private let factory: AppFactory
    
    init(moduleType: Module.ModuleType,factory: AppFactory) {
        self.moduleType = moduleType
        self.factory = factory
    }
    
    func start() -> UIViewController {
        let module = self.factory.makeModule(ofType: .mainScreenPage)
        let viewController = module.viewController
        (module.viewModel as? MainScreenPageViewModel)?.coordinator = self
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
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }
    
    func addMainViewController(with coordinates: Coordinates) -> MainScreenViewController? {
        let childCoordinator = MainScreenCoordinator(
            moduleType: .mainScreen(coordinates), factory: self.factory
        )
        
        self.addChildCoordinator(childCoordinator)
        let addingViewController = childCoordinator.start() as? MainScreenViewController
         
        return addingViewController
    }
    
    func addAddLocationViewController() -> AddLocationViewController? {
        let addingViewController = AddLocationViewController()
        return addingViewController
    }
    
    func pushViewController(ofType type: Module.ModuleType) {
        var childCoordinator: Coordinatable
        
        switch type {
        case .onboarding:
            childCoordinator = OnboardingCoordinator(moduleType: type, factory: self.factory)
        case .settings:
            childCoordinator = SettingsCoordinator(moduleType: type, factory: self.factory)
        default:
            return
        }
        
        self.addChildCoordinator(childCoordinator)
        
        let viewControllerToPush = childCoordinator.start()
        guard let navController = module?.viewController as? UINavigationController else { return }
        navController.pushViewController(viewControllerToPush, animated: true)
    }
    
    func presentCreateFolderAlertController(completion: @escaping (String) -> Void) {
        let controllerTitle = String(localized: Strings.addLocation.rawValue)
        let alert = UIAlertController(title: controllerTitle, message: nil, preferredStyle: .alert)
        
        let cancelActionTitle = String(localized: Strings.cancel.rawValue)
        let cancelAction = UIAlertAction(title: cancelActionTitle, style: .destructive) { _ in
            alert.dismiss(animated: true)
        }
        
        let createActionTitle = String(localized: Strings.add.rawValue)
        let createAction = UIAlertAction(title: createActionTitle, style: .default) { _ in
            let newCityString = alert.textFields?.first?.text ?? ""
            completion(newCityString)
        }
        createAction.isEnabled = !(alert.textFields?.first?.text?.isEmpty ?? true)
        
        let textChangedAction = UIAction { _ in
            guard let text = alert.textFields?.first?.text else { return }
            createAction.isEnabled = !text.isEmpty
        }
        
        alert.addTextField { textField in
            textField.placeholder = String(localized: Strings.cityName.rawValue)
            textField.addAction(textChangedAction, for: .editingChanged)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        
        self.module?.viewController.present(alert, animated: true)
    }
}
