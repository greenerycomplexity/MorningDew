//  StartRoutineView.swift
//
//  MorningDew
//
//  Created by Son Cao on 19/1/2024.
//

import SwiftData
import SwiftUI

struct RoutineActiveView: View {
    @Bindable var routineManager: RoutineManager
    
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
    
    @State private var showMeditationAlert = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.teal, .green], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                
            VStack(spacing: 30) {
                Spacer()
                
                // MARK: Timer

                TimerView(routineManager: routineManager)
                    
                // Current task name
                Text(routineManager.currentTask.name)
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    
                Spacer()
                
                // MARK: Encouragement text

                Text(encouragement)
                    .foregroundStyle(.white)
                    .font(.title3.bold())
                    .fontWeight(.semibold)
                    .fontDesign(.rounded)
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
                        showMeditationAlert = true
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
                            SoundPlayer().play(file: "taskFinished.wav")
                            routineManager.nextTask()
                            generateEncouragement()
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
                    .alert("Start Meditation?", isPresented: $showMeditationAlert) {
                        Button("Confirm") {
                            withAnimation {
                                routineManager.currentState = .meditation
                            }
                        }
                        
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        // Number is rounded to the nearest 5 for clean look
                        Text("Breathe for \(routineManager.meditationLength.roundTo(nearest: 5.0).clean) seconds. This Task will be restarted when you come back.")
                    }
                }
                Spacer()
            }
        }
        .transition(.opacity)
        .onAppear {
            if routineManager.currentTask == PreviewData.taskItemExample {
                routineManager.nextTask()
            }
        }
        .onReceive(routineManager.timer, perform: { _ in
            routineManager.trackTask()
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
        let routine = PreviewData.routineExample
        container.mainContext.insert(routine)
        
        return RoutineActiveView(routineManager: RoutineManager(routine: routine))
            .modelContainer(container)
    }
}
