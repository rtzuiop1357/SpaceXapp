//
//  DetailViewModel.swift
//  SpaceX
//
//  Created by vojta on 09.03.2022.
//

import Foundation
import Combine
import UIKit

final class DetailViewModel: BaseViewModel<Flight>,
                             DetailViewModelProtocol,
                             ObservableObject {
    
    //Propeties
    @Published var name: String = ""
    @Published var detail: String = ""
    @Published var failiureText: String = ""
    @Published var dateString: String = ""
    @Published var images: [ImageObject] = []
    
    var imagesPublisher: Published<[ImageObject]>.Publisher { $images}
    
    var id: String = ""
    
    override func configure(data: Flight) {
                
        name = data.name
        if let success = data.success {
            failiureText = success ? "succesfull mission" : "mission failed"
        }else{
            failiureText = "currently running mission"
        }
        detail = data.details ?? "no details...."
        dateString = data.formatedDate
        
        id = data.id
        
        downloadImages(links: data.links.images.original)
    }

    private func downloadImages(links: [String]) {
        guard !links.isEmpty else {
            let defaultImg = UIImage(named: "SpaceXLogo")!
                .scalePreservingAspectRatio(targetSize: UIScreen.main.bounds.size)
            images.append(ImageObject(id: UUID().uuidString, image: defaultImg))
            return
        }
        
        for link in links {
            if let image = ImageStorage.shared.getImageObject(for: link) {
                images.append(image)
            }else{
                let url = URL(string: link)!
                Networking.shared.fetchImagefrom(url) { res in
                    switch res {
                    case.success(let data):
                        if let image = UIImage(data: data)?
                            .scalePreservingAspectRatio(targetSize: UIScreen.main.bounds.size) {
                            ImageStorage.shared.store(image, for: link)
                            self.images.append(ImageObject(id: UUID().uuidString, image: image))
                        }
                    case .failure(let err):
                        print(err)
                    }
                }
            }
        }
    }
}
