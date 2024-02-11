//  StartRhythmView.swift
//
//  MorningDew
//
//  Created by Son Cao on 19/1/2024.
//

import SwiftUI
import SwiftData

struct RhythmActiveView: View {
    var rhythm: Rhythm
    @State private var rhythmManager: RhythmManager
    
    init(rhythm: Rhythm) {
        self.rhythm = rhythm
        rhythmManager = RhythmManager(tasks: rhythm.tasks)
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
    
    // Add computed property here to manage colors and such on the timerViews
    var body: some View {
        if rhythmManager.allCompleted {
            Text("You're all done!")
        } else {
            ZStack {
                //                    LinearGradient(colors: [.red,.orange,.yellow], startPoint: .top, endPoint: .bottom)
                //                        .ignoresSafeArea()
                //                    
                
                //                    LinearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom)
                //                        .ignoresSafeArea()
                //                    
                LinearGradient(colors: [.teal, .green], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
                
                
                VStack (spacing: 30) {
                    Spacer()
                    TimerView(rhythmManager: rhythmManager)
                    
                    Text(rhythmManager.currentTask.name)
                        .font(.largeTitle.bold())
                        .fontDesign(.rounded)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    HStack (alignment: .bottom, spacing: 30 ) {
                        
                        Button {
                            
                        } label: {
                            VStack {
                                Image(systemName: "speaker.slash")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(.white)
                                    .padding(15)
                                    .background(.thinMaterial)
                                    .clipShape(Circle())
                                
                                Text("Mute")
                                    .foregroundStyle(.white)
                                    .font(.headline)
                            }
                        }
                        
                        NavigationLink {
                            // Add Break view in here later
                            Text("Breathe with me for a minute!")
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
                        
                        Button {
                            rhythmManager.elapsed = true
                            rhythmManager.next()
                        } label: {
                            VStack {
                                Image(systemName: "checkmark.gobackward")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundStyle(.white)
                                    .frame(width: 30, height: 30)
                                    .padding(15)
                                    .background(.thinMaterial)
                                    .clipShape(Circle())
                                
                                Text("Done")
                                    .foregroundStyle(.white)
                                    .font(.headline)
                            }
                        }
                    }
                    Spacer()
                }
            }
            .onAppear(perform: {
                rhythmManager.next()
            })
            .navigationBarBackButtonHidden(true)
//            .transition(.scale(scale: .zero, anchor: .bottom))
            // MARK: Rhythm Actions
            // Break
            // Skip
            // Mute music
        }
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = AppData.previewContainer
        let rhythm = AppData.rhythmExample
        container.mainContext.insert(rhythm)
        
        return RhythmActiveView(rhythm: rhythm)
            .modelContainer(container)
    }
}
