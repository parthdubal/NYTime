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

        let newsListConfig: Configurator
        switch ProcessInfo.processInfo.isRunningUITest() {
        case .successRunningUITest:
            newsListConfig = MockSuccessNewListConfigurator()
        case .failureRunningUITest:
            newsListConfig = MockFailureNewListConfigurator()
        default:
            newsListConfig = NewsListConfigurator()
        }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController(rootViewController: newsListConfig.build())
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        return true
    }
}
