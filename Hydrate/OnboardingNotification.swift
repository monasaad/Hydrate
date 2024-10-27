import SwiftUI
import UserNotifications

struct OnboardingNotification: View {
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var selectedButton: Int? = nil
    @State private var isNavigating = false

    let intervalsNum = [1, 30, 60, 90, 2, 3, 4, 5]
    let intervalsText = ["Mins", "Mins", "Mins", "Mins", "Hours", "Hours", "Hours", "Hours"]

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                Text("Notification Preferences")
                    .font(.title)
                    .fontWeight(.semibold)
                    .padding(.vertical, 20)

                Text("Specify the start and end time to receive notifications")
                    .foregroundColor(.gray)

                timePickerSection(title: "Start hour", time: $startTime)
                timePickerSection(title: "End hour", time: $endTime)

                Text("Notification interval")
                    .fontWeight(.semibold)
                    .padding(.top, 25)
                Text("How often would you like to receive notifications within the specified time interval")
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)

                intervalButtons()

                Spacer()
                Button(action: {
                    if let selectedButton = selectedButton {
                        requestNotificationPermissions {
                            scheduleNotifications(for: intervalsNum[selectedButton - 1])
                            isNavigating = true
                        }
                    }
                }) {
                    Text("Start")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(Color.cyan)
                        .cornerRadius(10)
                }

                NavigationLink(destination: IntankProgress()) {}
            }
            .padding()
            .navigationBarBackButtonHidden(true)
        }
    }

    private func timePickerSection(title: String, time: Binding<Date>) -> some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                DatePicker("Time", selection: time, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
                    .labelsHidden()
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            Divider()
        }
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.2))
        .padding(.top, 20)
    }

    private func intervalButtons() -> some View {
        ForEach(0..<2) { index in
            HStack(spacing: 20) {
                ForEach(0..<4) { buttonIndex in
                    let actualIndex = index * 4 + buttonIndex
                    if actualIndex < intervalsNum.count {
                        Button(action: {
                            selectedButton = actualIndex + 1
                        }) {
                            VStack {
                                Text("\(intervalsNum[actualIndex])")
                                    .foregroundColor(selectedButton == actualIndex + 1 ? .white : .cyan)
                                Text(intervalsText[actualIndex])
                                    .foregroundColor(selectedButton == actualIndex + 1 ? .white : .black)
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

    private func requestNotificationPermissions(completion: @escaping () -> Void) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            }
            if granted {
                DispatchQueue.main.async {
                    completion()
                }
            } else {
                print("Notification permission not granted.")
            }
        }
    }

    private func scheduleNotifications(for interval: Int) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder Notification💧"
        content.body = "This is a notification after \(interval) \(interval < 60 ? "minutes" : "hours")."
        content.sound = .default

        let intervalInSeconds = TimeInterval(interval * 60)
        var currentTriggerTime = startTime

        // Debugging output
        print("Scheduling notifications from \(startTime) to \(endTime) every \(interval) \(interval < 60 ? "minutes" : "hours").")

        while currentTriggerTime <= endTime {
            let triggerTime = currentTriggerTime.timeIntervalSinceNow
            
            if triggerTime > 0 {
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerTime, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error scheduling notification: \(error.localizedDescription)")
                    } else {
                        print("Notification scheduled for \(currentTriggerTime)")
                    }
                }
            }

            currentTriggerTime.addTimeInterval(intervalInSeconds)
        }
    }
}

#Preview {
    OnboardingNotification()
}
