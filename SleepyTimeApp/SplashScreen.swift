//
//  SplashScreen.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 3/1/24.
//
//  A splash screen that plays a quick animation letting the user into the app.

import SwiftUI

struct SplashScreen: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 0.8
    @State private var systemImageOpacity = 0.0
    @State private var imageOpacity = 1.0
    @ObservedObject private var manager = StatisticsManager(startTime: Date(), endTime: Date())
    var body: some View {
        ZStack {
            if isActive {
                ContentView(manager:manager)
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
                        .frame(width: 400, height: 400)
                        .padding()
                        .shadow(color: .black, radius: 5, x: 0, y: 5)
                }
                
               .scaleEffect(scale)
               .transition(.scale)
                .onAppear {
                    withAnimation(.easeInOut(duration: 3)) {
                        scale = 1
                        systemImageOpacity = 1
                   }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    isActive = true
            }
        }
    }
}

#Preview {
    SplashScreen()
}
