//
//  Discount.swift
//  Melmel
//
//  Created by WuKaipeng on 20/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import Foundation
import CoreData
import UIKit

enum DiscountCatagory {
    case Shopping
    case Entertainment
    case Service
    case Fashion
    case Food
    case None
    
}


class Discount: NSManagedObject {

    
    
// Insert code here to add functionality to your managed object subclass

    var featuredImage : UIImage?
    var featuredImageState : PhotoRecordState = .New
    var catagories = [DiscountCatagory]()
}
