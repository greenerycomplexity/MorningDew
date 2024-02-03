//
//  RhythmView.swift
//  MorningDew
//
//  Created by Son Cao on 23/1/2024.
//

import SwiftUI
import SwiftData

struct RhythmDetailView: View {
    @Environment (\.modelContext) var modelContext
    @State private var showAddTaskView = false
    var currentRhythm: Rhythm
    
    var body: some View {
        VStack {
            // Rhythm length (in minutes)
            // Button to add new tasks
            HStack {
                VStack (alignment: .leading) {
                    Text("Total")
                        .font(.title3.bold())
                        .fontDesign(.rounded)
                    
                    
                    Text("\(currentRhythm.totalMinutes) minutes")
                        .font(.largeTitle.bold())
                        .fontDesign(.rounded)
                    
                }
                
                Spacer()
                
                Button {
                    showAddTaskView = true
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.green)
                }
            }
            
            // Display the tasks in list view
            
            List {
                ForEach(currentRhythm.tasks, id: \.name) { task in
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
                        let task = currentRhythm.tasks[taskIndex]
                        modelContext.delete(task)
                    }
                })
                //                .onMove(perform: { source, destination in
                //                    var updatedTasksList = currentRhythm.tasks
                //
                //                    updatedTasksList.move(fromOffsets: source, toOffset: destination)
                //                    for (index, task) in updatedTasksList.enumerated() {
                //                        task.orderIndex = index
                //                    }
                //                })
                
            }
            .listStyle(.plain)
            
            // Start the routine
            NavigationLink {
                Text("Hello")
            } label: {
                Image(systemName: "play.circle.fill")
                    .foregroundStyle(.green)
                    .font(.system(size: 80))
            }
        }
        .navigationTitle(currentRhythm.name)
        .navigationBarTitleDisplayMode(.inline)
        .padding(.vertical)
        .padding(.horizontal)
        .sheet(isPresented: $showAddTaskView) {
            AddTaskView(currentRhythm: currentRhythm)
        }
        .toolbar {
            if currentRhythm.tasks.count > 0 {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Rhythm.self, configurations: config)
        
        let rhythm = Rhythm(name: "Morning Routine")
        
        return RhythmDetailView(currentRhythm: rhythm)
            .modelContainer(container)
    }
    
    
}
