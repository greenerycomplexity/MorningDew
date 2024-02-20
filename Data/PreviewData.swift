//
//  PreviewData.swift
//  MorningDew
//
//  Created by Son Cao on 15/2/2024.
//

import Foundation
import SwiftUI
import SwiftData

// Sample data used for SwiftData Previews
// Container loaded in-memory only (non-persistent)
@MainActor
struct PreviewData {
    static let container: ModelContainer = {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Rhythm.self, configurations: configuration)
            
            let rhythm = Rhythm(name: "Morning Routine", emoji: "🌻")
            
            container.mainContext.insert(rhythm)
            
            let tasks = [
                TaskItem(name: "Shower", minutes: 10, perceivedDifficulty: 4),
                TaskItem(name: "Breakfast", minutes: 20, perceivedDifficulty: 2),
                TaskItem(name: "Water plants", minutes: 5, perceivedDifficulty: 4),
                TaskItem(name: "Pick outfit", minutes: 4, perceivedDifficulty: 5)
            ]
            
            rhythm.tasks.append(contentsOf: tasks)
            return container
            
        } catch {
            fatalError("Failed to create container")
        }
    }()
    
    static let taskItemExample = TaskItem(name: "Shower Example", minutes: 10)
    
    static let rhythmExample: Rhythm = {
        let rhythm = Rhythm(name: "Morning Example", emoji: "🌻")
        
        let tasks = [
            TaskItem(name: "Shower", minutes: 10, perceivedDifficulty: 4),
            TaskItem(name: "Breakfast", minutes: 20, perceivedDifficulty: 2),
            TaskItem(name: "Water plants", minutes: 5, perceivedDifficulty: 4),
            TaskItem(name: "Pick outfit", minutes: 4, perceivedDifficulty: 5)
        ]
        
        rhythm.tasks.append(contentsOf: tasks)
        
        return rhythm
    }()
}

