import SwiftUI

struct TimePickerView: View {
    @State private var selectedValue = 1  // Store the selected value
    @State private var showingPicker = false  // Control the half sheet presentation

    var body: some View {
        VStack {
            Button("Select Time") {
                showingPicker.toggle()  // Show the half sheet when button is pressed
            }
            .padding()
        }
        .sheet(isPresented: $showingPicker) {
            VStack {
                Text("Select an Option")
                    .font(.headline)
                    .padding()

                Picker(selection: $selectedValue, label: Text("Picker")) {
                    Text("1").tag(1)
                    Text("2").tag(2)
                }
                .pickerStyle(WheelPickerStyle())  // You can change the style if needed
                .padding()

                Button("Done") {
                    showingPicker = false  // Dismiss the half sheet
                }
                .padding()
            }.presentationDetents([.medium])
            .padding()
        }// Adjust the sheet height to medium
    }
}

#Preview {
    TimePickerView()
}
