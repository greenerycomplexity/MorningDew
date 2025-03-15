//
//  AddtaskView.swift
//  MorningDew
//
//  Created by Son Cao on 17/1/2024.
//

import SwiftData
import SwiftUI


struct AddTaskView: View {
    @State private var name = "New Task"
    @State private var perceivedDifficulty = 3
    @Bindable var currentRoutine: Routine
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var minutes: Int = 0
    @State private var seconds: Int = 15
    
    // Get total seconds
    private var totalSeconds: Double {
        return Double(minutes * 60) + Double(seconds)
    }
    
    @State private var showDurationEdit = false
    @State private var showEmptyAlert = false
    
    var body: some View {
        ZStack {
            Color.offBlack.ignoresSafeArea()
                
            VStack(spacing: 10) {
                HStack {
                    TextField("Name", text: $name)
                        .font(.title2.bold())
                        .fontWidth(.expanded)
                        .maxInputLength(for: $name, length: 25)
                        
                    Image(systemName: "pencil")
                        .font(.title3.bold())
                }
                .charcoalFrame()
                    
                Button {
                    showDurationEdit = true
                } label: {
                    HStack {
                        Image(systemName: "clock.arrow.circlepath")
                            .frame(width: 10, height: 10)
                            .foregroundStyle(.secondary)
                            .padding(.trailing,5)
                        
                        Text("Duration")
                            .font(.headline)
                        Spacer()
                            
                        Text("\(minutes) min. \(seconds) sec.")
                        Image(systemName: "chevron.right")
                    }
                    .charcoalFrame()
                }
                .sheet(isPresented: $showDurationEdit) {
                    TaskDurationView(minutes: $minutes, seconds: $seconds)
                        .presentationDetents([.fraction(0.5)])
                        .presentationDragIndicator(.visible)
                }
                    
                HStack {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                        .frame(width: 10, height: 10)
                        .foregroundStyle(.secondary)
                        .padding(.trailing,5)
                    
                    Text("Difficulty")
                        .font(.headline)
                    Spacer()
                    StarRatingView(rating: $perceivedDifficulty)
                }
                
                .charcoalFrame()
                    
                Spacer()
                
                Button("Save") {
                    guard !name.isEmpty else {
                        showEmptyAlert = true
                        return
                    }
                    
                    let newTask = TaskItem(name: name, seconds: totalSeconds, perceivedDifficulty: perceivedDifficulty, routine: currentRoutine)
                        
                    currentRoutine.tasks.append(newTask)
                    dismiss()
                }
                .alert("Name field cannot be empty", isPresented: $showEmptyAlert) {
                    Button("Okay") {}
                }
                .buttonStyle(GradientButton(gradient: .buttonGradient))
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
        
        return AddTaskView(currentRoutine: routine)
            .modelContainer(container)
    }
}
