//
//  MainViewModelProtocol.swift
//  SpaceXapp
//
//  Created by vojta on 30.03.2022.
//

import UIKit
import Combine

protocol MainViewModelProtocol: BaseViewModel<Any> {
    
    var filterByImagePublisher: Published<Bool>.Publisher { get }
    
    var searchCollectionOfFlights: [Flight] { get set }
    
    var filterByImage: Bool { get set }
    
    var sorted: ComparisonResult { get set }
    
    var dataSource: UICollectionViewDiffableDataSource<Section,Flight.ID>? { get set }
    
    func search(text: String)
    
    func bind()
    
    func setItemNeedsUpdate(id: Flight.ID)
    
    func clearSearch()
    
    func downloadImage(from link: String, completion: @escaping(UIImage) -> Void)
    
    func updateData(sort: Bool)
    
    func handleRefresh(_ completion: @escaping()-> Void)
    
    func setInitialData()
}
