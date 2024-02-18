//
//  SwiftUIView.swift
//
//
//  Created by Son Cao on 17/2/2024.
//

import SwiftUI

struct LotusView: View {
    @Binding var isMinimized: Bool
    @Binding var numberOfPetals: Double
    @Binding var duration: Double

    // Diameter of each lotus image
    let diameter: CGFloat = 150

    // The rotation angle needed for each petal, so they don't all overlap as one
    private var absoluteAngle: Double {
        return 360/numberOfPetals
    }

    // Opacity percentage for the petal during adding/removing
    // Avoid petals snapping in and out by having one always ready
    private var opacityPercentage: Double {
        let n = numberOfPetals.rounded(.down)
        let nextAngle = 360/(n + 1)
        let currentAngle = 360/n

        let progress = absoluteAngle - nextAngle
        let total = currentAngle - nextAngle

        return 1 - (progress/total)
    }

    let pinkGradient = LinearGradient(gradient: Gradient(colors: [
        Color(red: 254/255, green: 0/255, blue: 100/255),
        .white
    ]), startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        ZStack {
            ForEach(0 ... Int(numberOfPetals), id: \.self) { petal in
                Circle()
                    .foregroundStyle(pinkGradient)
                    .frame(width: diameter, height: diameter)

                    // If petal is being added/removed, use this opacity
                    .opacity(petal == Int(self.numberOfPetals) ? self.opacityPercentage : 0.5)

                    // Rotate each new flower using its leading anchor, instead of its center
                    .rotationEffect(
                        .degrees(self.absoluteAngle * Double(petal)),
                        anchor: isMinimized ? .center : .leading)
            }
        }
        .frame(width: diameter * 2, height: diameter * 2)
        .animation(.easeInOut(duration: duration), value: numberOfPetals)

        // Center the view along the center of the flower
        .offset(x: isMinimized ? 0 : diameter/2)
        .rotationEffect(.degrees(isMinimized ? -90 : 0))
        .scaleEffect(isMinimized ? 0.3 : 1)
        .animation(.easeInOut(duration: duration).repeatForever(), value: isMinimized)

        // Rotation so that first petal shows up at the top
        .rotationEffect(.degrees(-90))
    }
}

#Preview {
    LotusView(
        isMinimized: .constant(false),
        numberOfPetals: .constant(5),
        duration: .constant(4.2))
}
