//
//  ScaleAnimator.swift
//  SpaceXapp
//
//  Created by vojta on 25.03.2022.
//

import UIKit

final class ScaleAnimator: BaseAnimator {
    
    var fromFrame: CGRect!
    var imageFrame: CGRect!
    
    override func present(using context: UIViewControllerContextTransitioning) {
        let orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation

        switch orientation {
        case .portrait, .portraitUpsideDown: presentForPortrait(using: context)
        case.landscapeLeft,.landscapeRight: presentForLandScape(using: context)
        default: presentForLandScape(using: context)
        }
    }
    
    private func presentForLandScape(using context: UIViewControllerContextTransitioning) {
        guard let toVC = context.viewController (forKey: .to) as? DetailViewController else { fatalError() }
        
        context.containerView.addSubview(toVC.view)
        
        toVC.view.transform = .init(scaleX: 0.5, y: 0.5)
        toVC.view.alpha = 0
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveLinear)  {
            toVC.view.transform = .identity
            toVC.view.alpha = 1
            
        } completion: { complete in
            if context.transitionWasCancelled {
                context.completeTransition(false)
            } else {
                context.completeTransition(true)
            }
        }
    }
    
    private func presentForPortrait(using context: UIViewControllerContextTransitioning) {
        guard let toVC = context.viewController (forKey: .to) as? DetailViewController else { fatalError() }
        
        context.containerView.addSubview(toVC.view)
        
        let frame = UIScreen.main.bounds
        toVC.dismissBTN.layer.opacity = 0
        toVC.galeryCollectionView.transform = .init(scaleX: imageFrame.width / frame.width,
                                                         y: imageFrame.width / frame.width)
        toVC.galeryCollectionView.layer.cornerRadius = 10
        toVC.galeryCollectionView.layer.masksToBounds = true
        toVC.view.frame = fromFrame
        
        toVC.crewView.isHidden = true
        toVC.detailInfoView.alpha = 0
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 0.9,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseOut)  {
            
            toVC.view.frame = UIScreen.main.bounds
            toVC.galeryCollectionView.layer.cornerRadius = 0
            toVC.galeryCollectionView.transform = .identity
            
            toVC.dismissBTN.layer.opacity = 1
            toVC.detailInfoView.alpha = 1
        } completion: { complete in
            toVC.crewView.isHidden = false
            if context.transitionWasCancelled {
                context.completeTransition(false)
            } else {
                context.completeTransition(true)
            }
        }
    }
    
    
    override func dismiss(using context: UIViewControllerContextTransitioning) {
        guard
            let fromVC = context.viewController(forKey: .from) as? DetailViewController,
            let toVC = context.viewController(forKey: .to)
        else { fatalError() }
        
        context.containerView.addSubview(fromVC.view)
        context.containerView.insertSubview(toVC.view,
                                            belowSubview: fromVC.view)
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveLinear)  {
            
            fromVC.view.transform = .init(scaleX: 0.5, y: 0.5)
            fromVC.view.alpha = 0
        } completion: { complete in
            if context.transitionWasCancelled {
                context.completeTransition(false)
            } else {
                context.completeTransition(true)
            }
        }
    }
}
