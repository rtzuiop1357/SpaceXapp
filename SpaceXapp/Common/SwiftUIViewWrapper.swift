//
//  SwiftUIViewWrapper.swift
//  SpaceXapp
//
//  Created by vojta on 30.03.2022.
//

import SwiftUI
import UIKit

class SwiftUIView<T>: BaseView<Any> where T: View {
    
    var view: T
    
    lazy var hoastingController: UIHostingController<T> = {
        let controller = UIHostingController(rootView: view)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        return controller
    }()
    
    init(_ view: T) {
        self.view = view
        super.init(viewModel: nil)
    }
    
    override func addViews() {
        addSubview(hoastingController.view)
    }
    
    override func addConstraints() {
        hoastingController.view.sameConstrainghts(as: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
