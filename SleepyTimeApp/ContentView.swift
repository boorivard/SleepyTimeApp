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

    @State private var alarmTime = Date()

    @State private var isSleepModeActive = false // Track whether sleep mode is active

      
    

    var body: some View {
        
        TabView {
         
          
            VStack { // Embedding SetAlarmView and SleepModeView in a VStack
                
    
                SetAlarmView(isAlarmOn: $isAlarmOn, alarmTime: $alarmTime)
                  //  .background(
                     //         LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.8235294118, green: 0.9137254902, blue: 0.9960784314, alpha: 1)), Color(#colorLiteral(red: 0.9176470588, green: 0.9294117647, blue: 0.937254902, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                       //           .edgesIgnoringSafeArea(.all)
                       //   )
                
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

                    SleepModeView(isSleepModeActive: $isSleepModeActive)

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

    @Binding var isAlarmOn: Bool // Binding to track whether the alarm is on or off

    @Binding var alarmTime: Date // Binding to track alarm time

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

                                .foregroundColor(.black)

                                .padding()

                            

                            Text("\(alarms[index].time, style: .time)")

                                .foregroundColor(.black)

                                .padding()

                            

                            Spacer() // Pushes the toggle to the right

                            

                            Toggle(isOn: $alarms[index].isOn, label: {

                                Text(alarms[index].isOn ? "On" : "Off")

                                    .foregroundColor(.black)

                            })

                            .padding()

                            

                            Button(action: {

                                deleteAlarm(at: index)

                            }) {

                                Image(systemName: "trash")

                                    .foregroundColor(.black)

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

      //    .background(Color.blue) // Background color for the hidden state
            .background(Color.gray.opacity(0.1))

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
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect() // Timer to update the time every second
    @State private var currentTime = Date() // Variable to hold the current time
    
    // Define a DateFormatter for time display
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short // Choose your desired time style
        return formatter
    }()
    
    var body: some View {
        VStack {
          //  Text("Sleep Mode")
            //    .font(.title)
           //     .foregroundColor(.orange)
            //    .padding()
            
            Text(dateFormatter.string(from: currentTime)) // Use the DateFormatter to format the current time
                .font(.system(size: 52))
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
    
        .onReceive(timer) { time in
            self.currentTime = time // Update current time every second
        }
        .onDisappear {
            self.timer.upstream.connect().cancel() // Cancel timer when view disappears
        }
    }
}


struct ContentView_Previews: PreviewProvider {

    static var previews: some View {

        ContentView()

    }

}


