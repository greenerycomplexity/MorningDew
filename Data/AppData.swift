//
//  AppData.swift
//  MorningDew
//
//  Created by Son Cao on 5/2/2024.
//

import Foundation
import SwiftData
import SwiftUI

@MainActor
enum AppData {
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

            let wfhRhythm = Rhythm(name: "WFH Weekday", emoji: "🏠")
            let weekendRhythm = Rhythm(name: "Weekend", emoji: "🌻")
            let officeDayRhythm = Rhythm(name: "Before the office", emoji: "📊")

            let rhythms: [Rhythm] = [officeDayRhythm, weekendRhythm, wfhRhythm]

            for rhythm in rhythms {
                container.mainContext.insert(rhythm)
            }

            let wfhTasks = [
                TaskItem(name: "Take ADHD medication", seconds: 15, perceivedDifficulty: 1),
                TaskItem(name: "Pushups", seconds: 30, perceivedDifficulty: 3),
                TaskItem(name: "Wash face", seconds: 60, perceivedDifficulty: 1),
                TaskItem(name: "Make coffee", seconds: 3 * 60, perceivedDifficulty: 2),
                TaskItem(name: "Have breakfast", seconds: 20 * 60, perceivedDifficulty: 2)
            ]

            let weekendTasks = [
                TaskItem(name: "Drink water", seconds: 20, perceivedDifficulty: 1),
                TaskItem(name: "Moisturise", seconds: 30, perceivedDifficulty: 1),
                TaskItem(name: "Have breakfast", seconds: 10 * 60, perceivedDifficulty: 2),
                TaskItem(name: "Journal", seconds: 5 * 60, perceivedDifficulty: 3)
            ]

            let officeDayTasks = [
                TaskItem(name: "Make bed", seconds: 30, perceivedDifficulty: 1),
                TaskItem(name: "Make coffee", seconds: 60, perceivedDifficulty: 2),
                TaskItem(name: "Brush teeth", seconds: 120, perceivedDifficulty: 1),
                TaskItem(name: "Shower", seconds: 10 * 60, perceivedDifficulty: 2),
                TaskItem(name: "Fix hair", seconds: 60, perceivedDifficulty: 3),
                TaskItem(name: "Pick outfit", seconds: 60, perceivedDifficulty: 3)
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
