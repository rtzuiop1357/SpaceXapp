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
        
        let vc = ViewController(viewModel: MainViewModel(), presenter: MainPresenter())
        let navVC = UINavigationController(rootViewController: vc)
        
        window?.rootViewController = navVC
        window?.makeKeyAndVisible()
    }
}

