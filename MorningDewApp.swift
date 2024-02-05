import SwiftUI
import SwiftData

@main
@MainActor
struct MorningDew: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(appContainer)
        }
    }
    
    // Data-preloading at first access
    let appContainer: ModelContainer = {
        do {
            let container = try ModelContainer(for: Rhythm.self)
            
            // Make sure the persistent store is empty. If it's not, return the non-empty container.
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
                TaskItem(name: "Brush teeth", time: 3, perceivedDifficulty: 1, orderIndex: 0),
                TaskItem(name: "Shower", time: 10, perceivedDifficulty: 2, orderIndex: 1),
                TaskItem(name: "Make coffee", time: 5, perceivedDifficulty: 2, orderIndex: 2),
                TaskItem(name: "Pick outfit", time: 7, perceivedDifficulty: 3, orderIndex: 3),
                TaskItem(name: "Make bed", time: 3, perceivedDifficulty: 1, orderIndex: 4)
            ]

            let weekendTasks = [
                TaskItem(name: "Drink a glass of water", time: 1, perceivedDifficulty: 1, orderIndex: 0),
                TaskItem(name: "Have breakfast", time: 15, perceivedDifficulty: 2, orderIndex: 1),
                TaskItem(name: "Yoga", time: 30, perceivedDifficulty: 4, orderIndex: 2),
                TaskItem(name: "Meditate", time: 10, perceivedDifficulty: 3, orderIndex: 3),
                TaskItem(name: "Journal", time: 15, perceivedDifficulty: 3, orderIndex: 4)
            ]

            let wfhTasks = [
                TaskItem(name: "Wash face", time: 3, perceivedDifficulty: 1, orderIndex: 0),
                TaskItem(name: "Make coffee", time: 5, perceivedDifficulty: 2, orderIndex: 1),
                TaskItem(name: "Have breakfast", time: 15, perceivedDifficulty: 2, orderIndex: 2)
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




