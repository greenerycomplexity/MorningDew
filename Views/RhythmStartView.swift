//  StartRhythmView.swift
//
//  MorningDew
//
//  Created by Son Cao on 19/1/2024.
//

import SwiftData
import SwiftUI

struct RhythmStartView: View {
    @State private var rhythmManager: RhythmManager
    
    init(rhythm: Rhythm) {
        rhythmManager = RhythmManager(tasks: rhythm.tasks)
    }
    
    // TODO: Use this to change background color based on RhythmState
    var backgroundColor: Color {
        switch rhythmManager.rhythmState {
        case .getReady:
            return .orange
        case .active:
            return .green
        case .meditation:
            return .blue
        }
    }
    
    var body: some View {
        switch rhythmManager.rhythmState {
        case .active:
            RhythmActiveView(rhythmManager: rhythmManager)
                .navigationBarBackButtonHidden(true)
            
        case .meditation:
            MeditationView(rhythmManager: rhythmManager)
                .navigationBarBackButtonHidden(true)
            
        default: Text("There really should be something here!")
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewData.container
        let rhythm = PreviewData.rhythmExample
        container.mainContext.insert(rhythm)
        
        return RhythmStartView(rhythm: rhythm)
            .modelContainer(container)
    }
}
