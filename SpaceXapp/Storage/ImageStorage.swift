//
//  ImageStorage.swift
//  SpaceXapp
//
//  Created by vojta on 16.03.2022.
//

import Foundation
import UIKit


class ImageStorage {
    
    static let shared = ImageStorage()
    
    private init() {}
    
    private var images: [String: ImageObject] = [:]
    
    public func store(_ image: UIImage, for id: String) {
        images[id] = ImageObject(id: id, image: image)
    }
    
    public func getImage(for id: String) -> UIImage? {
        return images[id]?.image
    }
    
    public func getImageObject(for id: String) -> ImageObject? {
        return images[id]
    }
    
    public func clear() {
        images = [:]
    }
}
