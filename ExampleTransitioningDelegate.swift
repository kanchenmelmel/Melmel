//
//  ExampleTransitioningDelegate.swift
//  Melmel
//
//  Created by Work on 22/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class ExampleTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController!, sourceViewController source: UIViewController) -> UIPresentationController? {
        let presentationController = CategoryFilterPresentationCtrl(presentedViewController:presented, presentingViewController:presenting)
        
        return presentationController
    }
    
//    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        var animationController = ExampleAnimatedTransitioning()
//        animationController.isPresentation = true
//        return animationController
//    }
//    
//    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        var animationController = ExampleAnimatedTransitioning()
//        animationController.isPresentation = false
//        return animationController
//    }
}