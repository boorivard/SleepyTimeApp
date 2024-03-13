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
    @State private var alarmTime = Date()
    @State private var isSleepModeActive = false // Track whether sleep mode is active
    
    var body: some View {

        TabView {

            VStack { // Embedding SetAlarmView and SleepModeView in a VStack

                SetAlarmView(alarmTime: $alarmTime, isAlarmOn: $isAlarmOn)

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


                    SleepModeView(isSleepModeActive: $isSleepModeActive, alarmTime: $alarmTime, isAlarmOn: $isAlarmOn)


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
    @Binding var alarmTime: Date
    @Binding var isAlarmOn: Bool // Binding to track whether the alarm is on or off
    @State private var isWheelHidden = true
    @State private var alarms: [Date] = [] // Track the alarms
  
    var body: some View {
        VStack {
            VStack {
                if isWheelHidden {
                    if let latestAlarm = alarms.last{
                        HStack {
                            Text("Next Alarm:")
                                .foregroundColor(.black)
                                .padding()

                            Text("\(latestAlarm, style: .time)")
                                .foregroundColor(.black)
                                .padding()

                            Spacer() // Pushes the toggle to the right

                            Toggle(isOn: $isAlarmOn, label: {
                                Text("Turn Alarm \(isAlarmOn ? "Off" : "On")")
                                    .foregroundColor(.black)
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
                        setAlarm(at: alarmTime)
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
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                    if Date() >= alarmTime {
                        triggerAlarm()
                        timer.invalidate()
                    }
                }
            }
            
            func triggerAlarm(){
                playSound()
                isAlarmTriggered = true
            }
            
            func playSound(){
                Sounds.playsSounds(soundfile: "alarm.wav")
            }
            
        }
        
        
        struct ContentView_Previews: PreviewProvider {
            
            static var previews: some View {
                
                ContentView()
                
            }
            
        }
        
        struct alarmstats {
            var hour: Int
            var minute: Int
        }
        //Function to calculate total alarm time
        func Totalalarmtime(alarm: alarmstats, Wakeuptime: Date) -> TimeInterval {
            let calendar = Calendar.current
            
            
            //Get current time & date
            _ = Date()
            let WakeupComponents = calendar.dateComponents([.year, .month, .day], from: Wakeuptime)
            
            // New date representing the alarm time for the current day
            var alarmDatecomponents = DateComponents()
            alarmDatecomponents.year = WakeupComponents.year
            alarmDatecomponents.month = WakeupComponents.month
            alarmDatecomponents.day = WakeupComponents.day
            alarmDatecomponents.hour = alarm.hour
            alarmDatecomponents.minute = alarm.minute
            
            let alarmTime = calendar.date(from: alarmDatecomponents)!
            
            //calculation for time slept
            let timeslept = Wakeuptime.timeIntervalSince(alarmTime)
            
            return timeslept
            
            
        }
        
