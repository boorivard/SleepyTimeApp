//
//  StatsUIView.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 3/29/24.
//
// A stats class that is used to calculate and display the hours that someone has slept.
// Note to reviewer: commented out as we are not using this anymore, but keeping the file for sake of reference.


import SwiftUI

/*struct alarmstats {
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
struct SleepData{
    let date: Date
    let actualSleepHours: Float
    let totalSleepHours: Float
}
class SleepWeekviewController: UIViewController {
    var barGraphViews: [BarGraphView] = []
    var sleepdataforweek: [SleepData] = []   //populated each night by alarm
    
    override func viewDidLoad(){
        super.viewDidLoad()
        configureBarGraphs()
    }
    class BarGraphView: UIView {
        func drawBars(actualSleepHours: Float, totalAlarmHours: Float) {
            let maxSleepHours: Float = 13.0
            let maxAlarmHours: Float = 24.0
            
            let actualSleepBarHeight = CGFloat(actualSleepHours) * self.frame.height / CGFloat(maxSleepHours)
            let totalAlarmBarHeight = CGFloat(totalAlarmHours) * self.frame.height / CGFloat(maxAlarmHours)
            
            let actualSleepBar = UIView(frame: CGRect(x: 0, y: self.frame.height - actualSleepBarHeight, width: self.frame.width, height: actualSleepBarHeight))
            actualSleepBar.backgroundColor = UIColor.blue
            self.addSubview(actualSleepBar)
            
            let totalAlarmBar = UIView(frame: CGRect(x: 0, y: self.frame.height - totalAlarmBarHeight, width: self.frame.width, height: totalAlarmBarHeight))
            totalAlarmBar.backgroundColor = UIColor.red
            self.addSubview(totalAlarmBar)
        }
    }
    func configureBarGraphs(){
        // Calculate dimensions for each bar graph view
        let graphWidth: CGFloat = 50.0
        let graphHeight: CGFloat = 200.0
        let graphSpacing: CGFloat = 20.0
        let xOffset: CGFloat = 20.0
        let yOffset: CGFloat = 100.0
        
        // Create and position bar graph views
        for (index, sleepData) in sleepdataforweek.enumerated() {
            let xPosition = xOffset + CGFloat(index) * (graphWidth + graphSpacing)
            let barGraphFrame = CGRect(x: xPosition, y: yOffset, width: graphWidth, height: graphHeight)
            let barGraphView = BarGraphView(frame: barGraphFrame)
            barGraphView.drawBars (actualSleepHours: sleepData.actualSleepHours, totalAlarmHours: sleepData.totalSleepHours)
            view.addSubview(barGraphView)
            barGraphViews.append(barGraphView)
        }
        
    }
}*/

