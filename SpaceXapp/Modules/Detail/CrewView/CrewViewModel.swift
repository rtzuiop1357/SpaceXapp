//
//  CrewViewModel.swift
//  SpaceXapp
//
//  Created by vojta on 20.03.2022.
//

import UIKit

class CrewViewModel: BaseViewModel {
    
    @Published var crew: [Crew] = []
    
    var crewDatasource: UICollectionViewDiffableDataSource<Section, Crew.ID>? = nil
    var snapshot = NSDiffableDataSourceSnapshot<Section,Crew.ID>()
    
    override func configure<T>(data: T) {
        guard let data = data as? [String] else { fatalError() }
        
        getCrew(ids: data)
    }
    
    func getCrew(ids: [String]) {
        for id in ids {
            Networking.shared.getCrewMember(with: id) { res in
                switch res {
                case.success(let member):
                    self.crew.append(member)
                    self.updateCrewData()
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    func getImage(for link: String) {
        if ImageStorage.shared.getImage(for: link) != nil {
            updateCrewData()
        }else{
            let url = URL(string: link)!
            Networking.shared.fetchImagefrom(url) { res in
                switch res {
                case.success(let data):
                    guard let image = UIImage(data: data)?
                            .scalePreservingAspectRatio(targetSize: UIScreen.main.bounds.size)
                    else { return }
                    ImageStorage.shared.store(image, for: link)
                    
                    self.updateCrewData()
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
    
    func updateCrewData() {
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        
        let array = crew.map{ $0.id }
        snapshot.appendItems(array, toSection: .main)
        
        print(crew)
        
        crewDatasource!.apply(snapshot, animatingDifferences: true)
    }
}