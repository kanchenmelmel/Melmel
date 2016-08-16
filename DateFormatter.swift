//
//  DateFormatter.swift
//  Melmel
//
//  Created by Work on 11/05/2016.
//  Copyright © 2016 Melmel. All rights reserved.
//

import Foundation

class DateFormatter {
    
    func formatDateStringToMelTime(dateString:String) -> NSDate {
        
        let RFC3339DateFormatter = NSDateFormatter()
        RFC3339DateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        RFC3339DateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let date = RFC3339DateFormatter.dateFromString(dateString+"+10:00")
        return date!
    }
    
    func formatDateToDateString(date:NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.timeZone=NSTimeZone(name: "UTC")
        dateFormatter.dateFormat="yyyy-MM-dd'T'HH:mm:ss"
        let dateString = dateFormatter.stringFromDate(date)
        
        return dateString
    }
    
    func formatDateToDateStringForDisplay(date:NSDate)->String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter.stringFromDate(date).uppercaseString
    }
    
    func calculateDifferenceBetweenCurrentTimeInString(date:NSDate) ->String {
        let calendar = NSCalendar.currentCalendar()
        if calendar.isDateInToday(date){
            
        }
        return ""
    }
    
}