//
//  TimerView.swift
//  MorningDew
//
//  Created by Son Cao on 8/2/2024.
//

import SwiftUI

// FIXME: Currently not counting down timer when used in RhythmActiveView
struct TimerView: View {
    var currentTask: TaskItem
    private var taskEndTime: Date
    @State private var elapsedSeconds = 0.0
    @State private var progress = 0.0
    @Binding var elapsed: Bool
    
    init(task: TaskItem, elapsed: Binding<Bool>) {
        currentTask = task
        _elapsed = elapsed
        taskEndTime = Date.now.addingTimeInterval(Double(currentTask.minutes) * 60 + 1)
    }
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    // For every new task that comes in, reset the progress ring
    mutating func resetProgressRing() {
        elapsedSeconds = 0.0
        progress = 0.0
    }
    
    var body: some View {
        ZStack {
            // MARK: Display timer and task
            ZStack {
                TimerProgressRing(progress: $progress)
                    .containerRelativeFrame(.horizontal) {width, axis in
                        width * 0.8
                    }
                
                VStack {
                    Text(taskEndTime, style: .timer)
                        .font(.custom("SF Pro", size: 80, relativeTo: .largeTitle))
                        .fontDesign(.rounded)
                        .foregroundStyle(.primary)
                }
            }
            .onReceive(timer, perform: { _ in
                // If current time is later than endTime
                if Date.now >= taskEndTime {
                    elapsed = true
                } else {
                    elapsed = false
                    elapsedSeconds += 1
                    progress = elapsedSeconds / currentTask.seconds
                }
            })
        }
    }
}


struct TimerProgressRing: View {
    @Binding var progress: Double
    
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
    let task = TaskItem(name: "Shower", minutes: 1, perceivedDifficulty: 4, orderIndex: 1)
    
    return TimerView(task: task, elapsed: .constant(false))
        .modelContainer(AppData.previewContainer)
}
