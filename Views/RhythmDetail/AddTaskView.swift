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
    @State private var minutes = 5
    @State private var perceivedDifficulty = 3
    @Bindable var currentRhythm: Rhythm
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var minutesNew: Int = 0
    @State private var secondsNew: Int = 15
    
    let gradient =
        LinearGradient(colors: [.teal, .green], startPoint: .leading, endPoint: .trailing)
    
    let highlightColor = makeColor(68, 68, 68)
    
    @State private var showDurationEdit = false
    
    var body: some View {
        ZStack {
            CustomColor.offBlackBackground.ignoresSafeArea()
                
            VStack(spacing: 10) {
                HStack {
                    TextField("New Task", text: $name)
                        .font(.title.bold())
                        .foregroundStyle(.white)
                        
                    Image(systemName: "pencil")
                        .foregroundStyle(.white)
                        .font(.title3.bold())
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(highlightColor)
                .clipShape(.rect(cornerRadius: 10))
                    
                Button {
                    showDurationEdit = true
                } label: {
                    HStack {
                        Text("Duration")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Spacer()
                            
                        Text("\(minutes) min.")
                        Image(systemName: "chevron.right")
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(highlightColor)
                    .clipShape(.rect(cornerRadius: 10))
                }
                .sheet(isPresented: $showDurationEdit) {
                    TaskDurationView(minutes: $minutesNew, seconds: $secondsNew)
                        .presentationDetents([.fraction(0.5)])
                }
                    
                HStack {
                    Text("Difficulty")
                        .font(.headline)
                        .foregroundStyle(.white)
                        
                    Spacer()
                        
                    StarRatingView(rating: $perceivedDifficulty)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(highlightColor)
                .clipShape(.rect(cornerRadius: 10))
                    
                Spacer()
                
                Button {
                    let newTask = TaskItem(name: name, minutes: Double(minutes), perceivedDifficulty: perceivedDifficulty, rhythm: currentRhythm)
                        
                    currentRhythm.tasks.append(newTask)
                    dismiss()
                } label: {
                    Text("Save")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .background(.white.opacity(0.5))
                        .background(gradient.opacity(1.0))
                        .clipShape(Capsule())
                }
                .padding(.top, 30)
                
                
            }
            .padding(20)
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
