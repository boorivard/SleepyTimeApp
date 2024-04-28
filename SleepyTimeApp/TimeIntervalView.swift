//
//  TimeIntervalView.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 4/3/24.
//
//  A view that is used to display a time interval in terms of its hours and minutes. Used in the Journal to display houw long someone slept.
//
import SwiftUI

struct TimeIntervalView: View {
    let timeInterval: TimeInterval

    var body: some View {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60

        return Text("Time That You Slept: \(String(format: "%02d:%02d", hours, minutes))")
            .font(.title)
            .fontWeight(.bold)
    }
}

