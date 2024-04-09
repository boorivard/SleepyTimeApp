//  SleepLogView.swift
//  SleepyTimeApp

import SwiftUI
// import Foundation

class SleepLogViewModel: ObservableObject {
    @Published var sleepQualityRecords: [Date: [String: Any]] = [:]
    
    func saveSleepQuality(for date: Date, ratings: [String: Any]) {
        sleepQualityRecords[date] = ratings
    }
    
    func getSleepQuality(for date: Date) -> [String: Any]? {
        return sleepQualityRecords[date]
    }
}

struct SleepLogView: View {
    @ObservedObject private var viewModel = SleepLogViewModel()
    @State private var selectedDate = Date()
    @State private var sleepDisturbances: Double = 0
    @State private var easeOfFallingAsleep: Double = 0
    @State private var hadDream: Bool = false
    @State private var feelingRestedUponWaking: Double = 0
    @State private var additionalComments: String = ""
    @ObservedObject var manager: StatisticsManager
    var body: some View {
        VStack(spacing: 20) {
            // Date selection controls
            HStack {
                // Left arrow button
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? Date()
                    updateSliderValues()
                    updateAdditionalComments()
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.blue)
                }

                // Date picker
                DatePicker("", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(CompactDatePickerStyle())

                // Right arrow button
                Button(action: {
                    selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? Date()
                    updateSliderValues()
                    updateAdditionalComments()
                }) {
                    Image(systemName: "arrow.right")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))

            // Questions
            VStack(spacing: 20) {
                TimeIntervalView(timeInterval: manager.statistics.timeBetween())
                SleepQualityQuestionView(question: "Number of Times You Woke up", value: $sleepDisturbances)
                SleepQualityQuestionView(question: "Ease of Falling Asleep", value: $easeOfFallingAsleep)
                SleepQualityQuestionView(question: "Feeling Rested Upon Waking", value: $feelingRestedUponWaking)
                
                // Add the question about dreaming
                HStack {
                    Text("Did You Dream?")
                    Spacer()
                    Picker("Dreamt", selection: $hadDream) {
                        Text("Yes").tag(true)
                        Text("No").tag(false)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 100)
                }
            }

            // Additional comments text field
            TextField("Additional Comments", text: $additionalComments, onCommit: {
                saveAdditionalComments()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

            // Save button
            Button(action: {
                saveSleepQuality()
                saveAdditionalComments()
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
            updateAdditionalComments()
        }
        .onChange(of: selectedDate) {
            updateSliderValues()
            updateAdditionalComments()
        }
    }

    private func updateSliderValues() {
        if let ratings = viewModel.getSleepQuality(for: selectedDate) {
            sleepDisturbances = ratings["Number of Times You Woke up"] as? Double ?? 0
            easeOfFallingAsleep = ratings["Ease of Falling Asleep"] as? Double ?? 0
            feelingRestedUponWaking = ratings["Feeling Rested Upon Waking"] as? Double ?? 0
            hadDream = ratings["Did You Dream"] as? Bool ?? false
        } else {
            sleepDisturbances = 0
            easeOfFallingAsleep = 0
            feelingRestedUponWaking = 0
            hadDream = false
        }
    }

    private func updateAdditionalComments() {
        if let comments = viewModel.getSleepQuality(for: selectedDate)?["Additional Comments"] as? String {
            additionalComments = comments
        } else {
            additionalComments = ""
        }
    }

    private func saveSleepQuality() {
        let ratings: [String: Any] = [
            "Number of Times You Woke up": sleepDisturbances,
            "Ease of Falling Asleep": easeOfFallingAsleep,
            "Did You Dream": hadDream,
            "Feeling Rested Upon Waking": feelingRestedUponWaking,
            "Additional Comments": additionalComments
        ]
        viewModel.saveSleepQuality(for: selectedDate, ratings: ratings)
    }

    private func saveAdditionalComments() {
        // Save additional comments for the selected date
        if var ratings = viewModel.getSleepQuality(for: selectedDate) {
            ratings["Additional Comments"] = additionalComments
            viewModel.saveSleepQuality(for: selectedDate, ratings: ratings)
        } else {
            var ratings: [String: Any] = [
                "Number of Times You Woke up": sleepDisturbances,
                "Ease of Falling Asleep": easeOfFallingAsleep,
                "Did You Dream": hadDream,
                "Feeling Rested Upon Waking": feelingRestedUponWaking
            ]
            ratings["Additional Comments"] = additionalComments
            viewModel.saveSleepQuality(for: selectedDate, ratings: ratings)
        }
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

