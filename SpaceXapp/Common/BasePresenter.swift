//
//  BasePresenter.swift
//  SpaceXapp
//
//  Created by vojta on 25.03.2022.
//

import UIKit

class BasePresenter: NSObject {
    
    weak var parent: UIViewController?
    
    func present<T>(data: T) { fatalError() }
    func dismiss() { parent?.dismiss(animated: true) }
}
