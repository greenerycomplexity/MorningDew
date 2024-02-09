//
//  TimerView.swift
//  MorningDew
//
//  Created by Son Cao on 8/2/2024.
//

import SwiftUI

struct TimerView: View {
    @Bindable var rhythmManager: RhythmManager
    @State private var showElapsedAlert = false
    
    private var currentTask: TaskItem
    private var taskEndTime: Date {
        Date.now.addingTimeInterval(Double(currentTask.minutes) * 60 + 1)
    }
    
    init(rhythmManager: RhythmManager) {
        self.rhythmManager = rhythmManager
        self.currentTask = rhythmManager.currentTask
        totalTaskSeconds = Double(currentTask.minutes) * 60
    }
    
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    private var totalTaskSeconds: Double
    @State private var taskElapsedSeconds = 0.0
    @State private var progress = 0.0
    
    func resetProgress() {
        taskElapsedSeconds = 0.0
        progress = 0.0
    }
    
    var body: some View {
        ZStack {
            RadialGradient(colors: [.green, .teal], center: .topLeading, startRadius: .zero, endRadius: 500)
                .ignoresSafeArea()
            
            // MARK: Display timer and task
            VStack {
                
//                HStack {
//                    Text("Elapsed Time:")
//                    Text(rhythmManager.startTime, style:.timer)
//                }
//                .foregroundStyle(.secondary)
                
                Spacer()
                
                ZStack {
                    TimerProgressRing(progress: $progress)
                        .containerRelativeFrame(.horizontal) {width, axis in
                            width * 0.8
                        }
                    
                    VStack {
                        Text(taskEndTime, style: .timer)
                            .font(.custom("SF Pro", size: 80, relativeTo: .largeTitle))
                            .fontDesign(.rounded)
                            .foregroundStyle(.white)
                    }
                }
                
                Text(currentTask.name)
                    .font(.title2)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .padding(.top)
                
                
                
                Button("Next Task") {
                    rhythmManager.elapsed = true
                    resetProgress()
                    rhythmManager.next()
                    
                }
                .buttonStyle(.borderedProminent)
                .padding(.top)
                
                
                // MARK: Rhythm Actions
                // Break
                // Skip
                // Mute music
                
                Spacer()
            }
            .onReceive(timer, perform: { _ in
                // If current time is later than endTime
                if Date.now >= taskEndTime {
                    rhythmManager.elapsed = true
                    showElapsedAlert = true
                } else {
                    rhythmManager.elapsed = false
                    taskElapsedSeconds += 1
                    progress = taskElapsedSeconds / totalTaskSeconds
                    print("Current progress: ", progress)
                }
            })
            .alert("Timer Elapsed", isPresented: $showElapsedAlert) {
                Button("Next Task") {
                    rhythmManager.next()
                }
            }
        }
    }
}


struct TimerProgressRing: View {
    @Binding var progress: Double
    
    // MARK: Progress Ring
    let ringColor = Color.white.opacity(0.9)
    let width: Double = 10
    
    var body: some View {
        ZStack {
            // Placeholder Ring
            Circle()
                .stroke (lineWidth: width)
                .foregroundColor(.black.opacity(0.8))
                .opacity (0.1)
            
            // Colored Ring
            Circle()
                .trim(from: 0.0, to: min(progress, 1.0))
                .stroke(ringColor,style: StrokeStyle( lineWidth: width, lineCap: .round, lineJoin: .round))
                .rotationEffect(.degrees(270))
                .animation(.easeInOut(duration: 2.0), value: progress)
        }
    }
}

#Preview {
    let rhythm = Rhythm(name: "Spring Day")
    let tasks = [
        TaskItem(name: "Shower", minutes: 10, perceivedDifficulty: 4, orderIndex: 1),
        TaskItem(name: "Breakfast", minutes: 20, perceivedDifficulty: 2, orderIndex: 2),
        TaskItem(name: "Water plants", minutes: 5, perceivedDifficulty: 4, orderIndex: 3),
        TaskItem(name: "Pick outfit", minutes: 4, perceivedDifficulty: 5, orderIndex: 4)
    ]
    
    rhythm.tasks.append(contentsOf: tasks)
    
    let rhythmManager = RhythmManager(tasks: rhythm.tasks)
    return TimerView(rhythmManager: rhythmManager)
        .modelContainer(AppData.previewContainer)
}
