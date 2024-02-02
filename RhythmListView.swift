//
//  RhythmView.swift
//  MorningDew
//
//  Created by Son Cao on 23/1/2024.
//

import SwiftUI

struct RhythmListView: View {
    @Environment (\.modelContext) var modelContext
    var rhythm: Rhythm
    
    var body: some View {
        VStack {
            //                Show the tasks here
            List {
                ForEach(rhythm.tasks, id: \.name) { task in
                    HStack {
                        VStack (alignment: .leading) {
                            Text(task.name)
                                .font(.title3.bold())
                                .fontDesign(.default)
                                .foregroundStyle(.primary)
                            
                            Text("\(task.time) minutes")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: { indexSet in
                    for taskIndex in indexSet {
                        let task = rhythm.tasks[taskIndex]
                        modelContext.delete(task)
                    }
                })
                .onMove(perform: { source, destination in
                    var updatedTasksList = rhythm.tasks
                    
                    updatedTasksList.move(fromOffsets: source, toOffset: destination)
                    for (index, task) in updatedTasksList.enumerated() {
                        task.orderIndex = index
                    }
                })
                
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    RhythmListView(rhythm: Rhythm(name: "Shower"))
        .modelContainer(for: Rhythm.self)
}
