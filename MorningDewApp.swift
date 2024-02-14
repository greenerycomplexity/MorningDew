import SwiftUI
import SwiftData

@main
@MainActor
struct MorningDew: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true

    var body: some Scene {
        WindowGroup {
            if isOnboarding {
                OnboardingView()
            } else {
                ContentView()
                    .modelContainer(AppData.appContainer)
            }
        }
    }
}
