//
//  AppDelegate.swift
//  SampleEventHandling
//
//  Created by Alexander Kravchenkov on 01.08.17.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.initializeKeyWindow()
        return true
    }

    func initializeKeyWindow() {

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let root = TableScreenConfigurator().configure()

        self.window?.rootViewController = root
        self.window?.makeKeyAndVisible()
    }

}

