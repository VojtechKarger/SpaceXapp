//
//  Animator.swift
//  SpaceXapp
//
//  Created by vojta on 17.04.2022.
//

import UIKit

class BaseAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var animationType: AnimationType?
    
    enum AnimationType { case present, dismiss }
    
    let duration: TimeInterval
    
    required init(duration: TimeInterval) {
        self.duration = duration
    }

    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch animationType {
        case .present:
            present(using: transitionContext)
        case .dismiss:
            dismiss(using: transitionContext)
        case .none:
            fatalError()
        }
    }
    
    func dismiss(using context: UIViewControllerContextTransitioning) {
        fatalError()
    }
    
    func present(using transitionContext: UIViewControllerContextTransitioning) {
        fatalError()
    }
}
