//
//  SwiftUIView.swift
//
//
//  Created by Son Cao on 15/2/2024.
//

import SwiftUI

struct OnboardingGreetingView: View {
    @State private var showIcon = false
    @State private var showGlow = false
    @State private var showSecondaryText = false
    var duration = 1.25

    @Binding var activeTab: OnboardingTab
    @State var showInstruction = false
    let tab: OnboardingTab = .greeting

    var body: some View {
        VStack {
            Spacer()
            Spacer()
            VStack {
                DawnIconWithGlow(showGlow: $showGlow)
                Text("MorningDew")
                    .font(.title.bold())
                    .fontDesign(.monospaced)
                    .offset(y: -15)
            }
            .opacity(showIcon ? 1.0 : 0)
            .offset(y: showIcon ? -50 : 0)
            .animation(.smooth(duration: duration), value: showIcon)

            VStack {
                Text("Have ADHD?")
                Text("A better morning routine starts today.")
                    .multilineTextAlignment(.center)
            }
            .frame(width: 300)
            .font(.title3)
            .opacity(showSecondaryText ? 1.0 : 0)
            .animation(.bouncy(duration: duration).delay(3.0), value: showSecondaryText)

            
            Spacer()
            HStack {
                AnimatedText(text: "Swipe to continue", moveGradient: $showInstruction, moveDuration: 3.0)
                    .foregroundStyle(.black.opacity(0.5))
                    .font(.title3)
            }
            .onAppear {
                delay(seconds: 6.0) {
                    if activeTab == .greeting {
                        withAnimation(.easeInOut) {
                            showInstruction = true
                        }
                    }
                }
            }
            
            .opacity(showInstruction ? 1 : 0)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 20)
        .offset(y: -50)
        .onAppear {
            if activeTab == self.tab {
                delay(seconds: 1.0) {
                    showIcon = true
                    showSecondaryText = true
                    SoundPlayer().play(file: "startJingle.wav")
                    MusicPlayer().play(file: "forest.wav", volume: 0.1)
                    delay(seconds: 1) {
                        showGlow = true
                    }
                }
            }
        }
        .onChange(of: activeTab) {
            if activeTab != .greeting {
                withAnimation(.easeOut(duration: 0.2)) {
                    showInstruction = false
                }
            }
        }
    }
}

struct DawnIconWithGlow: View {
    @Binding var showGlow: Bool

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.1, to: 0.4)
                .fill(.white)
                .rotationEffect(.degrees(180))
                .frame(height: 150)
                .offset(y: 25)
                .shadow(color: .orange, radius: 100)
                .shadow(color: .white, radius: 35)
                .shadow(color: .white, radius: 35)
                .shadow(color: .white, radius: 35)
                .opacity(showGlow ? 1.0 : 0)
                .animation(.bouncy(duration: 1.0), value: showGlow)

            Image(.dawn)
                .resizable()
                .scaledToFit()
                .frame(width: 200)
        }
    }
}

#Preview {
    OnboardingGreetingView(activeTab: .constant(.greeting))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.blue)
}
