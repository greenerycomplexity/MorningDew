//
//  SwiftUIView.swift
//
//
//  Created by Son Cao on 15/2/2024.
//

import SwiftUI

struct OnboardingGreetingView: View {
    @State private var showIcon = false
    @State private var showText = false

    var duration = 1.5
    var delay = 3.0

    @Binding var activeTab: OnboardingTab
    let tab: OnboardingTab = .greeting

    var body: some View {
        VStack(alignment: .leading) {
            DawnIconWithGlow(showIcon: $showIcon)

            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Welcome to")
                        .font(.title2)
                        .fontDesign(.rounded)

                    Text("MorningDew")
                        .font(.largeTitle.bold())
                        .fontDesign(.monospaced)
                }
                .opacity(showText ? 1.0 : 0)
                .animation(.bouncy(duration: duration).delay(delay), value: showText)

                Text("""
                Have ADHD?
                A better morning routine starts \(Text("today").underline())
                """)

                // Text("""
                // Have ADHD?
                // Experience a better morning routine \(Text("today").underline())
                // """)
                .font(.title3)
                .padding(.top)
                .opacity(showText ? 1.0 : 0)
                .animation(.bouncy(duration: duration).delay(delay * 1.7), value: showText)
            }

            .offset(y: showText ? 0 : 10)
            .foregroundStyle(.white)
        }
        .padding(.horizontal, 20)
        .onAppear {
            if activeTab == self.tab {
                showIcon = true
                showText = true
                SoundPlayer().play(file: "startJingle.wav")
                MusicPlayer().play(file: "forest.wav", volume: 0.1)
            }
        }
    }
}

struct DawnIconWithGlow: View {
    @Binding var showIcon: Bool

    var duration = 1.5

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.1, to: 0.4)
                .fill(.white)
                .rotationEffect(.degrees(180))
                .frame(height: 100)
                .shadow(color: .orange, radius: 50)
                .shadow(color: .white, radius: 15)
                .shadow(color: .white, radius: 15)
                .shadow(color: .white, radius: 15)
                .opacity(showIcon ? 1.0 : 0)
                .animation(.smooth(duration: 0.4).delay(duration), value: showIcon)

            Image(.dawn)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
                .opacity(showIcon ? 1.0 : 0)
                .animation(.bouncy(duration: duration), value: showIcon)
        }
    }
}

#Preview {
    OnboardingGreetingView(activeTab: .constant(.greeting))
}
