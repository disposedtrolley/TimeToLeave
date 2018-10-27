//
//  Utils.swift
//  TimeToLeave
//
//  Created by James Liu on 26/10/18.
//  Copyright © 2018 James Liu. All rights reserved.
//

import Foundation

extension Date {
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    func minutesFromNow() -> Int {
        let calendar = Calendar.current
        
        let targetComponents = calendar.dateComponents([.hour, .minute], from: self)
        let nowComponents = calendar.dateComponents([.hour, .minute], from: Date().toLocalTime())
        
        let difference = calendar.dateComponents([.minute], from: nowComponents, to: targetComponents).minute!
        
        return difference
    }
    
}
