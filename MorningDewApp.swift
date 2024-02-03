import SwiftUI
import SwiftData

@main
struct MorningDew: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Rhythm.self)
        } catch {
            fatalError("Could not initialize Rhythm ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}

@MainActor
class DataController {
    static let previewContainer: ModelContainer = {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Rhythm.self, configurations: configuration)
            
            let rhythm = Rhythm(name: "Morning Routine")
            
            container.mainContext.insert(rhythm)
            
            let tasks = [
                TaskItem(name: "Shower", time: 50, perceivedDifficulty: 4, orderIndex: 1),
                TaskItem(name: "Breakfast", time: 50, perceivedDifficulty: 2, orderIndex: 2),
                TaskItem(name: "Water plants", time: 50, perceivedDifficulty: 4, orderIndex: 3),
                TaskItem(name: "Pick outfit", time: 50, perceivedDifficulty: 5, orderIndex: 4)
            ]
            
            for task in tasks {
                rhythm.tasks.append(task)
            }
            return container
        } catch {
            fatalError("Failed to create container")
        }
    }()
}




