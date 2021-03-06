//
//  CustomActivityIndicatorView.swift
//  Melmel
//
//  Created by Work on 16/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

//Custom class for the indicator UI
class CustomActivityIndicatorView: UIActivityIndicatorView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.activityIndicatorViewStyle = .whiteLarge
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        self.layer.cornerRadius = 10.0
        let screenBounds = UIScreen.main.bounds.size
        self.center = CGPoint(x: screenBounds.width/2.0, y: screenBounds.height/2.0)
        self.startAnimating()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

}
