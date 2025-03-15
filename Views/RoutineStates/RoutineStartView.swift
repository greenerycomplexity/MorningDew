//  StartRoutineView.swift
//
//  MorningDew
//
//  Created by Son Cao on 19/1/2024.
//

import SwiftData
import SwiftUI

struct RoutineStartView: View {
    @State private var routineManager: RoutineManager
    
    init(routine: Routine) {
        routineManager = RoutineManager(routine: routine)
    }
    
    var body: some View {
        switch routineManager.currentState {
        case .active:
            RoutineActiveView(routineManager: routineManager)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    MusicPlayer().play(file: "electro.wav", volume: 0.1)
                    musicPlayer?.setVolume(1.0, fadeDuration: 4)
                }
            
        case .meditation:
            MeditationView(routineManager: routineManager)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    MusicPlayer().play(file: "forest.wav", volume: 0.2)
                }
            
        case .checkup:
            RoutineCheckupView(routineManager: routineManager)
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    musicPlayer?.setVolume(0.0, fadeDuration: 3)
                    delay(seconds: 3) {
                        musicPlayer?.stop()
                    }
                }
            
        case .allCompleted:
            RoutineStatisticsView(routineManager: routineManager)
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
        let routine = PreviewData.routineExample
        container.mainContext.insert(routine)
        
        return RoutineStartView(routine: routine)
            .modelContainer(container)
    }
}
