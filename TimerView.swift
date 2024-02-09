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
    private var taskEndTime: Date
    
    init(rhythmManager: RhythmManager) {
        self.rhythmManager = rhythmManager
        self.currentTask = rhythmManager.currentTask
        self.taskEndTime =  Date.now.addingTimeInterval(Double(currentTask.minutes) * 60 + 1)
    }
    
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    
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
                    TimerProgressRing()
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
    @State private var progress = 0.0
    
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
                .animation(.easeInOut(duration: 1.0), value: progress)
        }
        .onAppear(perform: {
            progress = 0.9
        })
    }
}

#Preview {
    let rhythm = Rhythm(name: "Morning Day")
    let rhythmManager = RhythmManager(tasks: rhythm.tasks)
    return TimerView(rhythmManager: rhythmManager)
        .modelContainer(AppData.previewContainer)
}
