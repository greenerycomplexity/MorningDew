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
        }
        .modelContainer(modelContainer)
    }
}

