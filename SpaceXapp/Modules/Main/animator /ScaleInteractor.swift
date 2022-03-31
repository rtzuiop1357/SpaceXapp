//
//  ScaleInteractor.swift
//  SpaceXapp
//
//  Created by vojta on 31.03.2022.
//

import Foundation
import UIKit

class ScaleInteractor: UIPercentDrivenInteractiveTransition {
    
    var fromVC: UIViewController!
    
    var shouldComplete = false
    var lastProgress: CGFloat?
    
    func attachToVC(vc: UIViewController,view: UIView) {
        fromVC = vc
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(gesture)
    }
    
    @objc
    func handlePan(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view?.superview)
        
        //Represents the percentage of the transition that must be completed before allowing to complete.
        let percentThreshold: CGFloat = 0.2
        //Represents the difference between progress that is required to trigger the completion of the transition.
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
            
            // When swiping back
            if lastProgress > progress {
                shouldComplete = false
                // When swiping quick to the right
            } else if progress > lastProgress + automaticOverrideThreshold {
                shouldComplete = true
            } else {
                // Normal behavior
                shouldComplete = progress > percentThreshold
            }
            update(progress)
            
        case .ended, .cancelled:
            if pan.state == .cancelled || shouldComplete == false {
                cancel()
            } else {
                finish()
            }
            
        default:
            break
        }
        
        lastProgress = progress
        
    }
    
}
