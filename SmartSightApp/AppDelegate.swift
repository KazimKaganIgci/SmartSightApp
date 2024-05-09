//
//  AppDelegate.swift
//  NewsApp
//
//  Created by Kazım Kağan İğci on 3.12.2023.
//
import Foundation
import UIKit

protocol MainProtocol {
    func getMainCoordinator(coordinator: RootCoordinator)
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCordinator: RootCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        appCordinator = RootCoordinator()
        appCordinator?.start()
        return true
    }




}


