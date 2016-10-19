//
//  DateFormatter.swift
//  Melmel
//
//  Created by Work on 11/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import Foundation

//this class is used to transform the date into different date format.
class DateFormatter {
    
    func formatDateStringToMelTime(_ dateString:String) -> Date {
        
        let RFC3339DateFormatter = Foundation.DateFormatter()
        RFC3339DateFormatter.locale = Locale(identifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let date = RFC3339DateFormatter.date(from: dateString+"+10:00")
        return date!
    }
    
    func formatDateToDateString(_ date:Date) -> String {
        let dateFormatter = Foundation.DateFormatter()
        
        dateFormatter.timeZone=TimeZone(identifier: "UTC")
        dateFormatter.dateFormat="yyyy-MM-dd'T'HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    func formatDateToDateStringForDisplay(_ date:Date)->String {
        let dateFormatter = Foundation.DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date).uppercased()
    }
    
    func calculateDifferenceBetweenCurrentTimeInString(_ date:Date) ->String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date){
            
        }
        return ""
    }
    
}
