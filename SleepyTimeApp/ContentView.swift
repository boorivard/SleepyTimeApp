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

        struct ContentView_Previews: PreviewProvider {
            static var previews: some View {
                ContentView()
            }
        }
