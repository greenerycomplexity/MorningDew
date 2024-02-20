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
    
    // Data-preloading at first access
    static let appContainer: ModelContainer = {
        do {
            let container = try ModelContainer(for: Rhythm.self)
            
            // Make sure current container is empty before loading, else return current container
            var itemFetchDescriptor = FetchDescriptor<Rhythm>()
            itemFetchDescriptor.fetchLimit = 1
            
            guard try container.mainContext.fetch(itemFetchDescriptor).count == 0 else { return container }
            
            // This code will only run if the persistent store is empty.
            let officeDayRhythm = Rhythm(name: "Office Day", emoji: "📊")
            let weekendRhythm = Rhythm(name: "Weekend", emoji: "🌻")
            let wfhRhythm = Rhythm(name: "WFH", emoji: "🏠")

            let rhythms: [Rhythm] = [officeDayRhythm, weekendRhythm, wfhRhythm]

            for rhythm in rhythms {
                container.mainContext.insert(rhythm)
            }
            
            let officeDayTasks = [
                TaskItem(name: "Brush teeth", minutes: 1, perceivedDifficulty: 1),
                TaskItem(name: "Shower", minutes: 1, perceivedDifficulty: 2),
                TaskItem(name: "Make coffee", minutes: 1, perceivedDifficulty: 2),
                TaskItem(name: "Pick outfit", minutes: 1, perceivedDifficulty: 3),
                TaskItem(name: "Make bed", minutes: 1, perceivedDifficulty: 1)
            ]

            let weekendTasks = [
                TaskItem(name: "Drink a glass of water", minutes: 1, perceivedDifficulty: 1),
                TaskItem(name: "Have breakfast", minutes: 15, perceivedDifficulty: 2),
                TaskItem(name: "Yoga", minutes: 30, perceivedDifficulty: 4),
                TaskItem(name: "Meditate", minutes: 10, perceivedDifficulty: 3),
                TaskItem(name: "Journal", minutes: 15, perceivedDifficulty: 3)
            ]

            let wfhTasks = [
                TaskItem(name: "Wash face", minutes: 3, perceivedDifficulty: 1),
                TaskItem(name: "Make coffee", minutes: 5, perceivedDifficulty: 2),
                TaskItem(name: "Have breakfast", minutes: 15, perceivedDifficulty: 2)
            ]


            officeDayRhythm.tasks.append(contentsOf: officeDayTasks)
            weekendRhythm.tasks.append(contentsOf: weekendTasks)
            wfhRhythm.tasks.append(contentsOf: wfhTasks)

            return container
        } catch {
            fatalError("Failed to create container")
        }
    }()
}
