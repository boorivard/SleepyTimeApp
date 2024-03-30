//  SleepLogView.swift
//  SleepyTimeApp

import Foundation
import SwiftUI

class SleepLogViewModel: ObservableObject {
    @Published var sleepQualityRecords: [Date: [String: Double]] = [:]
    
    func saveSleepQuality(for date: Date, ratings: [String: Double]) {
        sleepQualityRecords[date] = ratings
    }
    
    func getSleepQuality(for date: Date) -> [String: Double]? {
        return sleepQualityRecords[date]
    }
}

struct SleepLogView: View {
    @ObservedObject private var viewModel = SleepLogViewModel()
    @State private var selectedDate = Date()
    @State private var sleepQuality: Double = 0
    @State private var easeOfFallingAsleep: Double = 0
    @State private var qualityOfDeepSleep: Double = 0
    @State private var feelingRestedUponWaking: Double = 0
    
    var body: some View {
        VStack(spacing: 20) {
            // Date selection controls
            HStack {
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? Date()
                    updateSliderValues()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                }
                
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())
                
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? Date()
                    updateSliderValues()
                }) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            
            // Display sleep quality rating
            if let selectedSleepQuality = viewModel.getSleepQuality(for: selectedDate) {
                Text("Sleep Quality for \(selectedDate.formattedDate): \(Int(selectedSleepQuality["Overall Sleep Quality"] ?? 0))")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding()
            }
            
            // Questions
            VStack(spacing: 20) {
                SleepQualityQuestionView(question: "Overall Sleep Quality", value: $sleepQuality)
                SleepQualityQuestionView(question: "Ease of Falling Asleep", value: $easeOfFallingAsleep)
                SleepQualityQuestionView(question: "Quality of Deep Sleep", value: $qualityOfDeepSleep)
                SleepQualityQuestionView(question: "Feeling Rested Upon Waking", value: $feelingRestedUponWaking)
            }
            
            // Save button
            Button(action: {
                saveSleepQuality()
            }) {
                Text("Save")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
        .onAppear {
            updateSliderValues()
        }
        .onChange(of: selectedDate) {
            updateSliderValues()
        }
    }
        
    private func updateSliderValues() {
        if let ratings = viewModel.getSleepQuality(for: selectedDate) {
            sleepQuality = ratings["Overall Sleep Quality"] ?? 0
            easeOfFallingAsleep = ratings["Ease of Falling Asleep"] ?? 0
            qualityOfDeepSleep = ratings["Quality of Deep Sleep"] ?? 0
            feelingRestedUponWaking = ratings["Feeling Rested Upon Waking"] ?? 0
        } else {
            sleepQuality = 0
            easeOfFallingAsleep = 0
            qualityOfDeepSleep = 0
            feelingRestedUponWaking = 0
        }
    }
    
    private func saveSleepQuality() {
        let ratings: [String: Double] = [
            "Overall Sleep Quality": sleepQuality,
            "Ease of Falling Asleep": easeOfFallingAsleep,
            "Quality of Deep Sleep": qualityOfDeepSleep,
            "Feeling Rested Upon Waking": feelingRestedUponWaking
        ]
        viewModel.saveSleepQuality(for: selectedDate, ratings: ratings)
    }
}

struct SleepQualityQuestionView: View {
    var question: String
    @Binding var value: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question)
                .font(.headline)
                .foregroundColor(.primary)
            Slider(value: $value, in: 0...5, step: 1)
            Text("\(Int(value))")
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding(.horizontal)
    }
}

extension Date {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: self)
    }
}

