//
//  Discount+CoreDataProperties.swift
//  Melmel
//
//  Created by WuKaipeng on 20/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Discount {

    @NSManaged var address: String?
    @NSManaged var date: NSDate?
    @NSManaged var featured_image_url: String?
    @NSManaged var id: NSNumber?
    @NSManaged var latitude: NSNumber?
    @NSManaged var link: String?
    @NSManaged var longtitude: NSNumber?
    @NSManaged var title: String?
    @NSManaged var downloaded: NSNumber?

}
