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
    static func addEaseInFromBottomAnimationToView (_ view:UIView) {
        UIView.animate(withDuration: delay, animations: {
            let amount = CGFloat(97.0)
            let positionY = view.frame.height-75.0
            print(view.frame.origin.y)
            print(positionY)
            view.frame = view.frame.offsetBy(dx: 0, dy: -amount)

        }) 
    }
    
    static func addEaseOutToBottomAnimationToView (_ view:UIView) {
        UIView.animate(withDuration: delay, animations: {
            let amount = CGFloat(97.0)
            let positionY = view.frame.height-75.0
            print(view.frame.origin.y)
            print(positionY)
            view.frame = view.frame.offsetBy(dx: 0, dy: amount)
            
        }) 
    }
}
