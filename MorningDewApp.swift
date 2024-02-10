import SwiftUI
import SwiftData

@main
@MainActor
struct MorningDew: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(AppData.appContainer)
        }
    }
}
