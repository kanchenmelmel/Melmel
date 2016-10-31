//
//  DiscountAnnotationView.swift
//  Melmel
//
//  Created by Work on 7/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import MapKit
protocol DiscountAnnotationViewDelegate{
    func tapAnnotation(_ discount:Discount)
    func removeDiscountDetail()
    func reCenterMap(_ discount:Discount)
}

class DiscountAnnotationView: MKAnnotationView {
    var delegate:DiscountAnnotationViewDelegate!
    /*
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
 */
    init(annotation: MKAnnotation?, reuseIdentifier: String?, delegate:DiscountAnnotationViewDelegate?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
//    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
//        
//        let uiView = super.hitTest(point, withEvent: event)
//        
//        if uiView == nil && self.selected {
//            let disocuntAnnotation = self.annotation as! DiscountAnnotation
//            delegate.tapAnnotation(disocuntAnnotation.discount!)
//            
//        }
//        return uiView
//    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//        if selected {
//            let disocuntAnnotation = self.annotation as! DiscountAnnotation
//            self.delegate.reCenterMap(disocuntAnnotation.discount!)
//            self.delegate.tapAnnotation(disocuntAnnotation.discount!)
//        } else {
//            self.delegate.removeDiscountDetail()
//        }
//    }
}
