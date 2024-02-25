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
    @State private var showInstruction = false
    @State private var blinkingInstruction = false

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

            HStack {
                Text("Swipe to continue")
                Image(systemName: "arrow.forward")
            }
            .foregroundStyle(.white)
            .offset(y: -30)
            .opacity(showInstruction ? 1.0 : 0)
            .opacity(blinkingInstruction ? 1.0 : 0)
            .animation(.linear(duration: 0.5), value: blinkingInstruction)
            .onAppear {
                delay(seconds: 7.5) {
                withAnimation(.linear(duration: 0.5)) {
                        showInstruction = true
                    }

                    delay(seconds: 0.5) {
                        blink()
                    }
                }
            }
            .onChange(of: activeTab) {
                if activeTab != .greeting {
                    withAnimation(.linear(duration: 0.25)) {
                        showInstruction = false
                    }
                }
            }
        }
    }
    
    func blink() {
        blinkingInstruction = true

        delay(seconds: 2.0) {
            blinkingInstruction = false
        }

        delay(seconds: 3.0) {
            blink()
        }
    }
}

#Preview {
    OnboardingView()
}
