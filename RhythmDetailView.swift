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
    @Bindable var currentRhythm: Rhythm
    
    var body: some View {
        VStack {
            // Rhythm length (in minutes)
            // Button to add new tasks
            HStack {
                VStack (alignment: .leading) {
                    Text("Time to complete")
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
                ForEach(currentRhythm.tasks.sorted(by: {
                    $0.orderIndex < $1.orderIndex
                }), id: \.self) { task in
                    HStack {
                        VStack (alignment: .leading) {
                            Text(task.name)
                                .font(.title3.bold())
                                .fontDesign(.default)
                                .foregroundStyle(.primary)
                            
                            Text("\(task.minutes) minutes")
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
                .onMove(perform: { source, destination in
                    for taskIndex in source {
                        let moveTask = currentRhythm.tasks[taskIndex]
                        
                        currentRhythm.tasks.remove(at: taskIndex)
                        
                        currentRhythm.tasks.insert(moveTask, at: destination)
                    }
                })
            }
            .listStyle(.plain)
            
            
            if currentRhythm.tasks.count > 0 {
                // Start the routine
                NavigationLink {
                    RhythmActiveView(rhythm: currentRhythm)
                } label: {
                    Image(systemName: "play.circle.fill")
                        .foregroundStyle(.green)
                        .font(.system(size: 80))
                }
            }
           
        }
        .navigationTitle(currentRhythm.name)
        .navigationBarTitleDisplayMode(.inline)
        .padding()
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
