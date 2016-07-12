//
//  CellTopMaskView.swift
//  Melmel
//
//  Created by Work on 12/07/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

@IBDesignable
class CellTopMaskView: UIView {
    override class func layerClass() -> AnyClass {
        return CAGradientLayer.self
    }
    var gradientLayer:CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    override func drawRect(rect: CGRect) {
        let startColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).CGColor
        let endColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).CGColor
        gradientLayer.colors = [startColor,endColor]
    }
}
