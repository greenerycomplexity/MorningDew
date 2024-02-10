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
                RadialGradient(colors: [.green, .teal], center: .topLeading, startRadius: .zero, endRadius: 500)
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
    let rhythm = Rhythm(name: "Morning Day")
    
    let tasks = [
        TaskItem(name: "Shower", minutes: 10, perceivedDifficulty: 4, orderIndex: 1),
        TaskItem(name: "Breakfast", minutes: 20, perceivedDifficulty: 2, orderIndex: 2),
        TaskItem(name: "Water plants", minutes: 5, perceivedDifficulty: 4, orderIndex: 3),
        TaskItem(name: "Pick outfit", minutes: 4, perceivedDifficulty: 5, orderIndex: 4)
    ]
    
    rhythm.tasks.append(contentsOf: tasks)
    
    return RhythmActiveView(rhythm: rhythm)
        .modelContainer(AppData.previewContainer)
   
}
