//
//  DetailViewController.swift
//  SpaceX
//
//  Created by vojta on 17.02.2022.
//
import UIKit
import Combine
import SwiftUI

class DetailViewController: BaseViewController<Flight> {
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var panGesture: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(dismissPanAction))
    }()
    
    lazy var detailInfoView: DetailInfoView = {
        let view = DetailInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
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
    
    lazy var galeryCollectionView: SwiftUIView<DetailGaleryView<DetailViewModel>> = {
        let galery = SwiftUIView(DetailGaleryView<DetailViewModel>(viewModel: viewModel as! DetailViewModel))
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
    
    let hasCrew: Bool
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = Colors.bg
        navigationController?.navigationBar.prefersLargeTitles = false
        
        scrollView.delegate = self

        view.addGestureRecognizer(panGesture)
        
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
        stackView.sameConstrainghts(as: scrollView)
        
        NSLayoutConstraint.activate([
            
            dismissBTN.topAnchor.constraint(equalTo: view.topAnchor, constant: 25),
            dismissBTN.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 10),
            dismissBTN.widthAnchor.constraint(equalToConstant: 30),
            dismissBTN.heightAnchor.constraint(equalToConstant: 30),
            
            galeryCollectionView.topAnchor.constraint(equalTo: stackView.topAnchor),
            galeryCollectionView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            galeryCollectionView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            galeryCollectionView.heightAnchor.constraint(equalToConstant: 400),
            
            detailInfoView.topAnchor.constraint(equalTo: galeryCollectionView.bottomAnchor),
            detailInfoView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            detailInfoView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            detailInfoView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
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
    
    @objc func dismissBTNpressed() {
        dismiss(animated: false)
    }
    
    @objc func dismissPanAction(_ sender: UIPanGestureRecognizer? = nil) {
        if (sender?.translation(in: self.view).y)! > 100 { dismiss(animated: false) }
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

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < -100 { self.dismiss(animated: true) }
    }
}
