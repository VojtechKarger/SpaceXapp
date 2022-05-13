//
//  RocketImage.swift
//  SpaceXapp
//
//  Created by vojta on 16.03.2022.
//

import Foundation
import UIKit

class ImageObject: Identifiable {
    let id: String
    var image: UIImage
    
    init(id: String, image: UIImage) {
        self.id = id
        self.image = image
    }
}
