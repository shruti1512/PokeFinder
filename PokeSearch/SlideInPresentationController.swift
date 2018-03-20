//
//  SlideInPresentationController.swift
//  PokeSearch
//
//  Created by Shruti Sharma on 2/23/18.
//  Copyright © 2018 Shruti Sharma. All rights reserved.
//

import UIKit

/* Here we subclass UIPresentationController to provide view and transition management for presented view controllers. Presentations usually consist of three major parts: the presented view controller, presenting view controller and the chrome.
 
    UIPresentationController holds references to the presented and presenting view controllers and it can manage various aspects of how the view controller is presented onscreen like the animations used, chrome customization, response to trait changes, e.t.c.
 */
 
 class SlideInPresentationController: UIPresentationController {

    var dimmingView: UIView!
    private var direction: PresentationDirection
    
    init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, presentationDirection: PresentationDirection) {
        
        self.direction = presentationDirection
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        //We create a dark view – dimmigView and add a gesture recognizer to it which will dismiss the presented view controller when the dimmigView is tapped.
        setUpDimmingView()
    }
    
    /* We override presentationTransitionWillBegin() above in which we set the dimmingView's frame and add it to the container view. We then check the value of the presented view controller’s transition coordinator. The transition coordinator is responsible for animating the presentation and dismissal of the content. If the coordinator isn’t nil, we use animateAlongsideTransition() to specify additional animations to be used alongside the presentation animation. In our case, we animate the alpha to 1.0.
     */
    override func presentationTransitionWillBegin() {
        
        guard let contView = containerView else { return }
        
        dimmingView.frame = containerView!.bounds
        contView.insertSubview(dimmingView, at: 0)
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    /* In the above code, we do the opposite of what we did in presentationTransitionWillBegin() i.e. we animate the alpha of the chrome back to 0. 
     */
    override func dismissalTransitionWillBegin() {
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })

    }
    
    /* In this method we create the frame rectangle that will be assigned to the presented view. 
     */
    override var frameOfPresentedViewInContainerView: CGRect {
        
        var frame: CGRect = .zero
        frame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerView!.bounds.size)
        switch direction {
            case .right:
                frame.origin = CGPoint(x: containerView!.frame.width*1/3, y: 0.0)
            case .bottom:
                frame.origin = CGPoint(x: 0.0, y: containerView!.frame.height*1/3)
        default:
            frame.origin = CGPoint(x: 0.0, y: 0.0)
        }
        
        return frame
    }
    
    /* This method returns the size of the specified child view controller’s content. Here we set it to be a third of the screen.
    */
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        
        var viewSize: CGSize = .zero
        switch direction {
            case .left, .right:
                viewSize = CGSize(width: parentSize.width*2/3, height: parentSize.height)
            case .top, .bottom:
                viewSize = CGSize(width: parentSize.width, height: parentSize.height*2/3)
        }
        
        return viewSize
    }
    
    /* This sets the frames of the chrome and presented views to the bounds of the container view. If this isn’t done then they won’t resize if the device is rotated.
     */
    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    /* This determines whether the presentation will cover the full screen. */
    override var shouldPresentInFullscreen: Bool {
        return true
    }
    


}

extension SlideInPresentationController {
    
    func setUpDimmingView() {
        dimmingView = UIView()
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
        dimmingView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer) {
        if (recognizer.state == UIGestureRecognizerState.ended) {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
}






