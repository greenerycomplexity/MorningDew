//  StartRhythmView.swift
//
//  MorningDew
//
//  Created by Son Cao on 19/1/2024.
//

import SwiftUI
import SwiftData

struct RhythmActiveView: View {
    @State var rhythmManager = RhythmManager()
    // Add computed property here to manage colors and such on the timerViews

    var task: TaskItem
    var body: some View {
        VStack {
            Text(task.name)
                .font(.largeTitle.bold())
                .fontDesign(.rounded)
            
//            TimerView(task: task)
            
            Spacer()
        }
    }
}


#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Rhythm.self, configurations: config)
        
        let task = TaskItem(name: "Shower", minutes: 40, perceivedDifficulty: 4, orderIndex: 1)
        
        return RhythmActiveView(task: task)
            .modelContainer(container)
    }
    
    
   
}
