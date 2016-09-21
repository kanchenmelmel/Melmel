//
//  MapViewCtrlExtension.swift
//  Melmel
//
//  Created by Work on 7/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import MapKit

extension MapViewCtrl:DiscountAnnotationViewDelegate{
    func tapAnnotation(_ discount:Discount) {
        
        var annotationViewImgFilename = ""
        
        self.discountDetailViewController.discount = discount
        
        // Set up tint color and type Img
        if discount.catagories[0] == .shopping{
            annotationViewImgFilename = "Shopping"
            self.discountDetailViewController.viewTintColor = UIColor(red: 246.0/255.0, green: 150.0/255.0, blue: 121.0/255.0, alpha: 1.0)
        }
        if discount.catagories[0] == .entertainment {
            annotationViewImgFilename = "Entertainment"
            self.discountDetailViewController.viewTintColor = UIColor(red: 242.0/255.0, green: 109.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        }
        if discount.catagories[0] == .food {
            annotationViewImgFilename = "Food"
            self.discountDetailViewController.viewTintColor = UIColor(red: 255.0/255.0, green: 211.0/255.0, blue: 8.0/255.0, alpha: 1.0)
            
        }
        if discount.catagories[0] == .service {
            annotationViewImgFilename = "Service"
            self.discountDetailViewController.viewTintColor = UIColor(red: 60.0/255.0, green: 184.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        }
        if discount.catagories[0] == .fashion {
            annotationViewImgFilename = "Fashion"
            self.discountDetailViewController.viewTintColor = UIColor(red: 109.0/255.0, green: 207.0/255.0, blue: 246.0/255.0, alpha: 1.0)
        }
        
        
        
        if !self.discountDetailViewController.showed {
            print("tapped")
            self.addDiscountDetailViewController(self.discountDetailViewController)
        } else {
            self.removeDiscountDetailViewController(self.discountDetailViewController)
            self.addDiscountDetailViewController(self.discountDetailViewController)
        }
        

        self.discountDetailViewController.detailButton.addTarget(nil, action: #selector(showDiscountWebPage), for: .touchUpInside)

        
        self.discountDetailViewController.discountTypeImgView.image = UIImage(named: annotationViewImgFilename)
        if discount.discountTag != nil {
            self.discountDetailViewController.discountTagLabel.text = discount.discountTag
        } else {
            self.discountDetailViewController.discountTagLabel.text = "墨尔本优惠"
        }
        
        
        self.discountDetailViewController.TitleLabel.text = discount.title
    }
    
    
    func removeDiscountDetail() {
        self.removeDiscountDetailViewController(self.discountDetailViewController)
    }
    
    func showDiscountWebPage(){
        performSegue(withIdentifier: "discountWebViewSegue", sender: self.discountDetailViewController)
    }
    func reCenterMap(_ discount: Discount) {
        let newLocation = CLLocation(latitude: Double(discount.latitude!), longitude: Double(discount.longtitude!))
        centerMapOnLocation(newLocation, zoomLevel: 0.1)
    }
    
}
