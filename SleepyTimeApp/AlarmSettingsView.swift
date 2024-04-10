//
//  AlarmSettingsView.swift
//  SleepyTimeApp
//
//  Created by Nicholas Schiffer on 4/9/24.
//
import SwiftUI

struct AlarmSettingsView: View {
    @Binding var snoozeDuration: TimeInterval
    @Binding var isSleepModeActive: Bool
    @Binding var alarmTime: Date
    @Binding var isAlarmOn: Bool
    @Binding var isAlarmTriggered: Bool

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
    }

    func snoozeAlarm() {
        alarmTime = Date().addingTimeInterval(snoozeDuration)
    }
}




/* struct AlarmSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmSettingsView(snoozeDuration: .constant(60),
                          isSleepModeActive: .constant(false),
                          alarmTime: .constant(Date()),
                          isAlarmOn: .constant(true),
                          isAlarmTriggered: .constant(false))
    }
    
    
}  */
