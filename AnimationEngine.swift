//
//  AnimationEngin.swift
//  Melmel
//
//  Created by Work on 17/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

let delay = 0.3

class AnimationEngine {
    static func addEaseInFromBottomAnimationToView (view:UIView) {
        UIView.animateWithDuration(delay) {
            let amount = CGFloat(97.0)
            let positionY = CGRectGetHeight(view.frame)-75.0
            print(view.frame.origin.y)
            print(positionY)
            view.frame = CGRectOffset(view.frame, 0, -amount)

        }
    }
    
    static func addEaseOutToBottomAnimationToView (view:UIView) {
        UIView.animateWithDuration(delay) {
            let amount = CGFloat(97.0)
            let positionY = CGRectGetHeight(view.frame)-75.0
            print(view.frame.origin.y)
            print(positionY)
            view.frame = CGRectOffset(view.frame, 0, amount)
            
        }
    }
}