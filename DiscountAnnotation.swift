//
//  DiscountAnnotation.swift
//  Melmel
//
//  Created by Work on 17/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import MapKit


class DiscountAnnotation: MKPointAnnotation {
    var discount:Discount?
    
    init(discount:Discount){
        super.init()
        self.discount = discount
    }
}