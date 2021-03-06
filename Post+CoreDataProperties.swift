//
//  Post+CoreDataProperties.swift
//  Melmel
//
//  Created by Work on 21/05/2016.
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
    @NSManaged var date: Date?
    @NSManaged var date_gmt: Date?
    @NSManaged var id: NSNumber?
    @NSManaged var link: String?
    @NSManaged var modified: Date?
    @NSManaged var modified_gmt: Date?
    @NSManaged var password: String?
    @NSManaged var title: String?
    @NSManaged var type: String?
    @NSManaged var featured_image_url: String?
    @NSManaged var featured_image_downloaded: NSNumber?
    @NSManaged var featured_media: Media?

}
