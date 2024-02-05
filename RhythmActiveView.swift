//  StartRhythmView.swift
//
//  MorningDew
//
//  Created by Son Cao on 19/1/2024.
//

import SwiftUI
import SwiftData

struct RhythmActiveView: View {
    var task: TaskItem
    
    var body: some View {
        VStack {
            Text(task.name)
                .font(.largeTitle.bold())
                .fontDesign(.rounded)
            
            TimerView()
            
            Spacer()
        }
    }
}

struct TimerView: View {
    let radius: CGFloat = 140
    let pi = Double.pi
    let dotCount = 30
    let dotLength: CGFloat = 3
    let spaceLength: CGFloat
    
    init() {
        let circumerence: CGFloat = CGFloat(2.0 * pi) * radius
        spaceLength = circumerence / CGFloat(dotCount) - dotLength
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.black, style: StrokeStyle(lineWidth: 2, lineCap: .butt, lineJoin: .miter, miterLimit: 0, dash: [dotLength, spaceLength], dashPhase: 0))
                .frame(width: radius * 2, height: radius * 2)
//                .overlay(
//                    Circle()
//                        .stroke(Color.indigo, style: StrokeStyle( lineWidth: 10))
//                )
            
            Text("Timer goes here")
        }
        .padding(.bottom)
        
        VStack {
            Button (role: .destructive) {
                
            } label: {
                Text("I WANT A BREAK!")
                    .font(.title2.bold())
                    .fontDesign(.rounded)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Rhythm.self, configurations: config)
        
        let task = TaskItem(name: "Shower", time: 40, perceivedDifficulty: 4, orderIndex: 1)
        
        return RhythmActiveView(task: task)
            .modelContainer(container)
    }
    
    
   
}
