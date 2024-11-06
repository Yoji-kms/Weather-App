//
//  SceneDelegate.swift
//  Weather App
//
//  Created by Yoji on 23.10.2023.
//

import UIKit
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        let coreDataService = CoreDataService()
        let locationService = LocationService()
        let factory = AppFactory(coreDataService: coreDataService, locationService: locationService)
        
        let rootViewController = self.getRootViewController(locationService: locationService, factory: factory)
        
        self.window?.rootViewController = rootViewController
        self.window?.makeKeyAndVisible()
    }
    
    private func getRootViewController(locationService: LocationService, factory: AppFactory) -> UIViewController {
        if locationService.isNotDeterminedAuthorization &&
            !UserDefaults.standard.bool(forKey: UserDefaultKeys.isLocationRequested.rawValue) {
            Settings.shared.update(
                temperatureBool: Temperature.c.bool,
                windSpeedBool: WindSpeed.km.bool,
                timeFormatBool: TimeFormat._24.bool,
                notificationsBool: true
            )
            
            let appCoordinator = OnboardingCoordinator(moduleType: .onboarding, factory: factory)
            return appCoordinator.start()
        } else {
            let appCoordinator = MainScreenPageCoordinator(moduleType: .mainScreenPage, factory: factory)
            return appCoordinator.start()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

