//
//  BaseTransitioningDelegate.swift
//  SpaceXapp
//
//  Created by vojta on 17.04.2022.
//

import UIKit

class BaseTransitionDelegate<VC, Animator,Interactor>: NSObject, UIViewControllerTransitioningDelegate
where Animator: BaseAnimator,
      Interactor: UIViewControllerInteractiveTransitioning,
      VC: UIViewController {
    
    var interactor: Interactor?
    var animator: Animator?
    
    func attach(to vc: VC) {
        vc.transitioningDelegate = self
    }
    
    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator?.animationType = .present
        return animator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator?.animationType = .dismiss
        return animator
    }
}

