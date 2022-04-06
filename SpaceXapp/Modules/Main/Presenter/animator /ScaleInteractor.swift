//
//  ScaleInteractor.swift
//  SpaceXapp
//
//  Created by vojta on 31.03.2022.
//

import Foundation
import UIKit

final class ScaleInteractor: UIPercentDrivenInteractiveTransition {
    
    weak var fromVC: UIViewController?
    
    weak var scrollPan: UIPanGestureRecognizer?
    
    private var shouldComplete = false
    private var lastProgress: CGFloat?
    
    //doesn't need to be 100% acurate it is there just to not dismiss view when scrollview is scrolling
    private var offset: CGPoint = .zero
    
    func attachToVC(vc: UIViewController, view: UIView) {
        fromVC = vc
        
        let pangesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(pangesture)
        
        scrollPan?.addTarget(self, action: #selector(handlePan))
    }
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateOffset),
                                               name: .scrollViewScrolled,
                                               object: nil)
    }
    
    @objc private
    func updateOffset(notification: Notification) {
        if let object = notification.object as? CGPoint {
            offset = object
        }
    }
    
    @objc private
    func handlePan(pan: UIPanGestureRecognizer) {
        if offset.y > 0 {
            cancel()
            return
        }
        
        let translation = pan.translation(in: pan.view?.superview)
        
        let percentThreshold: CGFloat = 0.2

        let automaticOverrideThreshold: CGFloat = 0.03
        
        let screenHeight: CGFloat = UIScreen.main.bounds.size.width
        var progress: CGFloat = translation.y / screenHeight
        
        progress = fmax(progress, 0)
        progress = fmin(progress, 1)
        
        switch pan.state {
        case .began:
                fromVC?.dismiss(animated: true, completion: nil)
            
        case .changed:
            guard let lastProgress = lastProgress else {return}
            
            if lastProgress > progress {
                shouldComplete = false

            } else if progress > lastProgress + automaticOverrideThreshold {
                shouldComplete = true
            } else {
                shouldComplete = progress > percentThreshold
            }
            self.update(progress)
            
        case .ended, .cancelled:
            if pan.state == .cancelled || shouldComplete == false {
                self.cancel()
            } else {
                self.finish()
            }

        default:
            break
        }
        
        lastProgress = progress
    }
}
