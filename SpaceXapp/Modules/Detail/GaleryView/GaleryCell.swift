//
//  GaleryCell.swift
//  SpaceXapp
//
//  Created by vojta on 10.04.2022.
//

import Foundation
import UIKit

class GaleryCell: BaseCell<UIImage> {
    
    lazy var imageView: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    override func addViews() {
        addSubview(imageView)
    }
    
    override func addConstraints() {
        imageView.sameConstrainghts(as: self)
    }
    
    override func configure(data: UIImage) {
        imageView.image = data
    }
}
