//
//  SwiftUIView.swift
//
//
//  Created by Son Cao on 18/2/2024.
//

import SwiftUI

struct LotusTempSettingView: View {
    @State private var numberOfPetals: Double = 5
    @State private var isMinimized = false
    @State private var animationDuration = 0.5
    @State private var breatheDuration = 4.2

    var body: some View {
        List {
            // Flower
            Section {
                LotusView(isMinimized: $isMinimized,
                          numberOfPetals: $numberOfPetals,
                          duration: $animationDuration)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
            }

            // Number of Petals
            Section(header: Text("Number of Petals: \(Int(numberOfPetals))")) {
                Slider(value: $numberOfPetals, in: 1...10) { onEditingChanged in
                    // Detect when interaction with the slider is done, then snap to the closest petal
                    if !onEditingChanged {
                        self.numberOfPetals = self.numberOfPetals.rounded()
                    }
                }
            }

            // Breathing Duration
            Section(header: Text("Breathing Duration: \(animationDuration.formatted()) seconds")) {
                Slider(value: $animationDuration, in: 0...10, step: 0.1)
            }

            // Breathe Button
            Button {
                self.isMinimized.toggle()

                DispatchQueue.main.asyncAfter(deadline: .now() + self.animationDuration) {
                    self.isMinimized.toggle()
                }
            } label: {
                Text("Breathe")
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    LotusTempSettingView()
}
