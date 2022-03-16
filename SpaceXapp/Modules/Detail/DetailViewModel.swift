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
        
    override func configure<T>(data: T) {
        guard let data = data as? Flight else { fatalError() }
        
        name = data.name
        if let success = data.success {
            failiureText = success ? "succesfull mission" : "mission failed"
        }else{
            failiureText = "currently running mission"
        }
        detail = data.details ?? "no details...."
        dateString = data.formatedDate
        
        downloadImages(links: data.links.images.original)
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
}
