//
//  DetailViewModel.swift
//  SpaceX
//
//  Created by vojta on 09.03.2022.
//

import Foundation
import Combine
import UIKit

class DetailViewModel: BaseViewModel, ObservableObject {
    
    //Propeties
    @Published var name: String = ""
    @Published var detail: String = ""
    @Published var failiureText: String = ""
    @Published var dateString: String = ""
    @Published var images: [ImageObject] = []
    @Published var crew: [Crew] = []
    
    var crewDatasource: UICollectionViewDiffableDataSource<Section, Crew.ID>? = nil
    var snapshot: NSDiffableDataSourceSnapshot<Section,Crew.ID> = .init()
    
    var cancellables: Set<AnyCancellable> = []
    
    override func configure<T>(data: T) {
        guard let data = data as? Flight else { fatalError() }
        
        $crew.sink { crew in
            self.updateCrewData()
        }.store(in: &cancellables)
        
        name = data.name
        if let success = data.success {
            failiureText = success ? "succesfull mission" : "mission failed"
        }else{
            failiureText = "currently running mission"
        }
        detail = data.details ?? "no details...."
        dateString = data.formatedDate
        
        downloadImages(links: data.links.images.original)
        
        print(data.crew)
        getCrew(ids: data.crew)
    }

    func downloadImages(links: [String]) {
        guard !links.isEmpty else {
            let defaultImg = UIImage(named: "SpaceXLogo")!
                .scalePreservingAspectRatio(targetSize: UIScreen.main.bounds.size)
            images.append(ImageObject(image: defaultImg))
            return
        }
        
        for link in links {
            if let image = ImageStorage.shared.getRocketImage(for: link) {
                images.append(image)
            }else{
                let url = URL(string: link)!
                Networking.shared.fetchImagefrom(url) { res in
                    switch res {
                    case.success(let data):
                        if let image = UIImage(data: data)?
                            .scalePreservingAspectRatio(targetSize: UIScreen.main.bounds.size) {
                            ImageStorage.shared.store(image, for: link)
                            self.images.append(ImageObject(image: image))
                            print("image!!")
                        }
                    case .failure(let err):
                        print(err)
                    }
                }
            }
        }
    }
    
    func getCrew(ids: [String]) {
        for id in ids {
            Networking.shared.getCrewMember(with: id) { res in
                switch res {
                case.success(let member):
                    self.crew.append(member)
                case .failure(let err):
                    print(err)
                }
            }
        }
    }
}

//MARK: - DetailCrewView datasource
extension DetailViewModel {
    func updateCrewData() {
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        
        let array = crew.map{ $0.id }
        snapshot.appendItems(array, toSection: .main)
        crewDatasource?.apply(snapshot, animatingDifferences: true)
    }
}
