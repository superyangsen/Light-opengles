//
//  AppDelegate.swift
//  Light
//
//  Created by 3i_yang on 2020/10/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window?.rootViewController = TestViewController()
        
        return true
    }

}

