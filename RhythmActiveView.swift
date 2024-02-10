//  StartRhythmView.swift
//
//  MorningDew
//
//  Created by Son Cao on 19/1/2024.
//

import SwiftUI
import SwiftData

struct RhythmActiveView: View {
    var rhythm: Rhythm
    @State private var rhythmManager: RhythmManager
    
    init(rhythm: Rhythm) {
        self.rhythm = rhythm
        rhythmManager = RhythmManager(tasks: rhythm.tasks)
    }
    
    // Add computed property here to manage colors and such on the timerViews
    var body: some View {
        if rhythmManager.allCompleted {
            Text("You're all done!")
        } else {
            ZStack {
                RadialGradient(colors: [.yellow, .teal], center: .topLeading, startRadius: .zero, endRadius: 500)
                    .ignoresSafeArea()
                
                VStack {
                    TimerView(rhythmManager: rhythmManager)
                    
                    Text(rhythmManager.currentTask.name)
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
                }
            }
            .onAppear(perform: {
                rhythmManager.next()
            })
            
            // MARK: Rhythm Actions
            // Break
            // Skip
            // Mute music
        }
    }
}

#Preview {
    var rhythm = Rhythm(name: "Morning Fun")
    
    rhythm.tasks.append(TaskItem(name: "Shower", minutes: 1, orderIndex: 1))
    
    return RhythmActiveView(rhythm: rhythm)
        .modelContainer(AppData.previewContainer)
}
