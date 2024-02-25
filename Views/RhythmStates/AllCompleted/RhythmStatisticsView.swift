//
//  SwiftUIView.swift
//
//
//  Created by Son Cao on 19/2/2024.
//

import SwiftUI

extension View {
    func condensedHeading() -> some View {
        self
            .foregroundStyle(.cyan)
            .font(.title2.bold())
            .fontWidth(.condensed)
    }

    func expandedHeading() -> some View {
        self
            .foregroundStyle(.white)
            .font(.title2.bold())
            .fontWidth(.expanded)
    }
}

struct RhythmStatisticsView: View {
    @Bindable var rhythmManager: RhythmManager
    @Environment(\.dismiss) var dismiss

    @State private var showGreeting = false
    @State private var showStats = false
    @State private var showFarewell = false

    private var timeSinceStart: TimeInterval {
        rhythmManager.rhythmEndTime.timeIntervalSince(rhythmManager.rhythmStartTime)
    }

    var body: some View {
        ZStack {
            Color.offBlack.ignoresSafeArea()

            VStack {
                VStack(alignment: .leading) {
                    Spacer()
                    
                    // MARK: Greeting
                    
                    VStack(alignment: .leading) {
                        Text("Well done!")
                            .font(.largeTitle.bold())
                            .expandedHeading()
                        
                        Text("You've completed your Rhythm")
                            .foregroundStyle(.white)
                            .font(.title2.bold())
                    }
                    .padding(.bottom, 30)
                    .moveAndFade(showAnimation: showGreeting, duration: 1.5)
                    
                    // MARK: Rhythm Completion Stats

                    VStack(alignment: .leading, spacing: 25) {
                        // MARK: Rhythm Time report
                        
                        VStack(alignment: .leading) {
                            Text("Expected time:")
                                .expandedHeading()
                            
                            Text("\(rhythmManager.rhythm.totalMinutes.clean) minutes")
                                .condensedHeading()
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Actual time:")
                                .expandedHeading()
                            
                            Text(timeSinceStart.detailed)
                                .condensedHeading()
                        }
                        
                        // MARK: Meditation report
                        
                        VStack(alignment: .leading) {
                            Text("Breathing sessions taken:")
                                .expandedHeading()
                            
                            Text("^[\(rhythmManager.meditationOpened) time](inflect:true)")
                                .condensedHeading()
                        }
                        
                        if rhythmManager.meditationOpened > 0 {
                            VStack(alignment: .leading) {
                                Text("Time in breathing mode:")
                                    .expandedHeading()
                                
                                Text(rhythmManager.elapsedMeditationTotal.detailed)
                                    .condensedHeading()
                            }
                        }
                    }
                    .moveAndFade(showAnimation: showStats, duration: 1.5)
                    Spacer()
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Text("Now go and have a productive day!")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .moveAndFade(showAnimation: showFarewell)
                        
                        Button("Done") {
                            dismiss()
                        }
                        .buttonStyle(GradientButton(gradient: .buttonGradient))
                    }
                }
            }
            .onAppear {
                SoundPlayer().play(file: "allCompleted.wav")
                showGreeting = true
                
                delay(seconds: 2.0) {
                    showStats = true
                }
                
                delay(seconds: 5.0) {
                    showFarewell = true
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
