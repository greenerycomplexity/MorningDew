//
//  SwiftUIView.swift
//
//
//  Created by Son Cao on 18/2/2024.
//

import SwiftUI

struct MeditationView: View {
    @Bindable var rhythmManager: RhythmManager
    
    @State private var numberOfPetals: Double = 1
    @State private var isMinimized = false
    @State private var breatheDuration = 5.5
             
    @State private var startBloom = false
    @State private var showLotus = false
    
    @State private var nowBreathing = false
    @State private var showInstruction = false
    @State private var instruction = "Get ready"

    // Timer to keep updating the number of petals for smooth transition
    let bloomTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    private func breathe() {
        isMinimized = true
        
        delay(seconds: breatheDuration) {
            isMinimized = false
        }
        
        delay(seconds: breatheDuration * 2) {
            breathe()
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .indigo], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                LotusView(isMinimized: $isMinimized,
                          numberOfPetals: $numberOfPetals,
                          breatheDuration: $breatheDuration)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .opacity(showLotus ? 1 : 0)
                    .onReceive(bloomTimer, perform: { _ in
                        if startBloom {
                            numberOfPetals += 0.5
                            if numberOfPetals >= 7.0 {
                                bloomTimer.upstream.connect().cancel()
                                
                                // Minimize the Lotus, prepare for breathing
                                delay(seconds: 2.0) {
                                    isMinimized = true
                                    
                                    // Actually start breathing, change to appropriate instruction Text
                                    delay(seconds: breatheDuration / 3) {
                                        nowBreathing = true
                                        breathe()
                                    }
                                }
                            }
                        }
                    })
                    .onAppear(perform: {
                        // Show first sign of the lotus (single circle)
                        delay(seconds: 2.0) {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                showLotus = true
                            }
                        }
                        
                        // Start adding more petals to the lotus
                        delay(seconds: 3.5) {
                            startBloom = true
                        }
                    })
                
                Spacer()
                
                Text(instruction)
                    .foregroundStyle(.white)
                    .font(.headline)
                    .moveAndFade(showAnimation: showInstruction, delay: 1.0)
                    .transition(.opacity)
                    .animation(.spring, value: instruction)
                    .onAppear {
                        showInstruction = true
                        
                        delay(seconds: breatheDuration * 1.5) {
                            instruction = "Stay still"
                        }
                    }
                    .onChange(of: isMinimized) {
                        if nowBreathing {
                            if isMinimized {
                                instruction = "Strong exhale"
                                    
                            } else {
                                instruction = "Deep inhale"
                            }
                        }
                    }
                
                Spacer()
                
                Button {
                    withAnimation {
                        rhythmManager.rhythmState = .active
                    }
                    
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .padding(20)
                        .background(.white.opacity(0.4))
                        .clipShape(Circle())
                        .padding(.bottom)
                }
            }
        }
        .transition(.opacity)
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewData.container
        let rhythm = PreviewData.rhythmExample
        container.mainContext.insert(rhythm)
        
        return MeditationView(rhythmManager: RhythmManager(tasks: rhythm.tasks))
            .modelContainer(container)
    }
}
