//
//  ViewExtensions.swift
//  SpaceXapp
//
//  Created by vojta on 15.03.2022.
//

import Foundation
import UIKit

extension UIView {
    func sameConstrainghts(as view: UIView) {
        NSLayoutConstraint.activate([
            self.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            self.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
}
