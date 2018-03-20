//
//  SlideInTransitionAnimator.swift
//  PokeSearch
//
//  Created by Shruti Sharma on 2/23/18.
//  Copyright © 2018 Shruti Sharma. All rights reserved.
//

import Foundation
import UIKit

/* UIViewControllerAnimatedTransitioning protocol performs the custom animations for transitioning between view controllers. */

class SlideInPresentationAnimator: NSObject {
    
    /* isPresentation will be used to determine if the presentation animation is presenting (as opposed to dismissing). */

    let direction: PresentationDirection
    let isPresentation: Bool
    
    init(direction: PresentationDirection, isPresentation: Bool) {
        self.direction = direction
        self.isPresentation = isPresentation
    }
}

// MARK: - UIViewControllerAnimatedTransitioning

extension SlideInPresentationAnimator: UIViewControllerAnimatedTransitioning {
    
    /* This method returns the duration in seconds of the transition animation. */
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
/* In the code below, we get the from and to view controllers from the UIViewControllerContextTransitioning object. We then get the respective views of these view controllers. Next we get the container view and if the presentation animation is presenting, we add the to view to the container view.
 
 We then decide on which view controller to animate based on whether the transition is a presentation or dismissal. We then determine the start and end positions of the view. Then in the animation, we move the view to the final position. This will animate the view from right to left during a presentation and vice versa during dismissal. If the transition is a dismissal, we remove the view. Then we complete the transition by calling transitionContext.completeTransition().
 */

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let key = isPresentation ? UITransitionContextViewControllerKey.to : UITransitionContextViewControllerKey.from
        let controller = transitionContext.viewController(forKey: key)!
        
        if isPresentation {
            transitionContext.containerView.addSubview(controller.view)
        }
        
        let presentedFrame = transitionContext.finalFrame(for: controller)
        var dismissedFrame = presentedFrame
        switch direction {
        case .left:
            dismissedFrame.origin.x = -presentedFrame.size.width
        case .right:
            dismissedFrame.origin.x = transitionContext.containerView.frame.size.width
        case .top:
            dismissedFrame.origin.y = -presentedFrame.size.height
        case .bottom:
            dismissedFrame.origin.y = transitionContext.containerView.frame.size.height
        }
        
        let initialFrame = isPresentation ? dismissedFrame : presentedFrame
        let finalFrame = isPresentation ? presentedFrame : dismissedFrame
        
        let duration = transitionDuration(using: transitionContext)
        controller.view.frame = initialFrame
        UIView.animate(withDuration: duration, animations: {
            controller.view.frame = finalFrame
        }) { finished in
            transitionContext.completeTransition(finished)
        }
    }
    
}




