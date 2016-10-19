//
//  ExampleTransitioningDelegate.swift
//  Melmel
//
//  Created by Work on 22/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class ExampleTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    private func presentationController(forPresented presented: UIViewController, presenting: UIViewController??, source: UIViewController) -> UIPresentationController? {
        let presentationController = CategoryFilterPresentationCtrl(presentedViewController:presented, presenting:presenting!)
        
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
