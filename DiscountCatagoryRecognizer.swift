//
//  DiscountCatalogory.swift
//  Melmel
//
//  Created by Work on 3/08/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import Foundation



class DiscountCatagoryRecognizer{
    static func recognizeCatagory (catagoryId:Int,postType:PostType) -> DiscountCatagory {
        if postType == .Discount {
            let entertianmentTypes = [141,433,306,79,1037]
            let fashionTypes = [280,532,306,300,533]
            let serviceTypes = [272,294,455,536,273,487]
            let foodTypes = [103,104,205,127,360,144,162,161,153,422,474,159,349,151,148,152,154]
            let shoppomgTypes = [17,1201]
            
            if entertianmentTypes.contains(catagoryId){
                return DiscountCatagory.Entertainment
            }
            if fashionTypes.contains(catagoryId){
                return DiscountCatagory.Fashion
            }
            if serviceTypes.contains(catagoryId){
                return DiscountCatagory.Service
            }
            if foodTypes.contains(catagoryId){
                return DiscountCatagory.Food
            }
            if shoppomgTypes.contains(catagoryId){
                return DiscountCatagory.Shopping
            }
        }
        return DiscountCatagory.None
    }
}