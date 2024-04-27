//
//  AlarmView.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 4/1/24.
//
//  The view that is seen when the alarm is triggered.

import SwiftUI

struct AlarmView: View {
        @Binding var isSleepModeActive: Bool
        @Binding var alarmTime: Date
        @Binding var isAlarmOn: Bool
        @Binding var isAlarmTriggered: Bool
        @Binding var sleepytimeTimer: Timer?
        @Binding var snoozeDuration: TimeInterval
        @ObservedObject var manager: StatisticsManager
    var body: some View {
            VStack {
                Spacer()
                Text("Wake up!")
                    .font(.system(size: 75, weight: .bold))
                
                Button(action: {
                    SnoozeAlarm()
                    Sounds.stopSound()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        isAlarmTriggered.toggle()
                    }
                    
                }) {
                    Text("Snooze")
                        .font(.system(size: 50))
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(100)
                }
                
                Spacer()
                
                Button(action: {
                    manager.statistics.setEndTime(Date())
                    Database.updateDocument(date: Date(), ratings: ["Time That You Slept": manager.statistics.timeBetween()])
                    Sounds.stopSound()
                    isSleepModeActive.toggle()
                }) {
                    Text("Stop")
                        .font(.system(size: 20))
                        .padding()
                }
                
                .padding(5)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(100)
            }
        }
    
    func SnoozeAlarm(){
    alarmTime = Date().addingTimeInterval(snoozeDuration)
    }
}
