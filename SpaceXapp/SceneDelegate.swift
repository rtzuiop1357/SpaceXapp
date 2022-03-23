//
//  SceneDelegate.swift
//  SpaceXapp
//
//  Created by vojta on 14.03.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        
        let vc = ViewController(viewModel: MainViewModel(isFavourite: false))
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 0)
        let navVC = MainNavigationView(rootViewController: vc)
        
        let favVC = ViewController(viewModel: MainViewModel(isFavourite: true))
        favVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        let favNavVC = MainNavigationView(rootViewController: favVC)
        
        let vcs = [navVC, favNavVC]
        
        let tabController = UITabBarController()
        tabController.setViewControllers(vcs, animated: false)
        
        window?.rootViewController = tabController
        window?.makeKeyAndVisible()
    }
}

