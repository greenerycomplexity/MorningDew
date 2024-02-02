import SwiftUI
import SwiftData

@main
struct MorningDew: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Rhythm.self)
        }
    }
}

