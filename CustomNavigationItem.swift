//
//  CustomNavigationItem.swift
//  Melmel
//
//  Created by Work on 25/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

@IBDesignable
class CustomNavigationItem: UINavigationItem {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let imageView = UIImageView(image: UIImage(named: "NaviBarItem"))
        self.titleView = imageView
    }
}
