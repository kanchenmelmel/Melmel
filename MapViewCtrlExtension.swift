//
//  MapViewCtrlExtension.swift
//  Melmel
//
//  Created by Work on 7/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

extension MapViewCtrl:DiscountAnnotationViewDelegate{
    func tapAnnotation(discount:Discount) {
        
        var annotationViewImgFilename = ""
        
        self.discountDetailViewController.discount = discount
        
        // Set up tint color and type Img
        if discount.catagories[0] == .Shopping{
            annotationViewImgFilename = "Shopping"
            self.discountDetailViewController.viewTintColor = UIColor(red: 246.0/255.0, green: 150.0/255.0, blue: 121.0/255.0, alpha: 1.0)
        }
        if discount.catagories[0] == .Entertainment {
            annotationViewImgFilename = "Entertainment"
            self.discountDetailViewController.viewTintColor = UIColor(red: 242.0/255.0, green: 109.0/255.0, blue: 125.0/255.0, alpha: 1.0)
        }
        if discount.catagories[0] == .Food {
            annotationViewImgFilename = "Food"
            self.discountDetailViewController.viewTintColor = UIColor(red: 255.0/255.0, green: 211.0/255.0, blue: 8.0/255.0, alpha: 1.0)
            
        }
        if discount.catagories[0] == .Service {
            annotationViewImgFilename = "Service"
            self.discountDetailViewController.viewTintColor = UIColor(red: 60.0/255.0, green: 184.0/255.0, blue: 120.0/255.0, alpha: 1.0)
        }
        if discount.catagories[0] == .Fashion {
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
        

        self.discountDetailViewController.detailButton.addTarget(nil, action: #selector(showDiscountWebPage), forControlEvents: .TouchUpInside)

        
        self.discountDetailViewController.discountTypeImgView.image = UIImage(named: annotationViewImgFilename)
        if discount.discountTag != nil {
            self.discountDetailViewController.discountTagLabel.text = discount.discountTag
        } else {
            self.discountDetailViewController.discountTagLabel.text = "墨尔本优惠"
        }
        
        
        self.discountDetailViewController.TitleLabel.text = discount.title
    }
    
    func showDiscountWebPage(){
        performSegueWithIdentifier("discountWebViewSegue", sender: self.discountDetailViewController)
    }
}