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
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    
    func getEarliestDate(_ entityType:EntityType) -> Date?{
        let request = NSFetchRequest()
//        var entityName = ""
//        switch entityType {
//        case .Post:entityName = "Post"
//        case .Discount:entityName = "Discount"
//        }
        request.entity = NSEntityDescription.entity(forEntityName: entityType.rawValue, in: managedObjectContext)
        request.resultType = .dictionaryResultType
        
        
        // Set up expression
        let keyPathExpression = NSExpression(forKeyPath: "date")
        let earliestExpression = NSExpression(forFunction: "min:", arguments: [keyPathExpression])
        
        let earliestExpressionDescription = NSExpressionDescription()
        earliestExpressionDescription.name = "earliestDate"
        earliestExpressionDescription.expression = earliestExpression
        earliestExpressionDescription.expressionResultType = .dateAttributeType
        
        //set up fetch Request
        
        request.propertiesToFetch = [earliestExpressionDescription]
        do {
            let fetchResults = try managedObjectContext.fetch(request)
            
            
            if fetchResults[0].value(forKey: "earliestDate") != nil {
                let earliestDate = fetchResults[0].value(forKey: "earliestDate") as! Date
                return earliestDate
            }
            
        } catch {
        }
        
        return nil
        
    }
    
    func checkIdExist(_ id:Int,entityType:EntityType) -> Bool {
        let request = NSFetchRequest()
        request.entity = NSEntityDescription.entity(forEntityName: entityType.rawValue, in: managedObjectContext)
        //request.resultType = .CountResultType
        
        // Set up predicate
        let predicate = NSPredicate(format: "id = %@", "\(id)")
        request.predicate = predicate

        let count = managedObjectContext.count(for: request, error: nil)

        
        if count != 0 {
            print(true)
            return true
        }
        print(false)
        return false
        
    }
}
