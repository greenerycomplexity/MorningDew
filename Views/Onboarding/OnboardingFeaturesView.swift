//
//  SwiftUIView.swift
//
//
//  Created by Son Cao on 15/2/2024.
//

import SwiftUI

struct OnboardingFeaturesView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?

    @Binding var activeTab: OnboardingTab
    let tab: OnboardingTab = .features

    @State private var showText = false
    @State private var showTimer = false
    @State private var showMusic = false
    @State private var showAlarm = false
    @State private var showBreathe = false
    @State private var showStartButton = false
    
    func pauseAllSounds() {
        soundPlayer?.pause()
        musicPlayer?.pause()
    }

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("MorningDew")
                        .font(.largeTitle.bold())
                        .fontDesign(.monospaced)

                    Text("helps by using:")
                        .font(.title2.bold())
                }
                .foregroundStyle(.white)
                .padding(.bottom, 20)
                .moveAndFade(showAnimation: showText)

                OnboardingFeatureCell(showCellAnimation: $showTimer, icon: "⏱️", title: "Timer", secondary: "Don't lose track of time!")

                OnboardingFeatureCell(showCellAnimation: $showMusic, icon: "🎵", title: "Fast-paced music", secondary: "Gets you moving!")

                OnboardingFeatureCell(showCellAnimation: $showAlarm, icon: "🚨", title: "Random checkups", secondary: "No response? Sound the alarm!")
                
                OnboardingFeatureCell(showCellAnimation: $showBreathe, icon: "🧘", title: "Guided Breathing", secondary: "A moment of calm, if you're overwhelmed.")
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 50)

            Button {
                musicPlayer?.stop()
                soundPlayer?.stop()
                isOnboarding = false

            } label: {
                Text("Get started")
                    .foregroundStyle(.white)
                    .font(.title3.bold())
                    .fontDesign(.rounded)
                    .padding()
                    .background(.orange.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .scaleEffect(showStartButton ? 1 : 0)
                    .animation(.spring(bounce: 0.6), value: showStartButton)
            }
            Spacer()
        }
        .onChange(of: activeTab) {
            if activeTab == self.tab {
                let deadline = DispatchTime.now()

                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    showText = true
                }

                DispatchQueue.main.asyncAfter(deadline: deadline + 1.0) {
                    pauseAllSounds()
                    showTimer = true
                    SoundPlayer().play(file: "tickingClock.wav")
                }

                DispatchQueue.main.asyncAfter(deadline: deadline + 3) {
                    pauseAllSounds()
                    showMusic = true
                    SoundPlayer().play(file: "electro.wav")
                }

                DispatchQueue.main.asyncAfter(deadline: deadline + 6.5) {
                    pauseAllSounds()
                    showAlarm = true
                    SoundPlayer().play(file: "alarm.wav")
                }
                
                DispatchQueue.main.asyncAfter(deadline: deadline + 8.5) {
                    pauseAllSounds()
                    showBreathe = true
                    
                    // Continue playing the birds sound
                    musicPlayer?.volume = 0.8
                    musicPlayer?.play()
                }

                DispatchQueue.main.asyncAfter(deadline: deadline + 11) {
                    showStartButton = true
                }
            }
        }
    }
}

struct OnboardingFeatureCell: View {
    @Binding var showCellAnimation: Bool
    let cellDuration = 1.0

    var icon: String
    var title: String
    var secondary: String

    var titleColor: any ShapeStyle = Color.primary
    var secondaryColor: any ShapeStyle = Color.secondary

    var body: some View {
        HStack(spacing: 15) {
            Text(icon)
                .font(.custom("SF Pro", size: 40, relativeTo: .largeTitle))
                .fontDesign(.rounded)
                .frame(width: 60, height: 80)
                .padding(.leading)

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.title3.bold())
                    .fontDesign(.rounded)
                    .foregroundStyle(titleColor)
                
                Text(secondary)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 5)
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .moveAndFade(showAnimation: showCellAnimation, duration: cellDuration)
    }
}

#Preview {
    OnboardingFeaturesView(activeTab: .constant(.features))
}
