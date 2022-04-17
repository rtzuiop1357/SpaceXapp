//
//  MainCollectionView.swift
//  SpaceXapp
//
//  Created by vojta on 17.04.2022.
//

import UIKit
import Combine

class MainCollectionView: BaseCollectionView<Flight, MainCollectionViewCell> {
   
    weak var viewModel: MainViewModelProtocol?
    
    func configure(viewModel: MainViewModelProtocol) {
        self.viewModel = viewModel
        
        self.viewModel?.searchCollectionPublisher
            .receive(on: DispatchQueue.main)
            .sink { data in
                self.updateData(data: data)
            }
            .store(in: &cancellables)
    }
    
    init() {
        super.init(frame: .zero)
        collectionView.prefetchDataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createDataSource() {
        guard let datasource = datasource else {
            return
        }
        
        let cellRegistration: UICollectionView.CellRegistration<MainCollectionViewCell, Flight.ID> = .init{ cell, indexPath, flightID  in
    
            guard datasource.data.count > indexPath.item else { return }
            
            let flight = datasource.data[indexPath.row]
            //checking if the flight object has images in it
            //if not than adding default image with SpaceX logo
            if let link = flight.links.images.original.first {
                //checking if we had already downloaded this image
                if let image = ImageStorage.shared.getImage(for: link) {
                    cell.mainImageView.image = image
                }else{
                    //sets placeholder as current image of the cell
                    cell.mainImageView.image = UIImage(named: "placeholder")!
                    self.viewModel?.downloadImage(from: link) { _ in
                        datasource.reloadItems(id: flight.id)
                    }
                }
            }else{
                let size = UIScreen.main.bounds.size
                
                let image = UIImage(named: "SpaceXLogo")!
                    .scalePreservingAspectRatio(targetSize: size)
                cell.mainImageView.image = image
            }
            
            cell.nameLabel.text = flight.name
            
            cell.dateLabel.text = flight.formatedDate
        }
        
        datasource.source = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
    }
    
    override func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let spacing: CGFloat = 10.0
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: spacing,
            bottom: 0,
            trailing: spacing
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: UIDevice.current.orientation == .portrait ? .fractionalWidth(1.0): .fractionalHeight(1.0)
        )
        
        let count = UIDevice.current.orientation == .portrait ? 1 : 2
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: count
        )
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension MainCollectionView: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let datasource = datasource else{ return }
        
        for indexPath in indexPaths {
            let flight = datasource.data[indexPath.item]
            
            if let link = flight.links.images.original.first {
                if nil == ImageStorage.shared.getImage(for: link) {
                    self.viewModel?.downloadImage(from: link) { _ in
                        datasource.reloadItems(id: flight.id)
                    }
                }
            }
        }
    }
}
