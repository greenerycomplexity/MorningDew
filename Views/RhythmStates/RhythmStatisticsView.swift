//
//  SwiftUIView.swift
//
//
//  Created by Son Cao on 19/2/2024.
//

import SwiftUI

struct RhythmStatisticsView: View {
    @Bindable var rhythmManager: RhythmManager

    private var timeSinceStart: TimeInterval {
        rhythmManager.rhythmEndTime.timeIntervalSince(rhythmManager.rhythmStartTime)
    }

    var body: some View {
        ZStack {
            Color.offBlack.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 15) {
                
                // MARK: Greeting
                Text("Well done, you've completed your morning routine!")
                    .foregroundStyle(.white)

                Text("Here's how you did")
                    .foregroundStyle(.white)

                // MARK: Rhythm Time report
                Text("Expected time: \(rhythmManager.rhythm.totalMinutes.clean) minutes")
                    .foregroundStyle(.white)

                Text("Actual time:")
                    .foregroundStyle(.white)

                Text(timeSinceStart.detailed)
                    .foregroundStyle(.white)

                // MARK: Meditation report
                Text("You took \(rhythmManager.meditationOpened) breathing sessions")
                    .foregroundStyle(.white)

                if rhythmManager.meditationOpened > 0 {
                    Text(rhythmManager.elapsedMeditationTotal.detailed)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewData.container
        let rhythm = PreviewData.rhythmExample
        container.mainContext.insert(rhythm)

        return RhythmStatisticsView(rhythmManager: RhythmManager(rhythm: rhythm))
            .modelContainer(container)
    }
}
