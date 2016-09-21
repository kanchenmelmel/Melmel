//
//  DiscountCatalogory.swift
//  Melmel
//
//  Created by Work on 3/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import Foundation


//a class that identify the correct category for a discount post
class DiscountCatagoryRecognizer{
    static func recognizeCatagory (_ catagoryId:Int,postType:PostType) -> DiscountCatagory {
        if postType == .Discount {
            let entertianmentTypes = [141,433,306,79,1037]
            let fashionTypes = [280,532,306,300,533,1206,654,383,585]
            let serviceTypes = [272,294,455,536,273,487]
            let foodTypes = [103,104,205,127,360,144,162,161,153,371,422,474,159,349,151,148,152,154,1087,1096]
            let shoppomgTypes = [17,1201]
            print("cat ID is \(catagoryId)")
            if entertianmentTypes.contains(catagoryId){
                return DiscountCatagory.entertainment
            }
            if fashionTypes.contains(catagoryId){
                return DiscountCatagory.fashion
            }
            if serviceTypes.contains(catagoryId){
                return DiscountCatagory.service
            }
            if foodTypes.contains(catagoryId){
                return DiscountCatagory.food
            }
            if shoppomgTypes.contains(catagoryId){
                return DiscountCatagory.shopping
            }
        }
        return DiscountCatagory.none
    }
}
