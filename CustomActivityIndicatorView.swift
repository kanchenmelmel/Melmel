//
//  CustomActivityIndicatorView.swift
//  Melmel
//
//  Created by Work on 16/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class CustomActivityIndicatorView: UIActivityIndicatorView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.activityIndicatorViewStyle = .WhiteLarge
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        self.layer.cornerRadius = 10.0
        let screenBounds = UIScreen.mainScreen().bounds.size
        self.center = CGPointMake(screenBounds.width/2.0, screenBounds.height/2.0)
        self.startAnimating()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

}
