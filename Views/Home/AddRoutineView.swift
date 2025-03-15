//
//  AddRoutineView.swift
//  MorningDew
//
//  Created by Son Cao on 23/1/2024.
//

import SwiftData
import SwiftUI

struct AddRoutineView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var name = "New Routine"
    @State private var emoji = AppData.defaultEmoji
    @State private var showEmojiPicker = false
    
    @State private var showDuplicateNameAlert = false
    let addRoutineFailed = "Failed to save Routine"
    let routineFailedMessage = "Existing Routine names cannot be reused"
    
    @State private var showEmptyAlert = false
    
    var body: some View {
        ZStack {
            Color.offBlack.ignoresSafeArea()
                    
            VStack(spacing: 20) {
                // MARK: Emoji Picker

                ZStack(alignment: .bottom) {
                    Button {
                        showEmojiPicker = true
                    } label: {
                        Text(emoji)
                            .font(.system(size: 75))
                            .frame(width: 125, height: 125)
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
                    .padding(20)
                    .padding(.bottom)
                    .background(.offBlackHighlight)
                    .clipShape(.rect(cornerRadius: 30))
                    .padding(.top, 5)
                    
                    Text("Tap to Edit")
                        .offset(y: -10)
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                
                // MARK: Routine Name Editor

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
                    
                    let descriptor = FetchDescriptor<Routine>(
                        predicate: #Predicate { routine in
                            routine.name == name
                        }
                    )
                        
                    let count = (try? modelContext.fetchCount(descriptor)) ?? 0
                    guard count == 0 else {
                        showDuplicateNameAlert = true
                        return
                    }
                    
                    let newRoutine = Routine(name: name, emoji: emoji)
                    withAnimation {
                        modelContext.insert(newRoutine)
                    }
                    dismiss()
                }
                .buttonStyle(GradientButton(gradient: .buttonGradient))
                .alert("Name field cannot be empty", isPresented: $showEmptyAlert) {
                    Button("Okay") {}
                }
                .alert(addRoutineFailed, isPresented: $showDuplicateNameAlert) {
                    Button("Okay") {}
                } message: {
                    Text(routineFailedMessage)
                }
            }
            .foregroundStyle(.white)
            .padding(20)
           
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Routine.self, configurations: config)
        
        let routine = Routine(name: "Morning Routine")
        
        return AddRoutineView()
            .modelContainer(container)
    }
}
