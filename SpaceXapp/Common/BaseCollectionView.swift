//
//  BaseCollectionView.swift
//  SpaceXapp
//
//  Created by vojta on 10.04.2022.
//

import Foundation
import UIKit

class BaseCollectionView<T, Cell>: UIView where T: Identifiable,
                                                Cell: BaseCell<T> {
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    func createLayout() -> UICollectionViewLayout {
        fatalError("no layout")
    }
    
    var datasource: BaseCollectionViewDatasource<T>? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        
        datasource = BaseCollectionViewDatasource()
        
        createDataSource()
        
        NotificationCenter.default.addObserver(forName: .changedOrientation, object: nil, queue: nil) { _ in
            self.collectionView.setCollectionViewLayout(self.createLayout(), animated: true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: [T]) {
        datasource?.data = data
    }
    
    func createDataSource() {
        guard let datasource = datasource else {
            return
        }
        
        let cellRegistration = UICollectionView.CellRegistration<Cell, T.ID> {
            cell, indexPath, itemIdentifier in
            guard datasource.data.count > indexPath.item else{ return }
            
            let data = datasource.data[indexPath.item]
            cell.configure(data: data)
        }
        
        datasource.source = UICollectionViewDiffableDataSource<Section, T.ID>.init(collectionView: collectionView) {
            collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
    }
    
    
    private func setup() {
        addSubview(collectionView)
        collectionView.sameConstrainghts(as: self)
    }
}



