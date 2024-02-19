//  StartRhythmView.swift
//
//  MorningDew
//
//  Created by Son Cao on 19/1/2024.
//

import SwiftData
import SwiftUI

struct RhythmActiveView: View {
    var rhythm: Rhythm
    @State private var rhythmManager: RhythmManager
    
    init(rhythm: Rhythm) {
        self.rhythm = rhythm
        rhythmManager = RhythmManager(tasks: rhythm.tasks)
    }
    
    @State private var soundMuted: Bool = false {
        didSet {
            if soundMuted {
                musicPlayer?.volume = 0.0
            } else {
                musicPlayer?.volume = 1.0
            }
        }
    }
    
    // TODO: Use this to change background color based on RhythmState
    var backgroundColor: Color {
        switch rhythmManager.rhythmState {
        case .getReady:
            return .orange
        case .active:
            return .green
        case .meditation:
            return .blue
        }
    }
    
    var body: some View {
        if rhythmManager.allCompleted {
            Text("You're all done!")
        }
        else if rhythmManager.rhythmState == .active {
            ZStack {
                LinearGradient(colors: [.teal, .green], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    Spacer()
                    TimerView(rhythmManager: rhythmManager)
                    
                    Text(rhythmManager.currentTask.name)
                        .font(.largeTitle.bold())
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    HStack(alignment: .bottom, spacing: 30) {
                        VStack {
                            Button {
                                soundMuted.toggle()
                            } label: {
                                Image(systemName: "speaker.slash")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(soundMuted ? .red : .white)
                                    .padding(15)
                                    .background(soundMuted ? .white : .white.opacity(0.4))
                                    .clipShape(Circle())
                            }
                            Text("Mute")
                                .foregroundStyle(.white)
                                .font(.headline)
                        }
                        
                        Button {
                            withAnimation {
                                rhythmManager.rhythmState = .meditation
                            }
                        } label: {
                            VStack {
                                Image(.lotus)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60)
                                    .padding()
                                    .background(.black.opacity(0.7).gradient)
                                    .clipShape(Circle())
                                
                                Text("Breathe")
                                    .foregroundStyle(.white)
                                    .font(.headline)
                            }
                        }
                        
                        VStack {
                            Button {
                                rhythmManager.elapsed = true
                                SoundPlayer().play(file: "taskFinished.wav")
                                rhythmManager.next()
                            } label: {
                                Image(systemName: "checkmark.gobackward")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .frame(width: 30, height: 30)
                                    .padding(15)
                                    .background(.white.opacity(0.4))
                                    .clipShape(Circle())
                            }
                            
                            Text("Done")
                                .foregroundStyle(.white)
                                .font(.headline)
                        }
                    }
                    Spacer()
                }
            }
            .onAppear(perform: {
                rhythmManager.next()
                MusicPlayer().play(file: "electro.wav", volume: 0.1)
                musicPlayer?.setVolume(1.0, fadeDuration: 5)
            })
            .navigationBarBackButtonHidden(true)
            .transition(.opacity)
        }
        
        else if rhythmManager.rhythmState == .meditation{
            MeditationView(rhythmManager: rhythmManager)
                .navigationBarBackButtonHidden(true)
        }
        
        else {
            EmptyView()
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewData.container
        let rhythm = PreviewData.rhythmExample
        container.mainContext.insert(rhythm)
        
        return RhythmActiveView(rhythm: rhythm)
            .modelContainer(container)
    }
}
