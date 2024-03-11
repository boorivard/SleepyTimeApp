//
//  ContentView.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 2/18/24.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var isAlarmOn = false // Track whether the alarm is on or off
    
    var body: some View {
        TabView {
            SetAlarmView(isAlarmOn: $isAlarmOn)
                .tabItem {
                    Image(systemName: "alarm")
                    Text("Set Alarm")
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    // Check if the alarm is set when the app comes into foreground
                    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                        DispatchQueue.main.async {
                            self.isAlarmOn = !requests.isEmpty
                        }
                    }
                }
                .onAppear {
                    // Check if the alarm is set when the app initially appears
                    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
                        DispatchQueue.main.async {
                            self.isAlarmOn = !requests.isEmpty
                        }
                    }
                }
            
            StatisticsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Statistics")
                }
                .background(Color.green)
                .edgesIgnoringSafeArea(.all)
            
            SleepLogView()
                .tabItem {
                    Image(systemName: "moon.stars.fill")
                    Text("Sleep Log")
                }
                .background(Color.green)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

struct SetAlarmView: View {
    @Binding var isAlarmOn: Bool // Binding to track whether the alarm is on or off
    @State private var alarms: [Alarm] = [] // Track the alarms
    
    @State private var isAddingAlarm = false // Track whether the user is adding a new alarm
    @State private var selectedAlarmTime = Date() // Temporary variable to capture selected alarm time
    
    var body: some View {
        VStack {
            VStack {
                if alarms.count > 0 {
                    ForEach(alarms.indices, id: \.self) { index in
                        HStack {
                            Text("Alarm \(index + 1):")
                                .foregroundColor(.white)
                                .padding()
                            
                            Text("\(alarms[index].time, style: .time)")
                                .foregroundColor(.white)
                                .padding()
                            
                            Spacer() // Pushes the toggle to the right
                            
                            Toggle(isOn: $alarms[index].isOn, label: {
                                Text(alarms[index].isOn ? "On" : "Off")
                                    .foregroundColor(.white)
                            })
                            .padding()
                            
                            Button(action: {
                                deleteAlarm(at: index)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                    }
                }
                
                Button(action: {
                    isAddingAlarm.toggle()
                }) {
                    HStack {
                        Image(systemName: "plus.circle")
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
                
                if isAddingAlarm {
                    DatePicker("Select Alarm Time", selection: $selectedAlarmTime, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                        .padding()
                    
                    Button(action: {
                        addAlarm(at: selectedAlarmTime)
                        isAddingAlarm = false // Hide the DatePicker after setting the alarm
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
    
    private func addAlarm(at time: Date) {
        alarms.append(Alarm(time: time, isOn: true))
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "Alarm"
        content.body = "Time to wake up!"
        
        // Extract hour and minute components from the selected time
        let components = Calendar.current.dateComponents([.hour, .minute], from: time)
        
        // Create trigger for notification based on selected time
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        // Create request for notification
        let request = UNNotificationRequest(identifier: "Alarm-\(time.description)", content: content, trigger: trigger)
        
        // Add request to notification center
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Alarm set for \(time)")
            }
        }
    }
    
    private func deleteAlarm(at index: Int) {
        let alarm = alarms[index]
        alarms.remove(at: index)
        
        // Remove corresponding notification request
        let alarmTime = alarm.time
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["Alarm-\(alarmTime.description)"])
    }
}

struct Alarm: Identifiable {
    let id = UUID()
    let time: Date
    var isOn: Bool
}

// Other views remain the same

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
