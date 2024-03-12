//
//  ContentView.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 2/18/24.
//

import SwiftUI
import UserNotifications
import AVFoundation




struct ContentView: View {

    @State private var isAlarmOn = false // Track whether the alarm is on or off

    @State private var alarmTime = Date() + 20

    @State private var isSleepModeActive = false // Track whether sleep mode is active
    

    

    var body: some View {

        TabView {

            VStack { // Embedding SetAlarmView and SleepModeView in a VStack

                SetAlarmView()

                Button(action: {

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

                    SleepModeView(isSleepModeActive: $isSleepModeActive, alarmTime: $alarmTime)

                }

            }

            .tabItem {

                Image(systemName: "alarm")

                Text("Set Alarm")

            }

            

            StatisticsView()

                .tabItem {

                    Image(systemName: "chart.bar.fill")

                    Text("Statistics")

                }

            

            SleepLogView()

                .tabItem {

                    Image(systemName: "moon.stars.fill")

                    Text("Sleep Log")

                }

        }

    }

}



struct SetAlarmView: View {

    @State public var alarms: [Alarm] = [] // Track the alarms
    
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



struct SleepModeView: View {

    @Binding var isSleepModeActive: Bool // Binding to control presentation
    @Binding var alarmTime: Date
    @State private var isAlarmTriggered = false
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
        
}



struct ContentView_Previews: PreviewProvider {

    static var previews: some View {

        ContentView()

    }

}

