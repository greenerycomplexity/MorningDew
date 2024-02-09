//
//  AppData.swift
//  MorningDew
//
//  Created by Son Cao on 5/2/2024.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
struct AppData {
    static let name = "MorningDew"
    static let defaultEmoji = "🌻"
    
    static let previewContainer: ModelContainer = {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Rhythm.self, configurations: configuration)
            
            let rhythm = Rhythm(name: "Morning Routine", emoji: "🌻")
            
            container.mainContext.insert(rhythm)
            
            let tasks = [
                TaskItem(name: "Shower", minutes: 10, perceivedDifficulty: 4, orderIndex: 1),
                TaskItem(name: "Breakfast", minutes: 20, perceivedDifficulty: 2, orderIndex: 2),
                TaskItem(name: "Water plants", minutes: 5, perceivedDifficulty: 4, orderIndex: 3),
                TaskItem(name: "Pick outfit", minutes: 4, perceivedDifficulty: 5, orderIndex: 4)
            ]
            
            rhythm.tasks.append(contentsOf: tasks)
            return container
        } catch {
            fatalError("Failed to create container")
        }
    }()
}
