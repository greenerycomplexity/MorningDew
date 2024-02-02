//
//  AddbeatView.swift
//  MorningDew
//
//  Created by Son Cao on 17/1/2024.
//

import SwiftUI
import SwiftData

struct AddBeatView: View {
    @State private var name = ""
    @State private var minutes = 5
    @State private var perceivedDifficulty = 3
    
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
            .navigationTitle("Add New beat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                
                ToolbarItem (placement: .confirmationAction) {
                    Button("Save") {
                        // Fetch the number of all items that contribute to the relative index ordering
                        // Add filtering for which beats belong to current routine here
                        let descriptor = FetchDescriptor<Beat>()
                        let count = (try? modelContext.fetchCount(descriptor)) ?? 0
                        
                        // Pass the next index to the new item
                        let newbeat = Beat(name: name, time: minutes, perceivedDifficulty: perceivedDifficulty, orderIndex: count)
                        modelContext.insert(newbeat)
                        dismiss()
                    }
                }
            }
        }
    }
}
#Preview {
    AddBeatView()
}
