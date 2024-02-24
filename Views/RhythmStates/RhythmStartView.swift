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
    
    // TODO: Use this to change background color based on RhythmState
    // var backgroundColor: Color {
    //     switch rhythmManager.currentState {
    //     case .getReady:
    //         return .orange
    //     case .active:
    //         return .green
    //     case .meditation:
    //         return .blue
    //     }
    // }
    // 
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
            
        case .allCompleted:
            RhythmStatisticsView(rhythmManager: rhythmManager)
                .onAppear {
                    musicPlayer?.stop()
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
