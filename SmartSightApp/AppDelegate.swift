//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//
import Foundation
import UIKit
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCordinator: RootCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        appCordinator = RootCoordinator(window: window)
        appCordinator?.start()
        return true
    }
}
