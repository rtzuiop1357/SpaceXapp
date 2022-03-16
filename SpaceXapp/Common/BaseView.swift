//
//  BaseView.swift
//  SpaceX
//
//  Created by vojta on 09.03.2022.
//

import UIKit


class BaseView: UIView {

    init() {
        super.init(frame: .zero)
        addViews()
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {}
    
    func addConstraints() {}
}
