//
//  SleepyTimeView.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 3/17/24.
//

import SwiftUI

struct SleepModeView: View {

        @Binding var isSleepModeActive: Bool // Binding to control presentation
        @Binding var alarmTime: Date
        @Binding var isAlarmOn: Bool
        @State private var isAlarmTriggered = false
        @ObservedObject var manager: StatisticsManager
        var body: some View {
            
            VStack {
                if(isAlarmOn){
                    !isAlarmTriggered ? Text(alarmTime, style: .time)
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
                    AlarmView(isSleepModeActive : $isSleepModeActive, alarmTime: $alarmTime, isAlarmOn: $isAlarmOn, isAlarmTriggered: $isAlarmTriggered, manager:manager)
                }
                
            }
            .onAppear(){
                    if(isAlarmOn){
                        alarmGoesOff()
                    }
            }
            
        }
        
        func alarmGoesOff(){
            let timer = Timer(fire: alarmTime, interval: 0, repeats: false) { _ in
                if(!isAlarmTriggered){
                        triggerAlarm()
                    }
                if(isSleepModeActive){
                    alarmGoesOff()
                }
            }
            RunLoop.main.add(timer, forMode: .common)
            
        }
        
        func triggerAlarm(){
            Sounds.playsSounds(soundfile: "alarm.wav")
            isAlarmTriggered.toggle()
        }
}
