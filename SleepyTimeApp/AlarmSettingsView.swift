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
    @State private var selectedDelay: TimeInterval = 5
    //defaulted sleepytime mode delay to 5 minutes
    @Binding var sleepytimeTimer: Timer?
    
    var body: some View {
        VStack {
            Text("Snooze Timer: \(Int(snoozeDuration)) minutes")
                TextField ("Enter Snooze Duration (minutes)", value: $snoozeDuration, formatter: NumberFormatter())
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    
            }
            .padding()
            
            
        }
    }
    /*func startSleepytimeTimer( withDelay delay: TimeInterval) {
     sleepytimeTimer?.invalidate()  //invalidates any other timer
     sleepytimeTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false)
     {_ in
     isSleepModeActive.toggle()
     }
     }*/
    
    
    
    
    /*struct AlarmSettingsView_Previews: PreviewProvider {
     static var previews: some View {
     AlarmSettingsView(snoozeDuration: <#Binding<TimeInterval>#>, sleepytimeTimer: <#Binding<Timer?>#>)
     }*/
    

    
    
    
    
