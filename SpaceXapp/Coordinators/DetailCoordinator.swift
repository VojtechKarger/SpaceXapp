//
//  DetailCoordinator.swift
//  SpaceXapp
//
//  Created by vojta on 20.04.2022.
//

import UIKit

class DetailCoordinator: BaseCoordinator {
    
    var animator: ScaleAnimator?
    var interactor: ScaleInteractor?
    
    override init(navigationController: UINavigationController) {
        animator = ScaleAnimator(duration: 0.95)
        interactor = ScaleInteractor()
        
        super.init(navigationController: navigationController)
    }
    
    func start(with flight: Flight, imageFrame: CGRect, cellFrame: CGRect) {
        
        let viewModel = DetailViewModel()
        let vc = DetailViewController(flight: flight, hasCrew: !flight.crew.isEmpty, viewModel: viewModel)
        
        //seting up the interactor and the animator
        interactor?.scrollPan = vc.scrollView.panGestureRecognizer
        interactor?.attachToVC(vc: vc, view: vc.view)
        
        //frames for better looking transition...
        animator?.fromFrame = cellFrame
        animator?.imageFrame = imageFrame
        
        vc.transitioningDelegate = self
        
        navigationController.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func dismissing() {
        navigationController.delegate = nil
        parentCoordinator?.removeChild()
        log("destroing: \(self)")
    }
    
}


extension DetailCoordinator: UIViewControllerTransitioningDelegate,
                             UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning)
    -> UIViewControllerInteractiveTransitioning? {
        if animator?.animationType == .dismiss {
                return interactor
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .pop:
            animator?.animationType = .dismiss
            return animator
        case .push:
            animator?.animationType = .present
            return animator
        default:
            return nil
        }
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented as? DetailViewController != nil {
            animator?.animationType = .present
            return animator
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed as? DetailViewController != nil {
            animator?.animationType = .dismiss
            return animator
        }
        return nil
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        interactor
    }
}
