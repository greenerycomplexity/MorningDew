//
//  OnboardingView.swift
//  MorningDew
//
//  Created by Son Cao on 13/2/2024.
//

import SwiftUI

struct DawnIconWithGlow: View {
    @State private var showIcon = false

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
        .onAppear(perform: {
            showIcon = true
        })
    }
}

struct OnboardingGreetingView: View {
    @State private var showText = false

    var duration = 1.5
    var delay = 3.0

    var body: some View {
        VStack(alignment: .leading) {
            DawnIconWithGlow()

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

                Text("A better morning routine experience starts \(Text("today").underline())")
                    // Text("A better morning routine experience starts today.")
                    .font(.title3)
                    .padding(.top)
                    .opacity(showText ? 1.0 : 0)
                    .animation(.bouncy(duration: duration).delay(delay * 1.7), value: showText)
            }

            .offset(y: showText ? 0 : 10)
            .foregroundStyle(.white)
            .onAppear(perform: {
                showText = true
            })
        }
        .padding(.horizontal, 20)
    }
}

struct OnboardingChecklistView: View {
    @State private var showCellAnimation = false
    @State var animationDelay = 1.0

    let listTextColor: Color = .white
    let backgroundListRowColor: Material = .ultraThinMaterial

    var body: some View {
        VStack {
            // Text("""
            // Every morning,
            // you already complete a set of tasks to get ready,
            // it is your morning **Rhythm**.
            // """)

            Text("""
            But, you already have a morning routine,
            a set of tasks to do - your morning
            **Rhythm**.
            """)
            .font(.title3)
            .foregroundStyle(.white)
            .padding(.bottom, 10)

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
                .animation(.bouncy(duration: 0.5).delay(animationDelay * Double(index)), value: showCellAnimation)
            }
            .padding(.bottom, 5)
        }
        .padding(.horizontal, 20)
        .onAppear(perform: {
            // Because onAppear might execute too early,
            // before the List view is fully initialized and ready for animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showCellAnimation = true
            }
        })
    }
}

struct OnboardingView: View {
    var body: some View {
        ZStack {
            // LinearGradient(colors: [.green, .teal], startRadius: .zero, endRadius: 500)
            LinearGradient(colors: [.cyan, .green], startPoint: .bottomLeading, endPoint: .topTrailing)
                .ignoresSafeArea()

            // LinearGradient(colors: [.cyan, .orange], startPoint: .bottomLeading, endPoint: .topTrailing)
            //     .ignoresSafeArea()

            TabView {
                OnboardingGreetingView()
                OnboardingChecklistView()
            }
            .tabViewStyle(.page)
        }
    }
}

#Preview {
    OnboardingView()
}

#Preview {
    OnboardingChecklistView()
}
