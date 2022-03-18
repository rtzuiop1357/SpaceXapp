//
//  BaseView.swift
//  SpaceX
//
//  Created by vojta on 09.03.2022.
//

import UIKit


class BaseView: UIView {

    weak var viewModel: BaseViewModel? = nil
    
    init(viewModel: BaseViewModel? = nil) {
        super.init(frame: .zero)
        addViews()
        addConstraints()
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {}
    
    func addConstraints() {}
}
