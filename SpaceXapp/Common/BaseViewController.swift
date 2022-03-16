//
//  BaseViewController.swift
//  SpaceX
//
//  Created by vojta on 09.03.2022.
//

import UIKit
import Combine

class BaseViewController: UIViewController {
    
    var viewModel: BaseViewModel?
    
    var cancellables: Set<AnyCancellable> = []
        
    init<T>(data: T, viewModel: BaseViewModel? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.setUpBindings()
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
