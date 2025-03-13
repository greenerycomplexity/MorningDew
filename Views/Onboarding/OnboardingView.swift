//
//  OnboardingView.swift
//  MorningDew
//
//  Created by Son Cao on 13/2/2024.
//

import SwiftUI

// To be used with onChange animations,
// since multiple TabViews with onAppear becomes buggy
// => Unreliable animations
enum OnboardingTab {
    case greeting, checklist, emphathise, features
}

struct OnboardingView: View {
    @State var activeTab: OnboardingTab = .greeting

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(colors: [.cyan, .green], startPoint: .bottomLeading, endPoint: .topTrailing)
                .ignoresSafeArea()

            TabView(selection: $activeTab) {
                OnboardingGreetingView(activeTab: $activeTab)
                    .tag(OnboardingTab.greeting)

                OnboardingChecklistView(activeTab: $activeTab)
                    .tag(OnboardingTab.checklist)

                OnboardingEmpathiseView(activeTab: $activeTab)
                    .tag(OnboardingTab.emphathise)

                OnboardingFeaturesView(activeTab: $activeTab)
                    .tag(OnboardingTab.features)
            }
            .pageIndex(hidden: activeTab == .greeting ? true : false)
           


          
        }
    }
}

#Preview {
    OnboardingView()
}
