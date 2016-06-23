//
//  DiscountFilter.swift
//  Melmel
//
//  Created by WuKaipeng on 20/06/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import Foundation

class DiscountFilter {
    var category: [DiscountCategory] = []
    var name : String
    
    init(name: String, category: [DiscountCategory] ) {
        self.category = category
        self.name = name
    }
}
