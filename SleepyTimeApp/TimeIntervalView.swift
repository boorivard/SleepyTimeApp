//
//  TimeIntervalView.swift
//  SleepyTimeApp
//
//  Created by Jared Rivard on 4/3/24.
//

import SwiftUI

struct TimeIntervalView: View {
    let timeInterval: TimeInterval

    var body: some View {
        let hours = Int(timeInterval) / 3600
        let minutes = Int(timeInterval) / 60 % 60

        return Text("Time that you slept: \(String(format: "%02d:%02d", hours, minutes))")
            .font(.title)
            .fontWeight(.bold)
    }
}

