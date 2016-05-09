//
//  Post+CoreDataProperties.swift
//  Melmel
//
//  Created by Work on 25/04/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Post {

    @NSManaged var author: NSNumber?
    @NSManaged var content: String?
    @NSManaged var date: NSDate?
    @NSManaged var date_gmt: NSDate?
    @NSManaged var id: NSNumber?
    @NSManaged var link: String?
    @NSManaged var modified: NSDate?
    @NSManaged var modified_gmt: NSDate?
    @NSManaged var password: String?
    @NSManaged var title: String?
    @NSManaged var type: String?
    @NSManaged var featured_media: Media?
    
//    convenience init(author:NSNumber,content:String){}

}
