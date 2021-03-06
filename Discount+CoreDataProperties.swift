//
//  Discount+CoreDataProperties.swift
//  Melmel
//
//  Created by Work on 23/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Discount {

    @NSManaged var address: String?
    @NSManaged var date: Date?
    @NSManaged var discountTag: String?
    @NSManaged var featured_image_downloaded: NSNumber?
    @NSManaged var featured_image_url: String?
    @NSManaged var id: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var link: String?
    @NSManaged var longtitude: NSNumber?
    @NSManaged var title: String?
    @NSManaged var discountCategories: NSSet?

}
