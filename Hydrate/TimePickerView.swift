import SwiftUI

struct TimePickerView: View {
    @State private var selectedHour: Int
    @State private var selectedMinute: Int
    @State private var selectedPeriod: String
    @State private var showPopover = false

    let hours = Array(0...12) // Array for hours
    let minutes = Array(0...59) // Array for minutes

    init() {
        // Get the current time
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let minute = calendar.component(.minute, from: now)

        // Determine AM/PM and adjust hour for display
        if hour >= 12 {
            selectedPeriod = "PM"
            selectedHour = hour == 12 ? 12 : hour - 12 // Convert to 12-hour format
        } else {
            selectedPeriod = "AM"
            selectedHour = hour == 0 ? 12 : hour // Convert 0 to 12 for AM
        }
        selectedMinute = minute
    }

    var body: some View {
        VStack {
            HStack (spacing: -15){
                // Hour Picker
                Picker("Hour", selection: $selectedHour) {
                    ForEach(hours, id: \.self) { hour in
                        Text("\(hour)").tag(hour)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 80, height: 80) // Set a specific width for the hour picker

                // Minute Picker
                Picker("Minute", selection: $selectedMinute) {
                    ForEach(minutes, id: \.self) { minute in
                        Text(String(format: "%02d", minute)).tag(minute)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(width: 80, height: 80) // Set a specific width for the minute picker
            }
        }
        .padding()
    }
}

struct TimePickerView_Previews: PreviewProvider {
    static var previews: some View {
        TimePickerView()
    }
}
