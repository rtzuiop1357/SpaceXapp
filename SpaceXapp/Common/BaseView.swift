//
//  BaseView.swift
//  SpaceX
//
//  Created by vojta on 09.03.2022.
//

import UIKit


class BaseView<T>: UIView {

    weak var viewModel: BaseViewModel<T>? = nil
    
    init(viewModel: BaseViewModel<T>? = nil) {
        super.init(frame: .zero)
        addViews()
        addConstraints()
        self.viewModel = viewModel
        
        NotificationCenter.default.addObserver(forName: .changedOrientation, object: nil, queue: nil) { _ in
            self.constraints.forEach({ constrainght in
                self.removeConstraint(constrainght)
            })
            self.addConstraints()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addViews() {}
    
    func addConstraints() {}
}
