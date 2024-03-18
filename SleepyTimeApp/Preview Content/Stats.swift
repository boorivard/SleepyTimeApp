//
//  Stats.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 3/17/24.
//

import Foundation
struct alarmstats {
    var hour: Int
    var minute: Int
}
//Function to calculate total alarm time
func Totalalarmtime(alarm: alarmstats, Wakeuptime: Date) -> TimeInterval {
    let calendar = Calendar.current
    
    
    //Get current time & date
    _ = Date()
    let WakeupComponents = calendar.dateComponents([.year, .month, .day], from: Wakeuptime)
    
    // New date representing the alarm time for the current day
    var alarmDatecomponents = DateComponents()
    alarmDatecomponents.year = WakeupComponents.year
    alarmDatecomponents.month = WakeupComponents.month
    alarmDatecomponents.day = WakeupComponents.day
    alarmDatecomponents.hour = alarm.hour
    alarmDatecomponents.minute = alarm.minute
    
    let alarmTime = calendar.date(from: alarmDatecomponents)!
    
    //calculation for time slept
    let timeslept = Wakeuptime.timeIntervalSince(alarmTime)
    
    return timeslept
    
    
}
