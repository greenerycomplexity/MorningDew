//
//  AddRhythmView.swift
//  MorningDew
//
//  Created by Son Cao on 23/1/2024.
//

import SwiftUI
import SwiftData

struct AddRhythmView: View {
    @Environment (\.modelContext) var modelContext
    @Environment (\.dismiss) var dismiss
    @State private var name = ""
    
    @State private var showDuplicateNameAlert = false
    let addRhythmFailed = "Failed to save"
    let rhythmFailedMessage = "Existing Rhythm names cannot be reused. Please try again."
    
    var body: some View {
        NavigationStack {
            Form {
                TextField ("Add new rhythm", text: $name)
                
                Section {
                    Button ("Save") {
                        let descriptor = FetchDescriptor<Rhythm>(
                            predicate: #Predicate { rhythm in
                                rhythm.name == name
                            }
                        )
                        
                        let count = (try? modelContext.fetchCount(descriptor)) ?? 0
                        if count > 0 {
                            showDuplicateNameAlert = true
                        } else {
                            let newRhythm = Rhythm(name: name)
                            modelContext.insert(newRhythm)
                            dismiss()
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            
            
            
            .alert(addRhythmFailed, isPresented: $showDuplicateNameAlert) {
                Button("Okay") {}
            } message: {
                Text(rhythmFailedMessage)
            }
            
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Rhythm.self, configurations: config)
        
        let rhythm = Rhythm(name: "Morning Routine")
        
        return AddRhythmView()
            .modelContainer(container)
    }
}
