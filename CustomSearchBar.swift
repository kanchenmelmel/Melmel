//
//  CustomSearchBar.swift
//  Melmel
//
//  Created by Work on 17/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class CustomSearchBar: UISearchBar {
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        if !self.pointInside(point, withEvent: event) {
            self.resignFirstResponder()
            return nil
        } else {
            for subview in self.subviews {
                let convertedPoint = subview.convertPoint(point, fromView: self)
                let hitTestView = subview.hitTest(convertedPoint, withEvent: event)
                if hitTestView != nil {
                    return hitTestView
                }
            }
        }
        return nil
    }

}
