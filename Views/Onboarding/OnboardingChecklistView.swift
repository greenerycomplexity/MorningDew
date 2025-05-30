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
    

    let listTextColor: Color = .black
    let backgroundListRowColor = Color.white

    var textDuration = 1.0
    @State var listCellDelay = 0.3

    @Binding var activeTab: OnboardingTab
    let tab: OnboardingTab = .checklist

    let exampleTasks = ["Make coffee", "Shower", "Pushups", "Feed my pet unicorn", "Pick an outfit"]

    var body: some View {
        VStack {
            Spacer()
            Text("""
            You already know what you need
            to do in the morning...
            """)
            .font(.title3)
            .foregroundStyle(.white)
            .padding(.bottom, 40)
            .opacity(showText ? 1.0 : 0)
            .offset(y: showText ? 0 : 20)
            .animation(.bouncy(duration: textDuration), value: showText)

            ForEach(exampleTasks.indices, id: \.self) { index in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(index + 1). \(exampleTasks[index])")
                            .foregroundStyle(listTextColor)
                            .font(.title2.bold())
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
        .onChange(of: activeTab) {
            if activeTab == self.tab {
                showText = true
                musicPlayer?.setVolume(0.3, fadeDuration: 2)
                delay(seconds: 1.0) {
                    showCellAnimation = true
                }
                
            }
        }
    }
}

#Preview {
    OnboardingChecklistView(activeTab: .constant(.checklist))
        .background(.blue)
}
