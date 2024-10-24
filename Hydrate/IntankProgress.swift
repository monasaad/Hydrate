//
//  IntankProgress.swift
//  Hydrate
//
//  Created by Mona on 15/04/1446 AH.
//

import SwiftUI

struct IntankProgress: View {
    @State private var progress: CGFloat = 0.001
    @State private var goal: CGFloat = 0.0
    let symbolNames = ["zzz", "tortoise.fill", "hare.fill", "hands.clap.fill"]
    let defaults = UserDefaults.standard

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Today's Water Intake")
                    .foregroundColor(.gray)

                HStack {
                    Text("\(String(format: "%.1f", progress)) liter")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(progress == goal ? .green : .black)

                    Text("/ \(String(format: "%.1f", goal)) liter")
                        .font(.title2)
                        .fontWeight(.semibold)
                }

                Spacer()

                ZStack {
                    Circle()
                        .stroke(
                            style: StrokeStyle(lineWidth: 33, lineCap: .round)
                        )
                        .fill(.greyLight)

                    Circle()
                        .trim(
                            from: 0,
                            to: goal > 0 ? min(progress / goal, 1.0) : 0
                        )
                        .stroke(
                            style: StrokeStyle(lineWidth: 33, lineCap: .round)
                        )
                        .fill(.cyanDark)
                        .rotationEffect(.degrees(-90))

                    Image(
                        systemName: symbolNames[
                            min(
                                Int(
                                    (progress / max(goal, 1.0))
                                        * CGFloat(symbolNames.count)),
                                symbolNames.count - 1
                            )
                        ]
                    )
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90)
                    .foregroundColor(.yellow)
                }
                .padding(30)

                Spacer()

                VStack {
                    Text("\(String(format: "%.1f", progress)) L")
                        .font(.title2)
                        .fontWeight(.semibold)

                    Stepper(
                        "Add Water", value: $progress, in: 0...max(goal, 1.0),
                        step: 0.1
                    )
                    .labelsHidden()
                    .onChange(of: progress) {

                        print(
                            "t: \(CGFloat(round(10 * progress) / 10)), Goal: \(goal)"
                        )
                    }
                }.frame(maxWidth: .infinity, alignment: .center)
                Spacer()
            }
            .padding()
            .onAppear {
                goal = CGFloat(defaults.double(forKey: "waterIntake"))
                goal = goal > 0 ? CGFloat(round(10 * goal) / 10) : 1.0
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    IntankProgress()
}
