//
//  AppDelegate.swift
//  NYTime
//
//  Created by Parth Dubal on 22/02/20.
//  Copyright © 2020 Parth Dubal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_: UIApplication,
                     didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        let newsListConfig = getBuildConfigurator()
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: newsListConfig.build())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }

    /// Return Configurator instace based on running process. i.e; normal application running  or Happy / fail UI Test scenario.
    /// `Configurator` instace of  build dependency of NewListViewController
    func getBuildConfigurator() -> Configurator {
        switch ProcessInfo.processInfo.isRunningUITest() {
        case UITestRunner.successRunnning:
            return MockSuccessNewListConfigurator()
        case UITestRunner.failureRunning:
            return MockFailureNewListConfigurator()
        default:
            return NewsListConfigurator()
        }
    }
}
