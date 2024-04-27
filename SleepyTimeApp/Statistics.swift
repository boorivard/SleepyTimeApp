//
//  Statistics.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 4/3/24.
//
//  A statisctics class that has accessors, mutators, and a function to find the time between a start time and end time. Used to calculate how long a user slept while using the app. Also contains an observable object that allows a single instance of statistics to be shared among views. 

import Foundation

class Statistics: ObservableObject{
        @Published var startTime: Date
        @Published var endTime: Date
        
        init(startTime: Date, endTime: Date) {
            self.startTime = startTime
            self.endTime = endTime
        }
        
        // Accessor for startTime
        func getStartTime() -> Date {
            return startTime
        }
        
        // Mutator for startTime
        func setStartTime(_ startTime: Date) {
            self.startTime = startTime
        }
        
        // Accessor for endTime
        func getEndTime() -> Date {
            return endTime
        }
        
        // Mutator for endTime
        func setEndTime(_ endTime: Date) {
            self.endTime = endTime
        }
        
        // Function to calculate the time interval between endTime and startTime
        func timeBetween() -> TimeInterval {
            if(endTime.timeIntervalSince(startTime) > 0){
                return endTime.timeIntervalSince(startTime)
            }else{
                return 0
            }
        }
}

class StatisticsManager: ObservableObject {
        @Published var statistics: Statistics

        init(startTime: Date, endTime: Date) {
            self.statistics = Statistics(startTime: startTime, endTime: endTime)
        }
}
