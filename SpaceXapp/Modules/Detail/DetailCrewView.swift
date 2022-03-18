//
//  DetailCrewView.swift
//  SpaceXapp
//
//  Created by vojta on 16.03.2022.
//

import UIKit

class DetailCrewView: BaseView {
    
    lazy var crewCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        return collectionView
    }()
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalWidth(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                         leading: 4,
                                                         bottom: 0,
                                                         trailing: 4)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                                   heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPagingCentered
            
            return section
        }
        return layout
    }

    override func addViews() {
        addSubview(crewCollectionView)
    }
    
    override func addConstraints() {
        crewCollectionView.sameConstrainghts(as: self)
    }
    
    func createDataSource() {
        guard let viewModel = viewModel as? DetailViewModel else { return }
        
        crewCollectionView.register(DetailCrewCell.self, forCellWithReuseIdentifier: DetailCrewCell.identifier)
        
        viewModel.crewDatasource = .init(collectionView: crewCollectionView) {
            collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DetailCrewCell.identifier,
                for: indexPath) as! DetailCrewCell
            cell.configure(data: viewModel.crew[indexPath.item])
            return cell
        }
    }
}
