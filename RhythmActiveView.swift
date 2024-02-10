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
                
                VStack (spacing: 30) {
                    TimerView(rhythmManager: rhythmManager)
                    
                    Text(rhythmManager.currentTask.name)
                        .font(.largeTitle.bold())
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                    
                    Button("Done") {
                        rhythmManager.elapsed = true
                        rhythmManager.next()
                    }
                    .buttonStyle(.borderedProminent)
                    
                    NavigationLink {
                        // Add Break view in here later
                        Text("Breathe with me for a minute!")
                    } label: {
                        Text("I need a break!")
                    }
                    
                    Button("Quit", role: .destructive) {
                        
                    }
                    .buttonStyle(.borderedProminent)
                    
                }
            }
            .onAppear(perform: {
                rhythmManager.next()
            })
            .navigationBarBackButtonHidden(true)
            
            // MARK: Rhythm Actions
            // Break
            // Skip
            // Mute music
        }
        
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = AppData.previewContainer
        let rhythm = AppData.rhythmExample
        container.mainContext.insert(rhythm)
        
        return RhythmActiveView(rhythm: rhythm)
            .modelContainer(container)
    }
}
