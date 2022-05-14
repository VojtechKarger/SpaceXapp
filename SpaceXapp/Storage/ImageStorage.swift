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
    
    private init() {
        images.countLimit = 100
    }
    
    private var images: NSCache<NSString,ImageObject> = .init()
    
    public func store(_ image: UIImage, for id: String) {
        images.setObject(ImageObject(id: id, image: image), forKey: id as NSString)
    }
    
    public func getImage(for id: String) -> UIImage? {
        return images.object(forKey: id as NSString)?.image
    }
    
    public func getImageObject(for id: String) -> ImageObject? {
        return images.object(forKey: id as NSString)
    }
    
    public func clear() {
        images.removeAllObjects()
    }
}
