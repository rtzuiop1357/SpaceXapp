//
//  BaseCollectionViewDatasource.swift
//  SpaceXapp
//
//  Created by vojta on 10.04.2022.
//

import Foundation
import Combine
import UIKit

class BaseCollectionViewDatasource<T> where T:Identifiable {
    
    var data: [T] = []
    
    var source: UICollectionViewDiffableDataSource<Section, T.ID>? = nil
    private var snapshot = NSDiffableDataSourceSnapshot<Section,T.ID>()
    
    var cancellables: Set<AnyCancellable> = []
    
    func update() {
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        
        let array = data.map{ $0.id }
        snapshot.appendItems(array, toSection: .main)

        source?.apply(snapshot, animatingDifferences: true)
    }
    
    func reloadItems(id: T.ID) {
        snapshot.reloadItems([id])
        source?.apply(snapshot)
    }
}
