//
//  Alert.swift
//  Melmel
//
//  Created by WuKaipeng on 4/06/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import Foundation
import UIKit


class Alert {
    
    func showAlert(viewcontroller: UITableViewController) -> Void{
        
        let attributedString = NSAttributedString(string: "请检查你的网络", attributes: [
            NSFontAttributeName : UIFont.systemFontOfSize(20),
            NSForegroundColorAttributeName : UIColor.whiteColor()
            ])
        
  
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .Alert)
        viewcontroller.presentViewController(alertController, animated: true, completion: nil)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        
        let subview :UIView = alertController.view.subviews.last! as UIView
        let alertContentView = subview.subviews.last! as UIView
        alertContentView.backgroundColor = GLOBAL_TINT_COLOR
        alertContentView.layer.cornerRadius = 10
        
        
        let delay = 2.0 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), {
            alertController.dismissViewControllerAnimated(true, completion: nil)
        })
    }
}