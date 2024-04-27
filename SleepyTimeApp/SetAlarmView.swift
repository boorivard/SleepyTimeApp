//
//  SetAlarmView.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 3/17/24.
//
//  The view that is used to set the alarm itself.

import SwiftUI

struct SetAlarmView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var alarmTime: Date
    @Binding var isAlarmOn: Bool // Binding to track whether the alarm is on or off
    @State private var isWheelHidden = true
    @State private var alarms: [Date] = [] //better way to store data?
    
    var body: some View {
        VStack {
            VStack {
                if isWheelHidden {
                    if let latestAlarm = alarms.last{
                        HStack {
                        
                            Text("\(latestAlarm, style: .time)")
                                .font(.largeTitle)
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                                .padding(15)
                                
                             Text("                ") //space between the set alarm time and the "on/off" text
                                .font(.headline)

                            Toggle(isOn: $isAlarmOn, label: {
                                Text("\(isAlarmOn ? "On" : "Off")")
                                    .font(.title)
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
                        let calendar = Calendar.current
                        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: alarmTime)
                        let dateWithoutSeconds = calendar.date(from: dateComponents)
                        alarmTime = dateWithoutSeconds ?? alarmTime
                       if alarmTime < Date() {
                                            alarmTime = Date().addingTimeInterval(86400)
                                        }
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

}

