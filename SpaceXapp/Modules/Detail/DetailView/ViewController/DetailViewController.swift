//
//  DetailViewController.swift
//  SpaceX
//
//  Created by vojta on 17.02.2022.
//
import UIKit
import Combine
import SwiftUI

final class DetailViewController: BaseViewController<Flight> {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var detailInfoView: DetailInfoView = {
        let view = DetailInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.insetsLayoutMarginsFromSafeArea = true
        return view
    }()
    
    lazy var dismissBTN: UIButton = {
        let btn = UIButton()
        let image = UIImage(systemName: "xmark")
        btn.setImage(image, for: .normal)
        btn.imageView?.tintColor = .white
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.zPosition = 9999
        btn.addTarget(self, action: #selector(dismissBTNpressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var galeryCollectionView: GaleryView = {
       let galery = GaleryView()
        galery.translatesAutoresizingMaskIntoConstraints = false
        
        return galery
    }()
    
    lazy var crewView: DetailCrewViewController = {
        let crewView = DetailCrewViewController(viewModel: CrewViewModel())
        crewView.view.translatesAutoresizingMaskIntoConstraints = false
        return crewView
    }()
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let hasCrew: Bool
        
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        galeryCollectionView.collectionView.setCollectionViewLayout(createLayout(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = Colors.bg
        navigationController?.navigationBar.prefersLargeTitles = false
        
        scrollView.delegate = self
                
        if hasCrew {
            crewView.createDataSource()
        }
    }
    
    init(flight: Flight, hasCrew: Bool, viewModel: DetailViewModelProtocol) {
        self.hasCrew = hasCrew
        
        super.init(data: flight, viewModel: viewModel)
        
        //configuring crewView viewModel
        if hasCrew {
            crewView.configure(data: flight.crew)
        }
        
        galeryCollectionView.configure(data: [], viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        stackView.addSubview(galeryCollectionView)
        stackView.addSubview(detailInfoView)
        stackView.addSubview(crewView.view)
        stackView.addSubview(dismissBTN)
    }
    
    override func addConstrainghts() {
        scrollView.sameConstrainghts(as: view)
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        stackView.sameConstrainghts(as: scrollView)
        
        NSLayoutConstraint.activate([
            dismissBTN.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            dismissBTN.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 10),
            dismissBTN.widthAnchor.constraint(equalToConstant: 30),
            dismissBTN.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        let screen = UIScreen.main.bounds
        let height = min(screen.height, screen.width)
        NSLayoutConstraint.activate([
            galeryCollectionView.topAnchor.constraint(equalTo: stackView.topAnchor),
            galeryCollectionView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            galeryCollectionView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            galeryCollectionView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            galeryCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            galeryCollectionView.heightAnchor.constraint(equalToConstant: height),
        ])
        
        NSLayoutConstraint.activate([

            detailInfoView.topAnchor.constraint(equalTo: galeryCollectionView.bottomAnchor),
            detailInfoView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            detailInfoView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            detailInfoView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            crewView.view.topAnchor.constraint(equalTo: detailInfoView.bottomAnchor,
                                               constant: 5),
            crewView.view.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            crewView.view.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            crewView.view.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            crewView.view.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
        
        if hasCrew {
            crewView.view.heightAnchor.constraint(equalToConstant: 240).isActive = true
        }else{
            crewView.view.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        
    }
    
    @objc private
    func dismissBTNpressed() {
        dismiss(animated: false)
    }
    
    override func setUpBindings() {
        guard let viewModel = viewModel as? DetailViewModel else { return }
        
        viewModel.$dateString.sink { [weak self] text in
            self?.detailInfoView.dateLabel.text = text
        }.store(in: &cancellables)
        
        viewModel.$detail.sink { [weak self] text in
            self?.detailInfoView.detailLabel.text = text
        }.store(in: &cancellables)
        
        viewModel.$name.sink { [weak self] text in
            self?.detailInfoView.nameLabel.text = text
        }.store(in: &cancellables)
        
        viewModel.$failiureText.sink { [weak self] text in
            self?.detailInfoView.failiureLabel.text = text
        }.store(in: &cancellables)
    }
    
    private func createLayout() -> UICollectionViewLayout {
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

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: .scrollViewScrolled, object: scrollView.contentOffset)
    }
}
