//
//  AddRhythmView.swift
//  MorningDew
//
//  Created by Son Cao on 23/1/2024.
//

import SwiftData
import SwiftUI

struct AddRhythmView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var name = "New Rhythm"
    @State private var emoji = AppData.defaultEmoji
    @State private var showEmojiPicker = false
    
    @State private var showDuplicateNameAlert = false
    let addRhythmFailed = "Failed to save"
    let rhythmFailedMessage = "Existing Rhythm names cannot be reused. Please try again."
    
    @State private var showEmptyAlert = false
    
    var body: some View {
        ZStack {
            Color.offBlack.ignoresSafeArea()
                    
            VStack(spacing: 20) {
                Button {
                    showEmojiPicker = true
                } label: {
                    Text(emoji)
                        .font(.system(size: 75))
                        .frame(width: 150, height: 150)
                        .background(.black.opacity(0.8))
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .strokeBorder(.green, lineWidth: 5)
                        )
                }
                .sheet(isPresented: $showEmojiPicker) {
                    EmojiPickerView(chosenEmoji: $emoji)
                        .presentationDetents([.fraction(0.75)])
                        .presentationDragIndicator(.visible)
                }
                .padding(.top)
                
                HStack {
                    TextField("Name", text: $name)
                        .font(.title.bold())
                        .fontWidth(.expanded)
                        .maxInputLength(for: $name, length: 16)
                            
                    Image(systemName: "pencil")
                        .font(.title3.bold())
                }
                .charcoalFrame()
                        
                Spacer()
                    
                Button("Save") {
                    guard !name.isEmpty else {
                        showEmptyAlert = true
                        return
                    }
                    
                    let descriptor = FetchDescriptor<Rhythm>(
                        predicate: #Predicate { rhythm in
                            rhythm.name == name
                        }
                    )
                        
                    let count = (try? modelContext.fetchCount(descriptor)) ?? 0
                    if count > 0 {
                        showDuplicateNameAlert = true
                    } else {
                        let newRhythm = Rhythm(name: name, emoji: emoji)
                        withAnimation {
                            modelContext.insert(newRhythm)
                        }
                        dismiss()
                    }
                }
                .buttonStyle(GradientButton(gradient: .buttonGradient))
                .alert("Name field cannot be empty", isPresented: $showEmptyAlert) {
                    Button("Okay") {}
                }
            }
            .foregroundStyle(.white)
            .padding(20)
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
