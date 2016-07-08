//
//  DiscountAnnotation.swift
//  Melmel
//
//  Created by Work on 17/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import MapKit
import FBAnnotationClusteringSwift


class DiscountAnnotation: FBAnnotation {
    var discount:Discount?
    var subtitle: String?
    
    init(discount:Discount){
        super.init()
        self.discount = discount
        
        guard let _ = discount.latitude as? Double
            else {
                return
        }
        guard let _ = discount.longtitude as? Double
            else{
                return
        }
        self.coordinate = CLLocation(latitude: discount.latitude as! Double, longitude: discount.longtitude as! Double).coordinate
        if discount.title != nil {
            self.title = discount.title!
        }
        if discount.address != nil {
            self.subtitle = discount.address!
        }
    }
}