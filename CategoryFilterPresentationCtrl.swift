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
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        chromeView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        chromeView.alpha = 0.0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(chromeViewTaped(_:)))
        chromeView.addGestureRecognizer(tap)
    }
    
    func chromeViewTaped(_ gesture:UIGestureRecognizer) {
        if (gesture.state == UIGestureRecognizerState.ended) {
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        var presentedViewFrame = CGRect.zero
        let containerBounds = containerView?.bounds
        presentedViewFrame.size = size(forChildContentContainer: presentedViewController, withParentContainerSize: containerBounds!.size)
        presentedViewFrame.origin.x = 0
        return presentedViewFrame
    }
    
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width, height: 113)
    }
    
    override func presentationTransitionWillBegin() {
        chromeView.frame = (self.containerView?.bounds)!
        chromeView.alpha = 0.0
        chromeView.insertSubview(chromeView, at: 0)
        let coordinator = presentedViewController.transitionCoordinator
        if coordinator != nil {
            coordinator!.animate(alongsideTransition: { (context:UIViewControllerTransitionCoordinatorContext) in
                self.chromeView.alpha = 1.0
                }, completion: nil)
        } else{
            chromeView.alpha = 1.0
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let coordinator = presentedViewController.transitionCoordinator
        if coordinator != nil {
            coordinator!.animate(alongsideTransition: { (context:UIViewControllerTransitionCoordinatorContext) in
                self.chromeView.alpha = 0.0
                }, completion: nil)
        } else {
            chromeView.alpha = 0.0
        }
    }
    
    
    override func containerViewWillLayoutSubviews() {
        chromeView.frame = (containerView?.frame)!
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    override var shouldPresentInFullscreen : Bool {
        return true
    }
    
    override var adaptivePresentationStyle : UIModalPresentationStyle {
        return .fullScreen
    }
    

    class ExampleAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
        var isPresentation = false
        func transitionDuration(using transitionContext:UIViewControllerContextTransitioning?) -> TimeInterval {
            return 0.5
        }
        
        func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            let fromView = fromVC?.view
            let toView = toVC?.view
            let containerView = transitionContext.containerView
            
            if isPresentation {
                containerView.addSubview(toView!)
            }
            
            let animatingVC = isPresentation ? toVC : fromVC
            let animatingView = animatingVC?.view
            
            let finalFrameForVC = transitionContext.finalFrame(for: animatingVC!)
            var initialFrameForVC = finalFrameForVC
            initialFrameForVC.origin.x += initialFrameForVC.size.width;
            
            let initialFrame = isPresentation ? initialFrameForVC : finalFrameForVC
            let finalFrame = isPresentation ? finalFrameForVC : initialFrameForVC
            
            animatingView?.frame = initialFrame
            
            UIView.animate(withDuration: transitionDuration(using: transitionContext), delay:0, usingSpringWithDamping:300.0, initialSpringVelocity:5.0, options:UIViewAnimationOptions.allowUserInteraction, animations:{
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
