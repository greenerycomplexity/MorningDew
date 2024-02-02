//
//  RhythmView.swift
//  MorningDew
//
//  Created by Son Cao on 23/1/2024.
//

import SwiftUI

struct RhythmView: View {
    @Environment (\.modelContext) var modelContext
    @State private var showAddView = false
    @Binding var rhythm: Rhythm
    
    var body: some View {
        VStack {
            //
            VStack {
                HStack {
                    Text("Total")
                        .font(.title3.bold())
                        .fontDesign(.rounded)
                    
                    Spacer()
                }
                HStack {
                    Text("\(rhythm.totalMinutes) minutes")
                        .font(.largeTitle.bold())
                        .fontDesign(.rounded)
                    
                    
                    Spacer()
                    
                    Button {
                        showAddView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.green)
                    }
                }
            }
            .padding(.vertical)
            
            
            
            //                Show the beats here
            List {
                ForEach(rhythm.beats, id: \.name) { beat in
                    HStack {
                        VStack (alignment: .leading) {
                            Text(beat.name)
                                .font(.title3.bold())
                                .fontDesign(.default)
                                .foregroundStyle(.primary)
                            
                            Text("\(beat.time) minutes")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                    }
                }
                .onDelete(perform: { indexSet in
                    for beatIndex in indexSet {
                        let beat = rhythm.beats[beatIndex]
                        modelContext.delete(beat)
                    }
                })
                .onMove(perform: { source, destination in
                    var updatedbeatsList = rhythm.beats
                    
                    updatedbeatsList.move(fromOffsets: source, toOffset: destination)
                    for (index, beat) in updatedbeatsList.enumerated() {
                        beat.orderIndex = index
                    }
                })
                
            }
            .listStyle(.plain)
            
            Spacer()
            
            // Start the routine
            NavigationLink {
                Text("Hello")
            } label: {
                Image(systemName: "play.circle.fill")
                    .font(.system(size: 80))
            }
        }
        .padding(.horizontal)
        .sheet(isPresented: $showAddView) {
            AddBeatView()
        }
        .toolbar {
            if rhythm.beats.count > 0 {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            
        }
    }
}

#Preview {
    
    RhythmView(rhythm: .constant(Rhythm(name: "Shower")))
}
