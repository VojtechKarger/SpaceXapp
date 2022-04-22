//
//  BaseCoordinator.swift
//  SpaceXapp
//
//  Created by vojta on 20.04.2022.
//

import UIKit


class BaseCoordinator: NSObject, Coordinator {
    
    weak var parentCoordinator: Coordinator?
    
    var children: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func removeChild() {
        children.removeFirst()
    }
}

