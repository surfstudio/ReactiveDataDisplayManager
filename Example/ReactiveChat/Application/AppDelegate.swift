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

    // MARK: - Properties

    var window: UIWindow?

    // MARK: - Clients

    @Socket
    var socketClient: SocketClient

    // MARK: - Lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIBarButtonItem.appearance().tintColor = .rddm
        UITabBar.appearance().tintColor = .rddm
        UITableView.appearance().sectionIndexColor = .rddm
        UICollectionView.appearance().tintColor = .rddm

        socketClient.connect()

        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        socketClient.connect()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        socketClient.disconnect()
    }

}
