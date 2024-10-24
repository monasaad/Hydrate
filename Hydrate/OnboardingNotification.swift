// OnboardingNotification.swift
// Hydrate
//
// Created by Mona on 17/04/1446 AH.
//
import SwiftUI
import UserNotifications

struct OnboardingNotification: View {
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var picker1: String = "AM"
    @State private var picker2: String = "AM"
    @State private var selectedButton: Int? = nil
    let hour = 0...12
    let minutes = 00...59
    let intervalsNum = [1, 30, 60, 90, 2, 3, 4, 5]
    let intervalsText = ["Mins", "Mins", "Mins", "Mins", "Hours", "Hours", "Hours", "Hours"]

    var body: some View {
    
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Notification Preferences").font(.title)
                    .fontWeight(.semibold)
                    .padding(.vertical, 20)

                Text("The start and end hour").fontWeight(.semibold)
                Text("Specify the start and end date to receive the notifications")
                    .foregroundColor(.gray)

                VStack {
                    HStack {
                        Text("Start hour")
                        Spacer()
                        DatePicker("Time", selection: $startTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.compact)
                            .labelsHidden()
//                        Picker("", selection: $picker1) {
//                            Text("AM").tag("AM")
//                            Text("PM").tag("PM")
//                            Text("PM").tag("PM")
//                        }.pickerStyle(WheelPickerStyle())
//                            .frame(width: 100)
                        
                        Picker("", selection: $picker1) {
                            Text("AM").tag("AM")
                            Text("PM").tag("PM")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 100)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)

                    Divider()

                    HStack {
                        Text("End hour")
                        Spacer()
                        DatePicker("Time", selection: $endTime, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.compact)
                            .labelsHidden()

                        Picker("", selection: $picker2) {
                            Text("AM").tag("AM")
                            Text("PM").tag("PM")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 100)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 10)
                }
                .frame(maxWidth: .infinity)
                .background(Color.gray.opacity(0.2))
                .padding(.top, 20)

                Text("Notification interval").fontWeight(.semibold).padding(.top, 25)
                Text("How often would you like to receive notifications within the specified time interval")
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)

                VStack {
                    ForEach(0..<4) { index in // ?
                        HStack(spacing: 20) {
                            ForEach(0..<4) { buttonIndex in // ?
                                let actualIndex = index * 4 + buttonIndex // ?
                                if actualIndex < intervalsNum.count {
                                    Button(action: {
                                        selectedButton = actualIndex + 1
                                    }) {
                                        VStack {
                                            Text("\(intervalsNum[actualIndex])").foregroundColor(selectedButton == actualIndex + 1 ? .white : .cyan)
                                            Text(intervalsText[actualIndex]).foregroundColor(selectedButton == actualIndex + 1 ? .white : .black)
                                        }
                                        .frame(maxWidth: 77, maxHeight: 70)
                                        .background(selectedButton == actualIndex + 1 ? Color.cyan : Color.gray.opacity(0.2))
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 10)
                }

                Spacer()
                NavigationLink(destination: IntankProgress()) {
                    Button(action: {
                        if let selectedButton = selectedButton {
                            scheduleNotifications(for: intervalsNum[selectedButton - 1])
                        }
                    }) {
                        Text("Start")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(Color.cyan)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }

    private func scheduleNotifications(for interval: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder Notification💧"
        content.body = "This is a notification after \(interval) \(interval < 60 ? "minutes" : "hours")."
        content.sound = .default

        // Calculate the interval in seconds
        let intervalInSeconds = TimeInterval(interval * 60)

        // Start scheduling notifications from startTime until endTime
        var currentTriggerTime = startTime

        // Adjust currentTriggerTime to the nearest minute if necessary
        currentTriggerTime = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: currentTriggerTime),
                                                   minute: Calendar.current.component(.minute, from: currentTriggerTime),
                                                   second: 0,
                                                   of: currentTriggerTime) ?? currentTriggerTime
        
        while currentTriggerTime <= endTime {
            // Calculate the time until the next notification
            let triggerTime = currentTriggerTime.timeIntervalSinceNow
            
            // Schedule notification only if the trigger time is in the future
            if triggerTime > 0 {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerTime, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    }
                }
            }

            // Move to the next notification time
            currentTriggerTime.addTimeInterval(intervalInSeconds)
        }
    }
}

#Preview {
    OnboardingNotification()
}
