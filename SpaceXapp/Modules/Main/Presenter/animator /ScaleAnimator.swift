//
//  ScaleAnimator.swift
//  SpaceXapp
//
//  Created by vojta on 25.03.2022.
//

import UIKit

final class ScaleAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval
    
    var animationType: AnimationType!

    var fromFrame: CGRect!
    var imageFrame: CGRect!
    
    enum AnimationType { case present, dismiss }
    
    init(duration: TimeInterval) {
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
    
    private func present(using context: UIViewControllerContextTransitioning) {
        guard let toVC = context.viewController (forKey: .to) as? DetailViewController else { fatalError() }
        
        context.containerView.addSubview(toVC.view)
        
        let frame = UIScreen.main.bounds
            
        toVC.galeryCollectionView.transform = .init(scaleX: imageFrame.width / frame.width,
                                                         y: imageFrame.width / frame.width)
        toVC.galeryCollectionView.layer.cornerRadius = 10
        toVC.galeryCollectionView.layer.masksToBounds = true
        toVC.view.frame = fromFrame
        
        toVC.crewView.view.isHidden = true
        toVC.detailInfoView.alpha = 0
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear)  {
            toVC.view.frame = UIScreen.main.bounds
            toVC.galeryCollectionView.layer.cornerRadius = 0
            toVC.galeryCollectionView.transform = .identity
            
            toVC.detailInfoView.alpha = 1
        } completion: { complete in
            toVC.crewView.view.isHidden = false
            if context.transitionWasCancelled {
                context.completeTransition(false)
            } else {
                context.completeTransition(true)
            }
        }
    }
    
    private func dismiss(using context: UIViewControllerContextTransitioning){
        guard let fromVC = context.viewController (forKey: .from) as? DetailViewController,
              let toVC = context.viewController(forKey: .to)
        else { fatalError() }
        
        context.containerView.addSubview(fromVC.view)
        context.containerView.insertSubview(toVC.view, belowSubview: fromVC.view)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear)  {
            fromVC.view.transform = .init(translationX: 0, y: UIScreen.main.bounds.height / 1.25)
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
