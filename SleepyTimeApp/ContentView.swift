//
//  ContentView.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 2/18/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

struct SetAlarmView: View {
    @Binding var alarmTime: Date
    @Binding var isAlarmOn: Bool // Binding to track whether the alarm is on or off
    @State private var isWheelHidden = true
    @State private var alarms: [Date] = [] // Track the alarms
    
    var body: some View {
        VStack {
            VStack {
                if isWheelHidden {
                    if let latestAlarm = alarms.last {
                        HStack {
                            Text("Next Alarm:")
                                .foregroundColor(.white)
                                .padding()
                            
                            Text("\(latestAlarm, style: .time)")
                                .foregroundColor(.white)
                                .padding()
                            
                            Spacer() // Pushes the toggle to the right
                            
                            Toggle(isOn: $isAlarmOn, label: {
                                Text("Turn Alarm \(isAlarmOn ? "Off" : "On")")
                                    .foregroundColor(.white)
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
                    
                    Button(action: {
                        setAlarm(at: alarmTime)
                        alarms.append(alarmTime) // Add the new alarm to the list
                        isWheelHidden = true // Hide the wheel after setting the alarm
                    }) {
                        HStack {
                            Image(systemName: "slider.horizontal.3")
                                .font(.title)
                                .foregroundColor(.red)
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
            .background(Color.blue) // Background color for the hidden state
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
        } else {
            // Remove request from notification center
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["Alarm"])
        }
    }
}


struct StatisticsView: View {
    var body: some View {
        Text("Statistics")
            .font(.title)
            .padding()
    }
}

struct SleepLogView: View {
    var body: some View {
        Text("Sleep Log")
            .font(.title)
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
