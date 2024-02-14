//
//  OnboardingView.swift
//  MorningDew
//
//  Created by Son Cao on 13/2/2024.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        ZStack {
            LinearGradient(colors: [.cyan, .green], startPoint: .bottomLeading, endPoint: .topTrailing)
                .ignoresSafeArea()

            // LinearGradient(colors: [.cyan, .orange], startPoint: .bottomLeading, endPoint: .topTrailing)
            //     .ignoresSafeArea()

            TabView {
                OnboardingGreetingView()
                OnboardingChecklistView()
                OnboardingEmpathiseView()
                OnboardingFeaturesView()
            }
            .tabViewStyle(.page)
            
        }
    }
}

struct OnboardingFeaturesView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    var body: some View {
        VStack(spacing: 40) {
            Text("Get started now")
                .font(.title3)
                .foregroundStyle(.white)

            Button("Get started") {
                withAnimation {
                    isOnboarding = false
                }
            }
                .tint(.blue)
                .buttonStyle(.borderedProminent)
        }
    }
}

struct OnboardingEmpathiseView: View {
    @State private var showGaspButton = false

    @State private var showText = false

    var duration = 1.5
    var delay = 1.0

    var body: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading, spacing: 20) {
                Text("But with ADHD, you get *distracted*.")
                    .opacity(showText ? 1.0 : 0)
                    .animation(.bouncy(duration: duration), value: showText)

                Text("""
                A 20-minute routine turns into
                **an hour**.
                """)
                .opacity(showText ? 1.0 : 0)
                .animation(.bouncy(duration: duration).delay(delay * 2), value: showText)
            }
            .font(.title3)
            .foregroundStyle(.white)
            .offset(y: showText ? 0 : 20)
            .padding(.bottom, 100)

            Button {} label: {
                Text("Tap to Gasp")
                    .foregroundStyle(.white)
                    .font(.title3.bold())
                    .fontDesign(.rounded)
                    .padding()
                    .background(.orange.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .scaleEffect(showGaspButton ? 1 : 0)
                    .animation(.spring(duration: 0.4, bounce: 0.6).delay(delay * 4), value: showGaspButton)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .onAppear(perform: {
            showGaspButton = true
            showText = true
        })
    }
}

struct OnboardingChecklistView: View {
    @State private var showCellAnimation = false
    @State var listCellDelay = 1.0

    let listTextColor: Color = .white
    let backgroundListRowColor: Material = .ultraThinMaterial

    var duration = 1.5

    @State private var testAnimation = false

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

            // TODO: Maybe keep this text animation
            // TODO: Try to package all these opacity and offset into one extension for reusability
            .opacity(testAnimation ? 1.0 : 0)
            .offset(y: testAnimation ? 0 : 20)
            .animation(.bouncy(duration: 1.5), value: testAnimation)

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

            Spacer()
            Spacer()
        }
        .padding(.horizontal, 20)
        .onAppear(perform: {
            // Because onAppear might execute too early,
            // before the List view is fully initialized and ready for animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                showCellAnimation = true
            }
            testAnimation = true
        })
    }
}

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
            .onAppear(perform: {
                showText = true
            })
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingView()
}
