//
//  Coordinator.swift
//  SpaceXapp
//
//  Created by vojta on 17.04.2022.
//

import UIKit

protocol Coordinator {
    var parentCoordinator: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController : UINavigationController { get set }
    
    func start()
}
