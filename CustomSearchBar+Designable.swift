//
//  CustomSearchBar.swift
//  Melmel
//
//  Created by Work on 17/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit



class CustomSearchBar: UISearchBar {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !self.point(inside: point, with: event) {
            print("test")
            self.resignFirstResponder()
            return nil
        } else {
            for subview in self.subviews {
                let convertedPoint = subview.convert(point, from: self)
                let hitTestView = subview.hitTest(convertedPoint, with: event)
                if hitTestView != nil {
                    return hitTestView
                }
            }
        }
        return nil
    }
    
}
