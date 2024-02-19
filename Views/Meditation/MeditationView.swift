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
    
    @State private var instruction = "Get Ready..."
    @State private var showInstruction = false
    
    @State private var nowBreathing = false
    
    // Timer to keep updating the number of petals for smooth transition
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
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
                    // .offset(y: showLotus ? 0 : 30)
                    .onReceive(timer, perform: { _ in
                        if startBloom {
                            numberOfPetals += 0.5
                            if numberOfPetals >= 7.0 {
                                timer.upstream.connect().cancel()
                                
                                delay(seconds: 2.0) {
                                    isMinimized.toggle()
                                }
                            }
                        }
                    })
                    .onAppear(perform: {
                        let deadline = DispatchTime.now()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeInOut(duration: 1.0)) {
                                showLotus = true
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: deadline + 3.5) {
                            startBloom = true
                        }
                    })
                
                Spacer()
                
                Text(instruction)
                    .foregroundStyle(.white)
                    .font(.headline)
                    .moveAndFade(showAnimation: showInstruction, delay: 1.0)
                    .animation(.spring, value: instruction)
                    .onAppear {
                        showInstruction = true
                    }
                    // .onChange(of: isMinimized) {
                    //         if isMinimized {
                    //             instruction = "Strong exhale..."
                    //         }
                    //     
                    //         else if !isMinimized {
                    //             instruction = "Deep inhale..."
                    //         }
                    // }
                
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
        .onAppear {
            MusicPlayer().play(file: "forest.wav", volume: 0.2)
        }
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
