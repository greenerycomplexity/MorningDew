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

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: 25) {
                Text("How MorningDew helps:")
                    .font(.title.bold())
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)

                OnboardingFeatureCell(icon: "⏱️", title: "Timer", secondary: "Don't lose track of time!")
                OnboardingFeatureCell(icon: "🎵", title: "Fast-paced music", secondary: "Get you moving!")
                OnboardingFeatureCell(icon: "🚨", title: "Random checkups", secondary: "No response? Sound the alarm!")
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 50)

            Button("Get started") {
                isOnboarding = false
            }
            .tint(.blue)
            .buttonStyle(.borderedProminent)
            Spacer()
        }
    }
}

struct OnboardingFeatureCell: View {
    var icon: String
    var title: String
    var secondary: String

    var titleColor: any ShapeStyle = Color.primary
    var secondaryColor: any ShapeStyle = Color.secondary

    var body: some View {
        HStack(spacing: 20) {
            Text(icon)
                .font(.custom("SF Pro", size: 50, relativeTo: .largeTitle))
                .fontDesign(.rounded)
                .frame(width: 60, height: 80)
                .padding(.leading)

            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.title3.bold())
                    .fontDesign(.rounded)
                    .foregroundStyle(titleColor)
                Text(secondary)
                    .font(.headline)
                    .foregroundStyle(secondaryColor)
            }
            Spacer()
        }
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    OnboardingFeaturesView(activeTab: .constant(.features))
}
