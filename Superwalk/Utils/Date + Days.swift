//
//  Date + Days.swift
//  Superwalk
//
//  Created by Ricky Kirkendall on 12/1/22.
//

import Foundation
extension Date {
    
    // startOfDay and endOfDay borrowed
    // from: https://stackoverflow.com/questions/13324633/nsdate-beginning-of-day-and-end-of-day
    
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
    
    func dayStartAndEndFor(numberOfDaysAgo: Int) -> (Date?, Date?) {
        let start = startOfDay
        guard let end = endOfDay else { return (nil, nil) }
        var components = DateComponents()
        components.day = -numberOfDaysAgo
        return (Calendar.current.date(byAdding: components, to: start), Calendar.current.date(byAdding: components, to: end))
        
    }
}
