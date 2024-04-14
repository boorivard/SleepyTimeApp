//
//  AlarmSettingsView.swift
//  SleepyTimeApp
//
//  Created by Nicholas Schiffer on 4/9/24.
//
//  View that consists of general settings for an alarm.
//
// NOTE TO REVIEWER: IN PROGRESS, NOT IN FINAL FORM

import SwiftUI

struct AlarmSettingsView: View {
    @Binding var snoozeDuration: TimeInterval
    @Binding var isSleepModeActive: Bool
    @Binding var alarmTime: Date
    @Binding var isAlarmOn: Bool
    @Binding var isAlarmTriggered: Bool
    @State private var selectedDelay: TimeInterval = 300   //defaulted sleepytime mode delay to 5 minutes
    @State private var sleepytimeTimer: Timer?
    
    var body: some View {
        VStack {
            Spacer()
            Text("Wake up")
                .font(.system(size: 75, weight: .bold))
            
            Button(action: {
                snoozeAlarm()
                Sounds.stopSound()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isAlarmTriggered.toggle()
                }
            }) {
                Text("Snooze")
                    .font(.system(size: 50))
                    .padding()
                    .background(Color.green)
                    .cornerRadius(100)
            }
            
            Slider(value: $snoozeDuration, in: 10...600, step: 10) {
                Text("Snooze Timer: \(Int(snoozeDuration)) seconds")
            }
            .padding()
            
            Spacer()
            
            Button(action: {
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
         Button(action: {
            // Start the timer with the selected delay
            startSleepytimeTimer(withDelay: selectedDelay)
        }) {
            Text("Set Delay for Sleepytime Mode")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
        }
        
        //picker for sleepytime mode delay
        Picker("Select Delay", selection: $selectedDelay) {
            Text("1 minute").tag(60)
            Text("5 minutes").tag(300)
            Text("10 minutes").tag(600)
            Text("15 minutes").tag(900)
            Text("20 minutes").tag(1200)
        }
        
        .pickerStyle(SegmentedPickerStyle())
        .padding()
        
        Spacer()
        
    }
    func snoozeAlarm() {
        alarmTime = Date().addingTimeInterval(snoozeDuration)
    }
    func startSleepytimeTimer( withDelay delay: TimeInterval) {
        sleepytimeTimer?.invalidate()  //invalidates any other timer
        sleepytimeTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false)
        {_ in
            isSleepModeActive.toggle()
        }
    }
}



 struct AlarmSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmSettingsView(snoozeDuration: .constant(60),
                          isSleepModeActive: .constant(false),
                          alarmTime: .constant(Date()),
                          isAlarmOn: .constant(true),
                          isAlarmTriggered: .constant(false))
    }
    
    
}


