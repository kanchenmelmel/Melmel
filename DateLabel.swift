//
//  DateLabel.swift
//  Melmel
//
//  Created by Work on 13/07/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

class DateLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let backgroundImage = UIImage(named: "dateBackground")
        let backgroundImageSize = self.frame.size
        
        UIGraphicsBeginImageContext(backgroundImageSize)
        backgroundImage?.drawInRect(CGRect(x: 0, y: 0, width: backgroundImageSize.width, height: backgroundImageSize.height))
        let newBackgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        
        self.backgroundColor = UIColor(patternImage: newBackgroundImage!)
    }
}
