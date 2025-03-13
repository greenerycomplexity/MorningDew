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
            VStack(alignment: .leading, spacing: 10) {
                VStack(alignment: .center) {
                    Text("How MorningDew helps")
                        .font(.title.bold())
                }
                .foregroundStyle(.white)
                .padding(.bottom, 20)
                .moveAndFade(showAnimation: showText)

                OnboardingFeatureCell(showCellAnimation: $showTimer, icon: "⏱️", title: "Timer for each task", secondary: "No more losing track of time")

                OnboardingFeatureCell(showCellAnimation: $showMusic, icon: "🎵", title: "Fast-paced music", secondary: "Getting you to move quickly")

                OnboardingFeatureCell(showCellAnimation: $showAlarm, icon: "🚨", title: "Interval check-ups", secondary: "Pulling you back to the task at hand")
                
                OnboardingFeatureCell(showCellAnimation: $showBreathe, icon: "🧘", title: "Guided breathing sessions", secondary: "Providing a moment of calm, if you get overwhelmed")
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 50)

            
            Spacer()
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
                    .padding(.horizontal, 20)
                    .background(.orange.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .scaleEffect(showStartButton ? 1 : 0)
                    .animation(.spring(bounce: 0.6), value: showStartButton)
            }
            Spacer()
        }
        .onChange(of: activeTab) {
            if activeTab == self.tab && !showText {
                let deadline = DispatchTime.now()
       
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    showText = true
                }
       
                DispatchQueue.main.asyncAfter(deadline: deadline + 1.0) {
                    pauseAllSounds()
                    showTimer = true
                    SoundPlayer().play(file: "tickingClock.wav")
                }
       
                DispatchQueue.main.asyncAfter(deadline: deadline + 2.5) {
                    pauseAllSounds()
                    showMusic = true
                    SoundPlayer().play(file: "electro.wav")
                }
       
                DispatchQueue.main.asyncAfter(deadline: deadline + 5.5) {
                    pauseAllSounds()
                    showAlarm = true
                    musicPlayer?.setVolume(0.2, fadeDuration: 2)
                    SoundPlayer().play(file: "alarm.wav")
                }
                
                DispatchQueue.main.asyncAfter(deadline: deadline + 6.5) {
                    pauseAllSounds()
                    showBreathe = true
                    
                    // Continue playing the birds sound
                    musicPlayer?.volume = 0.8
                    musicPlayer?.play()
                    delay(seconds: 2) {
                        musicPlayer?.setVolume(0.2, fadeDuration: 2)
                    }
                }
       
                DispatchQueue.main.asyncAfter(deadline: deadline + 8) {
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
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .moveAndFade(showAnimation: showCellAnimation, duration: cellDuration)
    }
}

#Preview {
    @Previewable @State var activeTab: OnboardingTab = .greeting
    
    OnboardingFeaturesView(activeTab: $activeTab)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
        .onAppear {
            activeTab = .features
        }
}
