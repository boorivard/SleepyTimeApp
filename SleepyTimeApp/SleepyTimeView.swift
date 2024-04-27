//
//  SleepyTimeView.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 3/17/24.
//
//  The View that is seen when the user enters sleepytime mode. Displays the time that the user has the alarm set for.


import SwiftUI

struct SleepModeView: View {

        @Binding var isSleepModeActive: Bool // Binding to control presentation
        @Binding var alarmTime: Date
        @Binding var isAlarmOn: Bool
        @Binding var snoozeDuration: TimeInterval
        @Binding var sleepytimeTimer: Timer?
        @State private var isAlarmTriggered = false
        @ObservedObject var manager: StatisticsManager
        var body: some View {
            
            VStack {
                if(isAlarmOn){
                    !isAlarmTriggered ? Text(alarmTime, format: .dateTime.hour().minute().second())//Text(alarmTime, style: .date)
                        .font(.system(size: 52))
                        .foregroundColor(.orange)
                        .padding() : nil
                }else{
                    Text("Alarm is Off")
                        .font(.system(size: 52))
                        .foregroundColor(.orange)
                        .padding()
                }
                
                !isAlarmTriggered ? Button(action: {
                    isSleepModeActive.toggle() // Toggle sleep mode
                }) {
                    Text("Exit Sleep Mode")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(maxWidth: .infinity)
                .background(Color.orange)
                .cornerRadius(10)
                .padding(.horizontal, 20) : nil
                if(isAlarmTriggered){
                    AlarmView(isSleepModeActive : $isSleepModeActive, alarmTime: $alarmTime, isAlarmOn: $isAlarmOn, isAlarmTriggered: $isAlarmTriggered, sleepytimeTimer:$sleepytimeTimer, snoozeDuration: $snoozeDuration, manager: manager)
                }
                
            }
            .onAppear(){
                    if(isAlarmOn){
                        alarmStarts()
                    }
            }
            
        }

        func alarmStarts(){
            let timer = Timer(fire: alarmTime, interval: 0, repeats: false) { _ in
                if(!isAlarmTriggered){
                        triggerAlarm()
                    }
                if(isSleepModeActive){
                    alarmStarts()
                }
            }
            RunLoop.main.add(timer, forMode: .common)
            
        }
        
        func triggerAlarm(){
            Sounds.playsSounds(soundfile: "alarm.wav")
            isAlarmTriggered.toggle()
        }
}
