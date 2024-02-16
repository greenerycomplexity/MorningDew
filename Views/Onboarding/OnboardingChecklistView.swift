//
//  SwiftUIView.swift
//
//
//  Created by Son Cao on 15/2/2024.
//

import SwiftUI

struct OnboardingChecklistView: View {
    @State private var showText = false
    @State private var showCellAnimation = false
    @State var listCellDelay = 1.0

    let listTextColor: Color = .white
    let backgroundListRowColor: Material = .ultraThinMaterial

    var textDuration = 1.5

    @Binding var activeTab: OnboardingTab
    let tab: OnboardingTab = .checklist

    var body: some View {
        VStack {
            Spacer()
            Text("""
            You already have a morning routine,
            a set of tasks to do - your morning
            **Rhythm**.
            """)
            .font(.title3)
            .foregroundStyle(.white)
            .padding(.bottom, 40)
            .opacity(showText ? 1.0 : 0)
            .offset(y: showText ? 0 : 20)
            .animation(.bouncy(duration: textDuration), value: showText)

            ForEach(1 ..< 4) { index in
                HStack {
                    VStack(alignment: .leading) {
                        Text("Task \(index)")
                            .foregroundStyle(listTextColor)
                            .font(.title2.bold())
                            .fontDesign(.default)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.vertical, 25)
                .frame(maxWidth: .infinity)
                .background(backgroundListRowColor)
                .clipShape(RoundedRectangle(cornerRadius: 15))

                // Animation
                .opacity(showCellAnimation ? 1.0 : 0)
                .offset(y: showCellAnimation ? 0 : 10)
                .animation(.bouncy(duration: 0.5).delay(listCellDelay * Double(index)), value: showCellAnimation)
            }
            .padding(.vertical, 2)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, 20)
        // .onAppear(perform: {
        //     // Because onAppear might execute too early,
        //     // before the List view is fully initialized and ready for animation
        //     DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
        //         showCellAnimation = true
        //     }
        //     testAnimation = true
        // })

        .onChange(of: activeTab) {
            if activeTab == self.tab {
                musicPlayer?.setVolume(0.75, fadeDuration: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showCellAnimation = true
                }
                showText = true
            }
        }
    }
}

#Preview {
    OnboardingChecklistView(activeTab: .constant(.checklist))
}
