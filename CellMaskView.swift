//
//  CellMaskView.swift
//  Melmel
//
//  Created by Work on 12/07/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

@IBDesignable

//Mask view for the posts and discounts UI
class CellMaskView: UIView {
    override class var layerClass : AnyClass {
        return CAGradientLayer.self
    }
    var gradientLayer:CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    override func draw(_ rect: CGRect) {
        let startColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).cgColor
        let endColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6).cgColor
        gradientLayer.colors = [startColor,endColor]
    }
}
