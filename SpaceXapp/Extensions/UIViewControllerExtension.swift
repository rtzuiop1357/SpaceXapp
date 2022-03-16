//
//  UIViewControllerExtension.swift
//  SpaceX
//
//  Created by vojta on 18.02.2022.
//

import Foundation
import UIKit


extension UIViewController {
    func presentAlert(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .default))
        self.present(ac, animated: true)
    }
}

