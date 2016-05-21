//
//  Post.swift
//  Melmel
//
//  Created by Work on 10/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum PhotoRecordState {
    case New, Downloaded, Filtered, Failed
}

class Post: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    var featuredImage : UIImage?
    var featuredImageState : PhotoRecordState = .New

}
