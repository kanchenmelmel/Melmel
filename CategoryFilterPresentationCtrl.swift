//
//  CategoryFilterPresentationCtrl.swift
//  Melmel
//
//  Created by Work on 22/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class CategoryFilterPresentationCtrl: UIPresentationController,UIAdaptivePresentationControllerDelegate {
    var chromeView = UIView()
    
    override init(presentedViewController: UIViewController, presentingViewController: UIViewController) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        chromeView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        chromeView.alpha = 0.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTaped(_:)))
        chromeView.addGestureRecognizer(tap)
    }
    
    func chromeViewTaped(gesture:UIGestureRecognizer) {
        if (gesture.state == UIGestureRecognizerState.Ended) {
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        var presentedViewFrame = CGRectZero
        let containerBounds = containerView?.bounds
        presentedViewFrame.size = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerBounds!.size)
        presentedViewFrame.origin.x = 0
        return presentedViewFrame
    }
    
    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSizeMake(parentSize.width, 113)
    }
    
    override func presentationTransitionWillBegin() {
        chromeView.frame = (self.containerView?.bounds)!
        chromeView.alpha = 0.0
        chromeView.insertSubview(chromeView, atIndex: 0)
        let coordinator = presentedViewController.transitionCoordinator()
        if coordinator != nil {
            coordinator!.animateAlongsideTransition({ (context:UIViewControllerTransitionCoordinatorContext) in
                self.chromeView.alpha = 1.0
                }, completion: nil)
        } else{
            chromeView.alpha = 1.0
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let coordinator = presentedViewController.transitionCoordinator()
        if coordinator != nil {
            coordinator!.animateAlongsideTransition({ (context:UIViewControllerTransitionCoordinatorContext) in
                self.chromeView.alpha = 0.0
                }, completion: nil)
        } else {
            chromeView.alpha = 0.0
        }
    }
    
    
    override func containerViewWillLayoutSubviews() {
        chromeView.frame = (containerView?.frame)!
        presentedView()?.frame = frameOfPresentedViewInContainerView()
    }
    
    override func shouldPresentInFullscreen() -> Bool {
        return true
    }
    
    override func adaptivePresentationStyle() -> UIModalPresentationStyle {
        return .FullScreen
    }
    

    class ExampleAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
        var isPresentation = false
        func transitionDuration(transitionContext:UIViewControllerContextTransitioning?) -> NSTimeInterval {
            return 0.5
        }
        
        func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
            let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
            let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
            let fromView = fromVC?.view
            let toView = toVC?.view
            let containerView = transitionContext.containerView()
            
            if isPresentation {
                containerView!.addSubview(toView!)
            }
            
            let animatingVC = isPresentation ? toVC : fromVC
            let animatingView = animatingVC?.view
            
            let finalFrameForVC = transitionContext.finalFrameForViewController(animatingVC!)
            var initialFrameForVC = finalFrameForVC
            initialFrameForVC.origin.x += initialFrameForVC.size.width;
            
            let initialFrame = isPresentation ? initialFrameForVC : finalFrameForVC
            let finalFrame = isPresentation ? finalFrameForVC : initialFrameForVC
            
            animatingView?.frame = initialFrame
            
            UIView.animateWithDuration(transitionDuration(transitionContext), delay:0, usingSpringWithDamping:300.0, initialSpringVelocity:5.0, options:UIViewAnimationOptions.AllowUserInteraction, animations:{
                animatingView?.frame = finalFrame
                }, completion:{ (value: Bool) in
                    if !self.isPresentation {
                        fromView?.removeFromSuperview()
                    }
                    transitionContext.completeTransition(true)
            })
        }
    }
    
    
}
