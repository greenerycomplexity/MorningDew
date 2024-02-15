import SwiftData
import SwiftUI

@main
@MainActor
struct MorningDew: App {
    @AppStorage("isOnboarding") var isOnboarding: Bool = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if isOnboarding {
                    OnboardingView()
                } else {
                    ContentView()
                        .modelContainer(AppData.appContainer)
                        .transition(.opacity)
                }
            }
            .animation(.default, value: isOnboarding)
        }
    }
}
