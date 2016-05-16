//
//  Discount+CoreDataProperties.swift
//  Melmel
//
//  Created by Work on 16/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Discount {

    @NSManaged var id: NSNumber?
    @NSManaged var title: String?
    @NSManaged var link: String?
    @NSManaged var date: NSDate?
    @NSManaged var featured_image_url: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longtitude: NSNumber?
    @NSManaged var address: String?

}
