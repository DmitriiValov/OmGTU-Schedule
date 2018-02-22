//
//  Utils.swift
//  OmGTU
//
//  Created by Dmitry Valov on 15.02.2018.
//  Copyright © 2018 Dmitry Valov. All rights reserved.
//

import Foundation




class Utils: NSObject {
    static func getDates(for date: Date) -> (from: String, to: String) {
        var dateString:(from: String, to: String) = ("", "")
        
        if let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian) {
            
            var weekday = gregorianCalendar.component(.weekday, from: date)
            
            weekday -= 1;
            if weekday == 0 {
                weekday = 7
            }
            
            let year = gregorianCalendar.component(.year, from: date)
            let month = gregorianCalendar.component(.month, from: date)
            let day = gregorianCalendar.component(.day, from: date)
            
            var dateComponentsFrom = DateComponents()
            dateComponentsFrom.year = year
            dateComponentsFrom.month = month
            dateComponentsFrom.day = day - weekday + 1
            
            var dateComponentsTo = DateComponents()
            dateComponentsTo.year = year
            dateComponentsTo.month = month
            dateComponentsTo.day = day + 7 - weekday
            
            let dateFrom = gregorianCalendar.date(from: dateComponentsFrom)
            let dateTo = gregorianCalendar.date(from: dateComponentsTo)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let dateStringFrom = formatter.string(from: dateFrom!)
            let dateStringTo = formatter.string(from: dateTo!)

            dateString.from = dateStringFrom
            dateString.to = dateStringTo
        }
        return dateString
    }
}
