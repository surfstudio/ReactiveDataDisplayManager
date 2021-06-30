//
//  AppDelegate.swift
//  ReactiveDataDisplayManagerExample
//
//  Created by Никита Коробейников on 09.06.2021.
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
