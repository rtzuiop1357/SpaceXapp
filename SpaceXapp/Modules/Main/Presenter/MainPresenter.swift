//
//  MainPresenter.swift
//  SpaceXapp
//
//  Created by vojta on 25.03.2022.
//

import UIKit

final class MainPresenter: BasePresenter {
    
    var fromFrame: CGRect!
    var imageFrame: CGRect!
    
    private var interactor: ScaleInteractor?
    private var animator: ScaleAnimator?
    
    override init() {
        super.init()
        animator = ScaleAnimator(duration: 0.9)
        interactor = ScaleInteractor()
    }
    
    override func present<T>(data: T) {
        guard let flight = data as? Flight else { return }
        
        let hasCrew = !flight.crew.isEmpty
        
        let vm = DetailViewModel()
        let vc = DetailViewController(flight: flight, hasCrew: hasCrew, viewModel: vm)
        
        vc.modalPresentationStyle = .fullScreen
        vc.transitioningDelegate = self
        
        animator?.fromFrame = fromFrame
        animator?.imageFrame = imageFrame
        
        interactor?.scrollPan = vc.scrollView.panGestureRecognizer
        interactor?.attachToVC(vc: vc, view: vc.view)
        
        parent?.present(vc, animated: true)
    }
}

extension MainPresenter: UIViewControllerTransitioningDelegate {
    
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
