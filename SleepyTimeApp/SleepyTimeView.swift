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
    @State private var isAlarmTriggered = false
    @State private var snoozetime: TimeInterval = 300 // default snooze time is set to 5 minutes
    var body: some View {
    
        VStack {
            
            Text("Sleep Mode-\(alarmTime, style: .time)")

                .font(.title)

                .foregroundColor(.orange)

                .padding()

            

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
            
            Button(action: {
                SnoozeAlarm()
            }) {
                Text ("Snooze Alarm")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(maxWidth: .infinity)

            .background(Color.orange)

            .cornerRadius(10)

            .padding(.horizontal, 20)
            
            
            // User configurable snoozetime --> have to send to Setting view
            
            Slider(value: $snoozetime, in:60...600, step: 60) {
                Text("Snooze Time: \(Int(snoozetime / 60)) minutes")
            }
            .padding (.horizontal, 20)
        }
        .onAppear(){
            alarmGoesOff()
        }

    }
    
    func alarmGoesOff(){
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if Date() >= alarmTime {
                triggerAlarm()
                isSleepModeActive.toggle()
                timer.invalidate()
            }
        }
    }
    
    func triggerAlarm(){
        playSound()
        isAlarmTriggered = true
    }
    
    func playSound(){
        guard let soundURL = Bundle.main.url(forResource:"alarm", withExtension: "wav") else {return}
        let player = AVPlayer(url:soundURL)
        player.play()
    }
    func SnoozeAlarm(){
        alarmTime = Date().addingTimeInterval(snoozetime)
    }
}
