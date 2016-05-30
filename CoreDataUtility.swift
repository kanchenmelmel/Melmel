//
//  CoreDataUitility.swift
//  Melmel
//
//  Created by Work on 26/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import UIKit
import CoreData

enum EntityType {
    case Post,Discount
}

class CoreDataUtility {
    var managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func getEarliestDate(entityType:EntityType) -> NSDate?{
        let request = NSFetchRequest()
        var entityName = ""
        switch entityType {
        case .Post:entityName = "Post"
        case .Discount:entityName = "Discount"
        }
        request.entity = NSEntityDescription.entityForName(entityName, inManagedObjectContext: managedObjectContext)
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
                var earliestDate = fetchResults[0].valueForKey("earliestDate") as! NSDate
                return earliestDate
            }
            
        } catch {
        }
        
        return nil
        
    }
}