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
        rhythmManager = RhythmManager(rhythm: rhythm)
    }
    
    var body: some View {
        switch rhythmManager.currentState {
        case .active:
            RhythmActiveView(rhythmManager: rhythmManager)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    MusicPlayer().play(file: "electro.wav", volume: 0.1)
                    musicPlayer?.setVolume(1.0, fadeDuration: 4)
                }
            
        case .meditation:
            MeditationView(rhythmManager: rhythmManager)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    MusicPlayer().play(file: "forest.wav", volume: 0.2)
                }
            
        case .checkup:
            RhythmCheckupView(rhythmManager: rhythmManager)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    musicPlayer?.setVolume(0.0, fadeDuration: 3)
                    delay(seconds: 3) {
                        musicPlayer?.stop()
                    }
                }
            
        case .allCompleted:
            RhythmStatisticsView(rhythmManager: rhythmManager)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    musicPlayer?.stop()
                }
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
