//
//  Image.swift
//  Melmel
//
//  Created by Work on 21/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit

enum PhotoRecordState {
    case New, Downloaded, Filtered, Failed
}

class Image {
    let name:String
    let url:NSURL
    var state = PhotoRecordState.New
    var image = UIImage(named:"Placeholder")
    
    init(name:String, url:NSURL){
        self.name = name
        self.url = url
    }
    
}
