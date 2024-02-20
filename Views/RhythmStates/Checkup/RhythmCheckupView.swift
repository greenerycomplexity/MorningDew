//
//  SwiftUIView.swift
//
//
//  Created by Son Cao on 20/2/2024.
//

import SwiftUI

struct RhythmCheckupView: View {
    @Bindable var rhythmManager: RhythmManager
    @State private var timeRemaining = 7
    @State private var showAlert = false
    
    @State var alarmTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func resetTimer() {
        musicPlayer?.stop()
        alarmTimer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        timeRemaining = 10
    }
    
    let extraTimeAllotment: Double = 15
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.teal, .green], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 10) {
                Spacer()
                Text("Have you completed")
                    .font(.headline)
                
                Text("\(rhythmManager.currentTask.name)?")
                    .font(.largeTitle.bold())
                    .fontDesign(.rounded)
                    .foregroundStyle(.white)
                
                Text("Alarm incoming: \(timeRemaining)")
                    .foregroundStyle(.white)
                    .onReceive(alarmTimer, perform: { _ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        } else {
                            alarmTimer.upstream.connect().cancel()
                            MusicPlayer().play(file: "alarm.wav", volume: 1.0)
                            showAlert = true
                        }
                    })
                    .alert("No Response Alarm", isPresented: $showAlert) {
                        Button("Okay", role: .cancel) {
                            resetTimer()
                        }
                    } message: {
                        Text("Don't get distracted!")
                    }
                
                Spacer()
                
                VStack(spacing: 20) {
                    // MARK: Go to next task

                    Button {
                        rhythmManager.nextTask()
                        rhythmManager.currentState = .active
                    } label: {
                        Text("Yes")
                            .foregroundStyle(.white)
                            .font(.title3.bold())
                            .fontDesign(.rounded)
                            .frame(minWidth: 100)
                            .padding()
                            .background(.orange.gradient)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    
                    // MARK: Go back to current task but add 30s
                    Button {
                        // Add extra time, then go back to current task
                        rhythmManager.addExtraTime(seconds: extraTimeAllotment)
                        rhythmManager.currentState = .active
                    } label: {
                        Text("I need more time (+\(extraTimeAllotment.formatted())s)")
                            .foregroundStyle(.white)
                            .font(.headline.bold())
                            .fontDesign(.rounded)
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
                
                Spacer()
            }
            .foregroundStyle(.white)
        }
        .transition(.opacity)
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewData.container
        let rhythm = PreviewData.rhythmExample
        container.mainContext.insert(rhythm)
        
        return RhythmCheckupView(rhythmManager: RhythmManager(tasks: rhythm.tasks))
            .modelContainer(container)
    }
}
