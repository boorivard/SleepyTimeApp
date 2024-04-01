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
    
    var body: some View {
        
        VStack {
            if(isAlarmOn){
                Text(alarmTime, style: .time)
                    .font(.system(size: 52))
                    .foregroundColor(.orange)
                    .padding()
            }else{
                Text("Alarm is Off")
                    .font(.system(size: 52))
                    .foregroundColor(.orange)
                    .padding()
            }
            
            Button(action: {
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
            .padding(.horizontal, 20)
            Button("Stop") {
                isAlarmTriggered.toggle()
                Sounds.stopSound()
                isSleepModeActive.toggle()
            }
            .padding()
            .background(Color.orange)
            .foregroundColor(.white)
            .cornerRadius(100)
            .opacity(isAlarmTriggered ? 1 : 0) // Toggle button visibility
        }
        .onAppear(){
            if(isAlarmOn){
                alarmGoesOff()
            }
        }
        
    }
    
    func alarmGoesOff(){
        let timer = Timer(fire: alarmTime, interval: 0, repeats: false) { _ in
            triggerAlarm()
        }
        RunLoop.main.add(timer, forMode: .common)
    }
    
    func triggerAlarm(){
        Sounds.playsSounds(soundfile: "alarm.wav")
        isAlarmTriggered = true
    }
    
}
