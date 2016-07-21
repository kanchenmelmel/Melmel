//
//  CoreDataUitility.swift
//  Melmel
//
//  Created by Work on 26/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import CoreData

enum EntityType:String {
    case Post = "Post"
    case Discount = "Discount"
}

class CoreDataUtility {
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func getEarliestDate(entityType:EntityType) -> NSDate?{
        let request = NSFetchRequest()
//        var entityName = ""
//        switch entityType {
//        case .Post:entityName = "Post"
//        case .Discount:entityName = "Discount"
//        }
        request.entity = NSEntityDescription.entityForName(entityType.rawValue, inManagedObjectContext: managedObjectContext)
        request.resultType = .DictionaryResultType
        
        
        // Set up expression
        let keyPathExpression = NSExpression(forKeyPath: "date")
        let earliestExpression = NSExpression(forFunction: "min:", arguments: [keyPathExpression])
        
        let earliestExpressionDescription = NSExpressionDescription()
        earliestExpressionDescription.name = "earliestDate"
        earliestExpressionDescription.expression = earliestExpression
        earliestExpressionDescription.expressionResultType = .DateAttributeType
        
        //set up fetch Request
        
        request.propertiesToFetch = [earliestExpressionDescription]
        do {
            let fetchResults = try managedObjectContext.executeFetchRequest(request)
            
            
            if fetchResults[0].valueForKey("earliestDate") != nil {
                let earliestDate = fetchResults[0].valueForKey("earliestDate") as! NSDate
                return earliestDate
            }
            
        } catch {
        }
        
        return nil
        
    }
    
    func checkIdExist(id:Int,entityType:EntityType) -> Bool {
        let request = NSFetchRequest()
        request.entity = NSEntityDescription.entityForName(entityType.rawValue, inManagedObjectContext: managedObjectContext)
        //request.resultType = .CountResultType
        
        // Set up predicate
        let predicate = NSPredicate(format: "id = %@", "\(id)")
        request.predicate = predicate

        let count = managedObjectContext.countForFetchRequest(request, error: nil)

        
        if count != 0 {
            print(true)
            return true
        }
        print(false)
        return false
        
    }
}