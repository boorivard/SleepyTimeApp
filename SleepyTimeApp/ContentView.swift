//
//  ContentView.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 2/18/24.
//
//  The Main view when the user enters the app

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var isAlarmOn = false // Track whether the alarm is on or off
    @State private var alarmTime = Date()
    @State private var isSleepModeActive = false // Track whether sleep mode is active
    @State private var snoozeDuration: TimeInterval = 300
    @State private var sleepytimeTimer: Timer?
    
    @ObservedObject var manager: StatisticsManager
    
    
    
    var body: some View {
        TabView {
            VStack { // Embedding SetAlarmView and SleepModeView in a VStack
               SetAlarmView(alarmTime: $alarmTime, isAlarmOn: $isAlarmOn)
                Button(action: {
                    manager.statistics.setStartTime(Date())
                    isSleepModeActive.toggle() // Toggle sleep mode
                }) {
                    Text("Enter Sleep Mode")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .sheet(isPresented: $isSleepModeActive) {
                    SleepModeView(isSleepModeActive: $isSleepModeActive, alarmTime: $alarmTime, isAlarmOn: $isAlarmOn, snoozeDuration: $snoozeDuration, sleepytimeTimer: $sleepytimeTimer, manager:manager)
                }
            }
            .tabItem {
                Image(systemName: "alarm")
                Text("Set Alarm")
            }
            SleepLogView(manager:manager)
               .tabItem {
                    Image(systemName: "moon.stars.fill")
                    Text("Sleep Log")
                }
            AlarmSettingsView(snoozeDuration: $snoozeDuration, sleepytimeTimer: $sleepytimeTimer)
          
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
        }
    }
}

/*struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}*/
