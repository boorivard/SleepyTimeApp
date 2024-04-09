//
//  SetAlarmView.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 3/17/24.
//

import SwiftUI

struct SetAlarmView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var alarmTime: Date
    @Binding var isAlarmOn: Bool // Binding to track whether the alarm is on or off
    @State private var isWheelHidden = true
    @State private var alarms: [Date] = []
  
    var body: some View {
        VStack {
            VStack {
                if isWheelHidden {
                    if let latestAlarm = alarms.last{
                        HStack {
                            Text( "Next Alarm:")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .padding()

                            Text("\(latestAlarm, style: .time)")
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .padding()

                            Spacer() // Pushes the toggle to the right

                            Toggle(isOn: $isAlarmOn, label: {
                                Text("Turn Alarm \(isAlarmOn ? "Off" : "On")")
                                    .foregroundColor(colorScheme == .dark ? .white : .black)
                            })

                            .padding()
                        }

                    }

                    Button(action: {
                        withAnimation {
                            isWheelHidden.toggle()
                        }
                    }) {
                        HStack {
                            Image(systemName: "slider.horizontal.3")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Add Alarm")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                } else {
                    List {
                        ForEach(alarms, id: \.self) { alarm in
                            Text(alarm, style: .time)
                        }
                    }

                    DatePicker("Select Alarm Time", selection: $alarmTime, displayedComponents: .hourAndMinute)

                        .labelsHidden()

                        .datePickerStyle(WheelDatePickerStyle())

                        .padding()
                        .onAppear {
                                                UIDatePicker.appearance().minuteInterval = 1
                                            }
                        
                    
                    Button(action: {
                        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alarmTime)
                                        
                                        
                        let adjustedAlarmTime = Calendar.current.date(from: components)!
                        setAlarm(at: alarmTime)
                       /* if alarmTime < Date() {
                                            alarmTime = Date().addingTimeInterval(86400)
                                            // You can adjust this value according to your requirements
                                        }*/
                        alarms.append(alarmTime)
                        isWheelHidden = true
                    }) {
                        HStack {
                           Image(systemName: "slider.horizontal.3")
                                .font(.title)
                                .foregroundColor(.white)
                            Text("Set Alarm")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1)) // Background color for the hidden state
        }
    }
    private func setAlarm(at time: Date) {

        // Create notification content

        let content = UNMutableNotificationContent()

        content.title = "Alarm"

        content.body = "Time to wake up!"

        // Extract hour and minute components from the selected time

        let components = Calendar.current.dateComponents([.hour, .minute], from: time)

        // Create trigger for notification based on selected time

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)



        // Create request for notification
        let request = UNNotificationRequest(identifier: "Alarm", content: content, trigger: trigger)

        // Add or remove request based on alarm state
        if isAlarmOn {
            // Add request to notification center
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Alarm set for \(time)")
                }
            }
        }
    }
}

