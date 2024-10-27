//
//  OnboardingBodyWeight.swift
//  Hydrate
//
//  Created by Mona on 15/04/1446 AH.
//

import Combine
import SwiftUI

struct OnboardingBodyWeight: View {
    @State private var inputText: String = ""
    @State var waterIntake: CGFloat = 0.0
    @State private var showAlert: Bool = false
    let defaults = UserDefaults.standard  // 1

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Spacer()

                Image(systemName: "drop.fill").resizable().scaledToFit()
                    .foregroundColor(.cyanDark).frame(width: 50, height: 50)
                Text("Hydrate")
                    .font(.title)
                    .fontWeight(.semibold)
                Text(
                    "Start with Hydrate to record and track your water intake daily based on your needs and stay hydrated"
                ).foregroundColor(.greyDark)
                    .font(.system(size: 18))
                    .padding(.vertical, 10)

                HStack {
                    Text("Body weight").padding()
                    TextField("Value", text: $inputText)
                        .keyboardType(.decimalPad)  //TODO: take this value
                        .onReceive(Just(inputText)) { newValue in
                            // Filter to allow only numbers and one decimal point
                            let filtered = newValue.filter {
                                "0123456789.".contains($0)
                            }
                            if filtered != newValue {
                                inputText = filtered
                            }
                        }

                    if !inputText.isEmpty {
                        Button(action: {
                            inputText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                        }.padding(.trailing, 10)
                    }
                }.frame(maxWidth: .infinity)
                    .background(.greyLight)

                Spacer()

                // --------------------------------------------------------------

                NavigationLink(
                    destination:
                        //IntankProgress()
                        OnboardingNotification()
                ) {
                    Text("Calculate Now")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(.cyanDark)
                        .cornerRadius(10)
                }.simultaneousGesture(
                    TapGesture().onEnded {

                        if let value = Double(inputText) {
                            showAlert = false
                            waterIntake = CGFloat(value * 0.03)

                            defaults.set(waterIntake, forKey: "waterIntake")  //2. set
                            print("Water Intake set to: \(waterIntake)")

                        } else {
                            showAlert = true 
                        }
                    }
                ).alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Body weight is empty"),
                        message: Text("Please write your body weight"),
                        dismissButton: .default(Text("OK")))
                }

            }.padding()
        }
    }
}

#Preview {
    OnboardingBodyWeight()
}
