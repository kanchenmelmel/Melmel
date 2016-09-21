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
    
    func showAlert(_ viewcontroller: UITableViewController) -> Void{
        
        let attributedString = NSAttributedString(string: "请检查你的网络", attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 20),
            NSForegroundColorAttributeName : UIColor.white
            ])
        
  
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .alert)
        viewcontroller.present(alertController, animated: true, completion: nil)
        alertController.setValue(attributedString, forKey: "attributedMessage")
        
        
        let subview :UIView = alertController.view.subviews.last! as UIView
        let alertContentView = subview.subviews.last! as UIView
        alertContentView.backgroundColor = GLOBAL_TINT_COLOR
        alertContentView.layer.cornerRadius = 10
        
        
        let delay = 2.0 * Double(NSEC_PER_SEC)
        let time = DispatchTime.now() + Double(Int64(delay)) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: time, execute: {
            alertController.dismiss(animated: true, completion: nil)
        })
    }
    
    func showLoadingAlertController(_ viewController:UIViewController) {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        let loadingAlertController = UIAlertController(title: "", message: "", preferredStyle: .alert)
        activityIndicatorView.center = loadingAlertController.view.center
        
    }
}
