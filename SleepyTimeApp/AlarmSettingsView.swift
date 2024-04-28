//
//  AlarmSettingsView.swift
//  SleepyTimeApp
//
//  Created by Nicholas Schiffer on 4/9/24.
//
//  View that consists of general settings for an alarm.
//
// NOTE TO REVIEWER: IN PROGRESS, NOT IN FINAL FORM

import SwiftUI
import FirebaseAuth
struct AlarmSettingsView: View {
    @Binding var snoozeDuration: TimeInterval
    @Binding var sleepyTimeDelay: TimeInterval
    @Binding var sleepytimeTimer: Timer?
    @State private var userinputMinutes: Double = 5
    @State private var sleepmodedelay: TimeInterval = 10
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            Text("Snooze Timer: ")
            TextField ("Enter Snooze Duration (minutes)", value: $userinputMinutes, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)
            
            Text ("Sleep Mode Delay: ")
                .padding(.top, 20)
            TextField ("Enter Sleep Mode Delay (minutes)", value: $sleepmodedelay, formatter: NumberFormatter())
                .keyboardType(.numberPad)
                .multilineTextAlignment(.center)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                

            
            Button ("Apply") {
                snoozeDuration = userinputMinutes * 60
                sleepyTimeDelay = sleepmodedelay * 60
                
            }
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            Spacer().frame(height: 120)
            
            Button(action: {
                showingAlert = true
            }) {
                Text("Log Out")
                    .font(.system(size: 15))
                    .padding()
                    .foregroundColor(.red)
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Are you sure you want to log out?"),
                            message: Text("You will exit the app."),
                            primaryButton: .destructive(Text("Log Out")) {
                                do {
                                    try Auth.auth().signOut()
                                    exit(0)
                                } catch {
                                    print("Error signing out: \(error.localizedDescription)")
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
            }
        }.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}
    /*func startSleepytimeTimer( withDelay delay: TimeInterval) {
     sleepytimeTimer?.invalidate()  //invalidates any other timer
     sleepytimeTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false)
     {_ in
     isSleepModeActive.toggle()
     }
     }*/
    
    
    
    
    /*struct AlarmSettingsView_Previews: PreviewProvider {
     static var previews: some View {
     AlarmSettingsView(snoozeDuration: <#Binding<TimeInterval>#>, sleepytimeTimer: <#Binding<Timer?>#>)
     }*/
    

    
    
    
    
