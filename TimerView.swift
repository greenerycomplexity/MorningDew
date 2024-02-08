//
//  TimerView.swift
//  MorningDew
//
//  Created by Son Cao on 8/2/2024.
//

import SwiftUI

struct TimerView: View {
    var taskItem: TaskItem
    @Bindable var rhythmManager: RhythmManager
    
    var endTime: Date
    @State private var elapsed: Bool = false
    @State private var showElapsedAlert = false
    
    
    init(taskItem: TaskItem, rhythmManager: RhythmManager) {
        self.taskItem = taskItem
        self.rhythmManager = rhythmManager
        self.endTime = Date.now.addingTimeInterval(Double(taskItem.minutes) * 60)
    }
    
    let timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
//    func track() {
//        if endTime >=
//        
//        
//    }

    var body: some View {
        ZStack {
            RadialGradient(colors: [.green, .teal], center: .topLeading, startRadius: .zero, endRadius: 500)
                .ignoresSafeArea()
            
            // MARK: Display timer and task
            VStack {
                
                HStack {
                    Text("Elapsed Time:")
//                    Text(rhythmManager.startTime, style:.timer)
                }
                .foregroundStyle(.secondary)
                
                Spacer()
                
                ZStack {
                    TimerProgressRing()
                        .containerRelativeFrame(.horizontal) {width, axis in
                            width * 0.8
                        }
                    
                    VStack {
                        Text(endTime, style: .timer)
                            .font(.custom("SF Pro", size: 80, relativeTo: .largeTitle))
                            .fontDesign(.rounded)
                            .foregroundStyle(.white)
                    }
                }
                
                Text(taskItem.name)
                    .font(.title2)
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                    .padding(.top)
                
                
                // MARK: Rhythm Actions
                // Break
                // Skip
                // Mute music
                
                Spacer()
            }
            .onReceive(timer, perform: { _ in
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=code@*/ /*@END_MENU_TOKEN@*/
            })
            .alert("Timer Elapsed", isPresented: $showElapsedAlert) {
                Button("Okay") {}
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
    let task = TaskItem(name: "Shower", minutes: 40, orderIndex: 0)
    let rhythmManager = RhythmManager()
    return TimerView(taskItem: task, rhythmManager: rhythmManager)
        .modelContainer(AppData.previewContainer)
}
