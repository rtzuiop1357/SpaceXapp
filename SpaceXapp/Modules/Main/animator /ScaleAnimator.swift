//
//  ScaleAnimator.swift
//  SpaceXapp
//
//  Created by vojta on 25.03.2022.
//

import UIKit


class ScaleAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
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
    //TODO: make it beter...
    private func present(using context: UIViewControllerContextTransitioning) {
        guard let toVC = context.viewController (forKey: .to) as? DetailViewController else { fatalError() }
        
        context.containerView.addSubview(toVC.view)
        
        let frame = UIScreen.main.bounds
            
        toVC.galeryCollectionView.view.transform = .init(scaleX: imageFrame.width / frame.width,
                                                         y: imageFrame.width / frame.width)
        toVC.galeryCollectionView.view.layer.cornerRadius = 10
        toVC.galeryCollectionView.view.layer.masksToBounds = true
        toVC.view.frame = fromFrame
        
        toVC.crewView.view.isHidden = true
        toVC.detailInfoView.alpha = 0
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear)  {
            toVC.view.frame = UIScreen.main.bounds
            toVC.galeryCollectionView.view.layer.cornerRadius = 0
            toVC.galeryCollectionView.view.transform = .identity
            
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
        
        
        fromVC.view.frame = UIScreen.main.bounds
        fromVC.galeryCollectionView.view.layer.cornerRadius = 0
        
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear)  {
            let frame = UIScreen.main.bounds
                
            fromVC.galeryCollectionView.view.transform = .init(scaleX: self.imageFrame.width / frame.width,
                                                               y: self.imageFrame.width / frame.width)
            fromVC.galeryCollectionView.view.layer.cornerRadius = 10
            fromVC.galeryCollectionView.view.layer.masksToBounds = true
            fromVC.view.frame = self.fromFrame
            
            fromVC.crewView.view.isHidden = true
        } completion: { complete in
            fromVC.crewView.view.isHidden = false
            if context.transitionWasCancelled {
                context.completeTransition(false)
            } else {
                context.completeTransition(true)
            }
        }
    }
}
