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
    @Binding var sleepyTimeDelay: TimeInterval
    @State private var selectedDelay: TimeInterval = 5
    //defaulted sleepytime mode delay to 5 minutes
    @Binding var sleepytimeTimer: Timer?
    
    @State private var userinputMinutes: Double = 0
    @State private var sleepmodedelay: TimeInterval = 10
    
    var body: some View {
        VStack {
            Text("Snooze Timer: ")
            TextField ("Enter Snooze Duration (minutes)", value: $userinputMinutes, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
        
            Text ("Sleep Mode Delay: ")
            TextField ("Enter Sleep Mode Delay (minutes)", value: $sleepmodedelay, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button ("Apply") {
                snoozeDuration = userinputMinutes * 60
                sleepyTimeDelay = sleepmodedelay * 60
                             }
            .padding()
            
        }
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
    

    
    
    
    
