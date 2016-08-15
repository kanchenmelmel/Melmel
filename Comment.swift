//
//  Comment.swift
//  Melmel
//
//  Created by Work on 27/07/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//


import Foundation


class Comment {
    var autherName:String?
    var date:NSDate?
    var content:String?
    var avatar:String?
    init() {
        autherName=""
        date = NSDate()
        content = ""
        avatar = ""
    }
}
