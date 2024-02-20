//
//  AddtaskView.swift
//  MorningDew
//
//  Created by Son Cao on 17/1/2024.
//

import SwiftUI
import SwiftData

struct AddTaskView: View {
    @State private var name = ""
    @State private var minutes = 5
    @State private var perceivedDifficulty = 3
    @Bindable var currentRhythm: Rhythm
    
    @Environment (\.dismiss) var dismiss
    @Environment (\.modelContext) var modelContext
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                
                Section ("Time to complete"){
                    Text ("\(minutes) minutes")
                    
                    Picker("Time to complete", selection: $minutes) {
                        ForEach(1...60, id: \.self) { minute in
                            Text("\(minute)")
                        }
                    }
                    .pickerStyle(.wheel)
                }
                
                Section ("Perceived difficulty") {
                    HStack {
                        StarRatingView(rating: $perceivedDifficulty)
                    }
                }
                
                
                
            }
            .navigationTitle("Add New Task")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem (placement: .confirmationAction) {
                    Button("Save") {
                        let rhythmName = currentRhythm.name
                        
                        /// Ordering feature is archived for now
                        // // Fetch all tasks that belong to the same rhythm, for ordering purposes
                        // let descriptor = FetchDescriptor<TaskItem>(
                        //     predicate: #Predicate { taskItem in
                        //         taskItem.rhythm?.name == rhythmName
                        //     }
                        // )
                        // 
                        // // And get new index variable
                        // let count = (try? modelContext.fetchCount(descriptor)) ?? 0
                        
                        let newTask = TaskItem(name: name, minutes: Double(minutes), perceivedDifficulty: perceivedDifficulty, rhythm: currentRhythm)
                        
                        currentRhythm.tasks.append(newTask)
                        dismiss()
                    }
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
        
        return AddTaskView(currentRhythm: rhythm)
            .modelContainer(container)
    }
    
    
}
