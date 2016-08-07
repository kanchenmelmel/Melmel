//
//  MapViewCtrlExtension.swift
//  Melmel
//
//  Created by Work on 7/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import Foundation

extension MapViewCtrl:DiscountAnnotationViewDelegate{
    func tapAnnotation() {
        print("tapped")
        
        self.addDiscountDetailViewController(self.discountDetailViewController)
    }
}
