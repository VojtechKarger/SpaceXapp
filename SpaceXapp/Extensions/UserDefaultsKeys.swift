//
//  UserDefaultsKeys.swift
//  SpaceX
//
//  Created by vojta on 18.02.2022.
//

import Foundation
import Combine

enum UserDefaultsKeys: String {
    case image, favourite
}

extension UserDefaults {

    private enum Keys {

        static let image = "image"
        static let featured = "featured"
    }

    // MARK: - filterByImage
    var filterByImage: Bool {
        get {
            let rawValue = bool(forKey: Keys.image)
            return rawValue
        }
        set {
            set(newValue, forKey: Keys.image)
        }
    }
    
    var prevouriousFlights: [Flight.ID] {
        get {
            if let rawValue = array(forKey: Keys.featured) as? [Flight.ID] {
                return rawValue
            }
            return []
        }
        set {
            set(newValue, forKey: Keys.featured)
        }
    }
    
    var filterByImagePublisher: AnyPublisher<Bool, Never> {
        publisher(for: \.filterByImage).eraseToAnyPublisher()
    }

}

