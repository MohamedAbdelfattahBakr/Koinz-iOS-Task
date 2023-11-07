//
//  AppDelegate.swift
//  Koinz-Task
//
//  Created by Mohamed Bakr on 05/11/2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        let coordinator = FlickrImagesCoordinator(navigationController: navigationController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        coordinator.start()

        return true
    }
}

