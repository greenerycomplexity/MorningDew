//
//  OnboardingView.swift
//  MorningDew
//
//  Created by Son Cao on 13/2/2024.
//

import SwiftUI

// To be used with onChange animations,
// since multiple TabViews with onAppear becomes buggy 
// => Unreliable animations
enum OnboardingTab {
    case greeting, checklist, emphathise, features
}

struct OnboardingView: View {
    @State var activeTab: OnboardingTab = .greeting
    
   
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(colors: [.cyan, .green], startPoint: .bottomLeading, endPoint: .topTrailing)
                .ignoresSafeArea()

            // LinearGradient(colors: [.cyan, .orange], startPoint: .bottomLeading, endPoint: .topTrailing)
            //     .ignoresSafeArea()

            TabView (selection: $activeTab) {
                OnboardingGreetingView(activeTab: $activeTab, tab: .greeting)
                    .tag(OnboardingTab.greeting)

                OnboardingChecklistView(activeTab: $activeTab, tab: .checklist)
                    .tag(OnboardingTab.checklist)
                
                OnboardingEmpathiseView(activeTab: $activeTab, tab: .emphathise)
                    .tag(OnboardingTab.emphathise)
                
                OnboardingFeaturesView(activeTab: $activeTab, tab: .features)
                    .tag(OnboardingTab.features)
            }
            
            .tabViewStyle(.page)
            // .tabViewStyle(.page(indexDisplayMode: .never))
            
            
            // Button {
            //     
            // } label: {
            //     Image(systemName: "arrow.forward.circle.fill")
            //         .font(.custom("SF Pro", size: 40, relativeTo: .largeTitle))
            //         .foregroundStyle(.white)
            //         .shadow(radius: 4, x: 2, y: 3)
            //         .padding()
            //         .padding(.trailing)
            // 
            // }
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
        HStack (spacing: 20) {
            Text(icon)
                .font(.custom("SF Pro", size: 50, relativeTo: .largeTitle))
                .fontDesign(.rounded)
                .frame(width: 60, height: 80)
                .padding(.leading)
            
            VStack (alignment: .leading, spacing: 5) {
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

struct OnboardingFeaturesView: View {
    @AppStorage("isOnboarding") var isOnboarding: Bool?
    
    @Binding var activeTab: OnboardingTab
    let tab: OnboardingTab

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
                withAnimation {
                    isOnboarding = false
                }
            }
            .tint(.blue)
            .buttonStyle(.borderedProminent)
            Spacer()
        }
    }
}

struct OnboardingEmpathiseView: View {
    @State private var showGaspButton = false

    @State private var showText = false

    var textDuration = 1.5
    var delay = 1.0
    
    @Binding var activeTab: OnboardingTab
    let tab: OnboardingTab

    var body: some View {
        VStack {
            Spacer()

            VStack(alignment: .leading, spacing: 20) {
                Text("But with ADHD, you get *distracted*.")
                    .opacity(showText ? 1.0 : 0)
                    .animation(.bouncy(duration: textDuration), value: showText)

                Text("""
                A 20-minute routine turns into
                **an hour**.
                """)
                .opacity(showText ? 1.0 : 0)
                .animation(.bouncy(duration: textDuration).delay(delay * 2), value: showText)
            }
            .font(.title3)
            .foregroundStyle(.white)
            .offset(y: showText ? 0 : 20)
            .padding(.bottom, 100)

            Button {
                SoundPlayer().play(file: "gasp.wav")
            } label: {
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

struct OnboardingChecklistView: View {
    @State private var showText = false
    @State private var showCellAnimation = false
    @State var listCellDelay = 1.0

    let listTextColor: Color = .white
    let backgroundListRowColor: Material = .ultraThinMaterial

    var textDuration = 1.5
    
    @Binding var activeTab: OnboardingTab
    let tab: OnboardingTab

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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    showCellAnimation = true
                }
                showText = true
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

struct OnboardingGreetingView: View {
    @State private var showIcon = false
    @State private var showText = false

    var duration = 1.5
    var delay = 3.0
    
    @Binding var activeTab: OnboardingTab
    let tab: OnboardingTab

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
            }
        }
    }
}

#Preview {
    OnboardingView()
}
