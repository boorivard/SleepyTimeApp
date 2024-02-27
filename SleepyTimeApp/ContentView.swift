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
