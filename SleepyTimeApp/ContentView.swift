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

// Struct for Splash Screen
struct SplashScreenView: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.8
    @State private var systemImageOpacity = 0.0
    @State private var imageOpacity = 1.0
    
    var body: some View {
        ZStack {
            if isActive {
                ContentView()
                    .transition(.scale)
            } else {
               LinearGradient(gradient: Gradient(colors: [Color.blue, Color.black]), startPoint: .top, endPoint: .bottom)
            // Color.black.ignoresSafeArea()  //Alternate color choice: Plain Black
                
                    .ignoresSafeArea()
                                   
                VStack {
                    Image("logo")  //logo is the sleepytime logo in assets
                        .resizable()
                        .scaledToFit()
                        .opacity(imageOpacity)
                        .frame(width: 125, height: 125)
                        .padding()
                        .shadow(color: .black, radius: 5, x: 0, y: 5)
                }
                
               .scaleEffect(scale)
               .transition(.scale)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.9)) {
                        scale = 1
                        systemImageOpacity = 1
                   }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                    isActive = true
            }
        }
    }
}
struct ContentView: View {
    @State private var alarmTime = Date()
    @State private var isAlarmOn = false // Track whether the alarm is on or off
    
    var body: some View {
        TabView {
            SetAlarmView(alarmTime: $alarmTime, isAlarmOn: $isAlarmOn)
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
