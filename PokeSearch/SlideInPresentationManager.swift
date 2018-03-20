//
//  SlideInTransitionManager.swift
//  PokeSearch
//
//  Created by Shruti Sharma on 2/23/18.
//  Copyright © 2018 Shruti Sharma. All rights reserved.
//

import Foundation
import UIKit

enum PresentationDirection {
    case left
    case right
    case bottom
    case top
}

class SlideInPresentationManager: NSObject, UIViewControllerTransitioningDelegate {
    
    var direction: PresentationDirection = .bottom
    
    var disableCompactHeight = false

    /* This function returns a presentation controller that manages the presentation of a view controller. We return an instance of the SlideInPresentationController we created.
     */
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        
        let presentationController = SlideInPresentationController(presentedViewController: presented, presenting: presenting, presentationDirection: direction)
        
        /* UIPresentationController has a delegate property that conforms to UIAdaptivePresentationControllerDelegate, and it defines several methods to support adaptivity.
        First, you’ll make SlideInPresentationManager the delegate of SlideInPresentationController. This is the best option because the controller you choose to present determines whether the app should support compact height or not.
         */
        presentationController.delegate = self

        return presentationController
    }
    
    /* This function returns an animator object that will be used when a view controller is being presented 
     */
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInPresentationAnimator(direction: direction, isPresentation: true)
    }

    /* This function returns the animation controller to be used in dismissing the view controller.
    */
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideInPresentationAnimator(direction: direction, isPresentation: false)
    }
    
}

// MARK: - UIAdaptivePresentationControllerDelegate

extension SlideInPresentationManager: UIAdaptivePresentationControllerDelegate {
    
    /* This method accepts a UIPresentationController and a UITraitCollection, and then returns the desired UIModalPresentationStyle.
    Next, it checks if verticalSizeClass equals .compact and if compact height is disabled for this presentation.
    If yes, it returns a presentation style of .overFullScreen so the presented view will cover the entire screen — not just 2/3 as defined in SlideInPresentationController.
    If no, it returns .none, to stay with the implementation of UIPresentationController.
     */

    func adaptivePresentationStyle(for controller: UIPresentationController,
                                   traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        if traitCollection.verticalSizeClass == .compact && disableCompactHeight {
            return .overFullScreen
        } else {
            return .none
        }
    }
}
