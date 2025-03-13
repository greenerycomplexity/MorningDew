//
//  SwiftUIView.swift
//
//
//  Created by Son Cao on 15/2/2024.
//

import SwiftUI

struct OnboardingEmpathiseView: View {
    @State private var showGaspButton = false
    @State private var showText = false
    @State private var shakeAmount: CGFloat = 0

    var textDuration = 1.0
    var delay = 0.75

    @Binding var activeTab: OnboardingTab
    let tab: OnboardingTab = .emphathise

    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                Text("But with ADHD, you get **distracted**")
                    .opacity(showText ? 1.0 : 0)
                    .animation(.bouncy(duration: textDuration), value: showText)

                Text("""
                A 20-minute routine turns into
                **an hour**
                """)
                .opacity(showText ? 1.0 : 0)
                .animation(.bouncy(duration: textDuration).delay(delay * 2), value: showText)
            }
            .font(.title3)
            .foregroundStyle(.white)
            .offset(y: showText ? 0 : 10)
            .padding(.bottom, 100)

            Button {
                musicPlayer?.pause()
                SoundPlayer().play(file: "gasp.wav")
                withAnimation(.spring(response: 0.1, dampingFraction: 0.1)) {
                    shakeAmount += 0.8
                }
            } label: {
                Text("Tap to Gasp")
                    .foregroundStyle(.white)
                    .font(.title2.bold())
                    .fontDesign(.rounded)
                    .padding(25)
                    .background(.orange.gradient)
                    .clipShape(.rect(cornerRadius: 20))
                    .scaleEffect(showGaspButton ? 1 : 0)
                    .animation(.spring(bounce: 0.5).delay(delay * 4), value: showGaspButton)
                    .modifier(ShakeEffect(animatableData: shakeAmount))
            }
           
            Spacer()
            Spacer()
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 20)
        // .onAppear(perform: {
        //     showGaspButton = true
        //     showText = true
        // })
        .onChange(of: activeTab) {
            if activeTab == self.tab {
                showGaspButton = true
                showText = true
            }
        }
    }
}

#Preview {
    @Previewable @State var activeTab: OnboardingTab = .greeting
    
    OnboardingEmpathiseView(activeTab: $activeTab)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
        .onAppear {
            activeTab = .emphathise
        }
}
