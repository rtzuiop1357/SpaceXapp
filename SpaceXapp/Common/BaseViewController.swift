//
//  BaseViewController.swift
//  SpaceX
//
//  Created by vojta on 09.03.2022.
//

import UIKit
import Combine

class BaseViewController<T>: UIViewController {
    
    var viewModel: BaseViewModel<T>?
    
    var cancellables: Set<AnyCancellable> = []
        
    init(data: T, viewModel: BaseViewModel<T>? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.setUpBindings()
        self.viewModel?.configure(data: data)
    }
    
    init(viewModel: BaseViewModel<T>? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.setUpBindings()
    }
    
    /// override if you use init(viewModel: BaseViewModel? = nil) must be caled from the view Controller that presents this controller
    /// or you can use it to reconfigure ViewModel
    func configure(data: T) {
        self.viewModel?.configure(data: data)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func configureViews() {
        addViews()
        addConstrainghts()
    }
    
    func addViews() { fatalError() }
    
    func addConstrainghts() { fatalError() }
    
    func setUpBindings() {}
}
