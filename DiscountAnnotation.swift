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
        self.coordinate = CLLocation(latitude: discount.latitude as! Double, longitude: discount.longtitude as! Double).coordinate
        if discount.title != nil {
            self.title = discount.title!
        }
        if discount.address != nil {
            self.subtitle = discount.address!
        }
    }
}