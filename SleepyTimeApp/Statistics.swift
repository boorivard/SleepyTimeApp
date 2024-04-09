//
//  Statistics.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 4/3/24.
//

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
            return endTime.timeIntervalSince(startTime)
        }
}

class StatisticsManager: ObservableObject {
        @Published var statistics: Statistics

        init(startTime: Date, endTime: Date) {
            self.statistics = Statistics(startTime: startTime, endTime: endTime)
        }
}
