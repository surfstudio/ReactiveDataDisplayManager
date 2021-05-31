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
        let rddmColor = UIColor(named: "RDDMMainColor")
        UIBarButtonItem.appearance().tintColor = rddmColor
        UITabBar.appearance().tintColor = rddmColor
        UITableView.appearance().sectionIndexColor = rddmColor
        UICollectionView.appearance().tintColor = rddmColor
        return true
    }

}
