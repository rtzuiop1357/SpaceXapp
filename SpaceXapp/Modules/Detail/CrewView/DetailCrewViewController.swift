//
//  DetailCrewView.swift
//  SpaceXapp
//
//  Created by vojta on 16.03.2022.
//

import UIKit

class DetailCrewViewController: BaseViewController<[String]> {
    
    lazy var crewCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    override init(viewModel: BaseViewModel<[String]>? = nil) {
        super.init(viewModel: viewModel)
        createDataSource()
    }
    
    override init(data: [String], viewModel: BaseViewModel<[String]>? = nil) {
        super.init(data: data, viewModel: viewModel)
        createDataSource()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 200, height: 200)
        //layout.estimatedItemSize = CGSize(width: 200, height: 200)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 0)
        return layout
    }

    override func addViews() {
        view.addSubview(crewCollectionView)
    }
    
    override func addConstrainghts() {
        crewCollectionView.sameConstrainghts(as: view)
    }

    func createDataSource() {
        guard let viewModel = viewModel as? CrewViewModel else { fatalError() }
        
        let cellRegistration = UICollectionView.CellRegistration<DetailCrewCell, Crew.ID> {
            cell, indexPath, itemIdentifier in
            let crew = viewModel.crew[indexPath.item]
            cell.configure(data: crew)
            let image = ImageStorage.shared.getImage(for: crew.image) ?? UIImage(named: "placeholder")!
            cell.setImage(image)
        }
        
        viewModel.crewDatasource = UICollectionViewDiffableDataSource<Section, Crew.ID>.init(collectionView: crewCollectionView) {
            collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
        
        viewModel.updateCrewData()
    }
}
