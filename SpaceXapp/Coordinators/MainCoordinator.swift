//
//  MainCoordinator.swift
//  SpaceXapp
//
//  Created by vojta on 17.04.2022.
//

import UIKit

class MainCoordinator: BaseCoordinator {
    
    let networking: Networker
    
    init(networker: Networker, navigationController: UINavigationController) {
        networking = networker
        super.init(navigationController: navigationController)
    }
    
    func start() {
        pushMainVC()
    }
    
    func presentDetail(flight: Flight, fromFrame: CGRect, imageFrame: CGRect) {
        let detailCoordinator = DetailCoordinator(navigationController: navigationController, networker: networking)
        detailCoordinator.start(with: flight, imageFrame: imageFrame, cellFrame: fromFrame)
        detailCoordinator.parentCoordinator = self
                
        children.append(detailCoordinator)
    }
    
    override func removeChild() {
        super.removeChild()
        
        navigationController.navigationBar.isHidden = false
    }
    
    func pushMainVC() {
        let viewModel = MainViewModel(networker: networking)
        
        viewModel.coordinator = self
    
        let vc = ViewController(viewModel: viewModel)
        navigationController.pushViewController(vc, animated: false)
    }
    
}
