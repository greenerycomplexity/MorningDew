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
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(colors: [.cyan, .green], startPoint: .bottomLeading, endPoint: .topTrailing)
                .ignoresSafeArea()

            // LinearGradient(colors: [.cyan, .orange], startPoint: .bottomLeading, endPoint: .topTrailing)
            //     .ignoresSafeArea()

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

            .tabViewStyle(.page)
            // .tabViewStyle(.page(indexDisplayMode: .never))

            // Button {
            //
            // } label: {
            //     Image(systemName: "arrow.forward.circle.fill")
            //         .font(.custom("SF Pro", size: 40, relativeTo: .largeTitle))
            //         .foregroundStyle(.white)
            //         .shadow(radius: 4, x: 2, y: 3)
            //         .padding()
            //         .padding(.trailing)
            //
            // }
        }
    }
}

#Preview {
    OnboardingView()
}
