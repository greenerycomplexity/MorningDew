//  StartRhythmView.swift
//
//  MorningDew
//
//  Created by Son Cao on 19/1/2024.
//

import SwiftData
import SwiftUI

struct RhythmActiveView: View {
    @Bindable var rhythmManager: RhythmManager
    
    @State private var soundMuted: Bool = false {
        didSet {
            if soundMuted {
                musicPlayer?.volume = 0.0
            } else {
                musicPlayer?.volume = 1.0
            }
        }
    }

    @State private var showEncouragement = false
    @State private var encouragement = "Well done!"
    
    @State private var showNextTaskAlert = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.teal, .green], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                
            VStack(spacing: 30) {
                Spacer()
                
                // MARK: Timer

                TimerView(rhythmManager: rhythmManager)
                    
                // Current task name
                Text(rhythmManager.currentTask.name)
                    .font(.largeTitle.bold())
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    
                Spacer()
                
                // MARK: Encouragement text

                Text(encouragement)
                    .foregroundStyle(.white)
                    .font(.headline)
                    .moveAndFade(showAnimation: showEncouragement)

                // MARK: Control buttons

                HStack(alignment: .bottom, spacing: 30) {
                    // MARK: Mute Toggle

                    VStack {
                        Button {
                            soundMuted.toggle()
                        } label: {
                            Image(systemName: "speaker.slash")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundStyle(soundMuted ? .red : .white)
                                .padding(15)
                                .background(soundMuted ? .white : .white.opacity(0.4))
                                .clipShape(Circle())
                        }
                        Text("Mute")
                            .foregroundStyle(.white)
                            .font(.headline)
                    }
                     
                    // MARK: Start Meditation

                    Button {
                        withAnimation {
                            rhythmManager.currentState = .meditation
                        }
                    } label: {
                        VStack {
                            Image(.lotus)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60)
                                .padding()
                                .background(.black.opacity(0.7).gradient)
                                .clipShape(Circle())
                                
                            Text("Breathe")
                                .foregroundStyle(.white)
                                .font(.headline)
                        }
                    }
                        
                    // MARK: Change to next task

                    VStack {
                        Button {
                            showNextTaskAlert = true
                        } label: {
                            Image(systemName: "checkmark.gobackward")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
                                .frame(width: 30, height: 30)
                                .padding(15)
                                .background(.white.opacity(0.4))
                                .clipShape(Circle())
                        }
                            
                        Text("Next")
                            .foregroundStyle(.white)
                            .font(.headline)
                    }
                    .alert("Move to next Task?", isPresented: $showNextTaskAlert) {
                        Button("Confirm") {
                            SoundPlayer().play(file: "taskFinished.wav")
                            rhythmManager.nextTask()
                            generateEncouragement()
                        }
                        
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("You won't be able to go back")
                    }
                }
                Spacer()
            }
        }
        .transition(.opacity)
        .onAppear {
            if rhythmManager.currentTask == PreviewData.taskItemExample {
                rhythmManager.nextTask()
            }
        }
        .onReceive(rhythmManager.timer, perform: { _ in
            rhythmManager.trackTask()
        })
    }
    
    private func generateEncouragement() {
        let encouragements = ["Keep it up!", "Awesome job!", "Amazing job!", "You're doing great!", "Way to go!", "Great work!"]
        
        // Make sure it's not the same as the last one
        let temp = encouragement
        while encouragement == temp {
            encouragement = encouragements.randomElement()!
        }

        delay(seconds: 0.25) {
            showEncouragement = true
            delay(seconds: 2.0) {
                showEncouragement = false
            }
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewData.container
        let rhythm = PreviewData.rhythmExample
        container.mainContext.insert(rhythm)
        
        return RhythmActiveView(rhythmManager: RhythmManager(tasks: rhythm.tasks))
            .modelContainer(container)
    }
}
