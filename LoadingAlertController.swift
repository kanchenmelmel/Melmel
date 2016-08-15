//
//  LoadingAlertController.swift
//  Melmel
//
//  Created by Work on 14/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class LoadingAlertController: UIAlertController {
    
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        //activityIndicatorView.center = CGPointMake(self.view.frame.width/2.0, self.view.frame.height/2.0)
        self.view.backgroundColor = GLOBAL_TINT_COLOR
        activityIndicatorView.center = view.center
        print(activityIndicatorView.center == self.view.center)
        self.view.addSubview(activityIndicatorView)
        
        activityIndicatorView.startAnimating()
        
    }
    
    func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
