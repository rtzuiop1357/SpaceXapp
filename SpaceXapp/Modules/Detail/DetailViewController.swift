//
//  DetailViewController.swift
//  SpaceX
//
//  Created by vojta on 17.02.2022.
//

import UIKit
import Combine
import SwiftUI

class DetailViewController: BaseViewController {
    
    lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var detailInfoView: DetailInfoView = {
        let view = DetailInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var galeryCollectionView: UIHostingController<DetailGaleryView> = {
        let vc = UIHostingController(rootView: DetailGaleryView(viewModel: viewModel as! DetailViewModel))
        vc.view?.translatesAutoresizingMaskIntoConstraints = false
        return vc
    }()
    
    lazy var crewView: DetailCrewView = {
       let crewView = DetailCrewView(viewModel: viewModel)
        crewView.translatesAutoresizingMaskIntoConstraints = false
        return crewView
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = Colors.bg
        navigationController?.navigationBar.prefersLargeTitles = false
        crewView.createDataSource()
    }

    init(flight: Flight, viewModel: BaseViewModel) {
        super.init(data: flight, viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addSubview(galeryCollectionView.view)
        stackView.addSubview(detailInfoView)
        stackView.addSubview(crewView)
    }
    
    override func addConstrainghts() {
        scrollView.sameConstrainghts(as: view)
        stackView.sameConstrainghts(as: scrollView)
        
        NSLayoutConstraint.activate([
            galeryCollectionView.view.topAnchor.constraint(equalTo: stackView.topAnchor),
            galeryCollectionView.view.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            galeryCollectionView.view.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            galeryCollectionView.view.heightAnchor.constraint(equalToConstant: 400),
            
            detailInfoView.topAnchor.constraint(equalTo: galeryCollectionView.view.bottomAnchor),
            detailInfoView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            detailInfoView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            detailInfoView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            crewView.topAnchor.constraint(equalTo: detailInfoView.bottomAnchor, constant: 5),
            crewView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            crewView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            crewView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            crewView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            crewView.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    override func setUpBindings() {
        guard let viewModel = viewModel as? DetailViewModel else { return }
        
        viewModel.$dateString.sink { text in
            self.detailInfoView.dateLabel.text = text
        }.store(in: &cancellables)
        
        viewModel.$detail.sink { text in
            self.detailInfoView.detailLabel.text = text
        }.store(in: &cancellables)
        
        viewModel.$name.sink { text in
            self.detailInfoView.nameLabel.text = text
        }.store(in: &cancellables)
        
        viewModel.$failiureText.sink { text in
            self.detailInfoView.failiureLabel.text = text
        }.store(in: &cancellables)
    }
    
    func createLayout() -> UICollectionViewLayout {
        guard let viewModel = viewModel as? DetailViewModel else { fatalError() }

        let layoutSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(1.0))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: viewModel.images.count > 1 ? viewModel.images.count : 1
        )
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
