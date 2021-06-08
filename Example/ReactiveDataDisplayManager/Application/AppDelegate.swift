//
//  AppDelegate.swift
//  ReactiveDataDisplayManager
//
//  Created by Ivan Smetanin on 18/12/2017.
//  Copyright © 2017 Alexander Kravchenkov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIBarButtonItem.appearance().tintColor = .rddm
        UITabBar.appearance().tintColor = .rddm
        UITableView.appearance().sectionIndexColor = .rddm
        UICollectionView.appearance().tintColor = .rddm
        return true
    }

}
