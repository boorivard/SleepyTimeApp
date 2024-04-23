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
    @State private var selectedDelay: TimeInterval = 300   //defaulted sleepytime mode delay to 5 minutes
    @Binding var sleepytimeTimer: Timer?
    
    var body: some View {
        VStack {
            Slider(value: $snoozeDuration, in: 10...600, step: 10) {
                Text("Snooze Timer: \(Int(snoozeDuration)) seconds")
            }
            .padding()
        
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
    }
    /*func startSleepytimeTimer( withDelay delay: TimeInterval) {
        sleepytimeTimer?.invalidate()  //invalidates any other timer
        sleepytimeTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false)
        {_ in
            isSleepModeActive.toggle()
        }
    }*/
}



 /*struct AlarmSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmSettingsView(snoozeDuration: <#Binding<TimeInterval>#>, sleepytimeTimer: <#Binding<Timer?>#>)
    }*/
    
    



