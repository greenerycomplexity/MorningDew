//
//  RhythmManager.swift
//  MorningDew
//
//  Created by Son Cao on 8/2/2024.
//

import Foundation
import SwiftUI

enum RhythmState {
    case getReady
    case active
    case meditation
    case checkup
    case allCompleted
}

// Manages the entire Rhythm lifecycle once the user clicks begin
@Observable
class RhythmManager {
    private(set) var rhythm: Rhythm
    private(set) var tasksToComplete: [TaskItem]
    private(set) var rhythmStartTime: Date = .now
    private(set) var rhythmEndTime: Date = .now
    
    private(set) var currentTask: TaskItem = PreviewData.taskItemExample
    private(set) var taskEndTime: Date = .now
    private(set) var taskElapsedSeconds = 0.0
    private(set) var progress = 0.0
    private(set) var elapsed: Bool = false
    
    private(set) var meditationLength: Double = 30
    private(set) var meditationOpened: Int = 0
    private(set) var elapsedMeditationTotal: Double = 0.0
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var currentState: RhythmState = .active {
        didSet {
            // Going back from Meditation view means resetting the entire task again
            if oldValue == .meditation {
                resetTask()
            }
            
            if currentState == .meditation {
                meditationOpened += 1
            }
            
            // Either way, if going back to Active, reset the progress ring.
            if currentState == .active {
                resetProgressRing()
            }
        }
    }
    
    private var overTime: Bool {
        // If current time is later than endTime
        return Date.now >= taskEndTime
    }
    
    init(rhythm: Rhythm) {
        self.rhythm = rhythm
        self.tasksToComplete = rhythm.tasks
    }
    
    // For every new task that comes in, reset the progress ring
    func resetProgressRing() {
        taskElapsedSeconds = 0.0
        progress = 0.0
    }
    
    // Add extra time for current task when going back to ActiveView
    // For both moving back from alarm view, and meditation view
    func addExtraTime(seconds: Double) {
        taskEndTime = Date.now.addingTimeInterval(seconds)
    }
    
    // Update the end time
    func resetTask() {
        taskEndTime = Date.now.addingTimeInterval(currentTask.seconds + 1)
    }
    
    // MARK: Active Task tracker

    func nextTask() {
        elapsed = true
        if tasksToComplete.isEmpty {
            rhythmEndTime = .now
            currentState = .allCompleted
        } else {
            elapsed = false
            currentTask = tasksToComplete.remove(at: 0)
            resetTask()
            resetProgressRing()
        }
    }
    
    func trackTask() {
        if currentState == .active {
            // If this is triggered, means that user didn't manually press Next task
            // So will move into alarm view
            if overTime {
                currentState = .checkup
            } else {
                elapsed = false
                taskElapsedSeconds += 1
                progress = taskElapsedSeconds / (currentTask.seconds - 1)
            }
        }
    }
    
    // MARK: Meditation tracker

    func prepareMeditation() {
        elapsed = false
        
        addExtraTime(seconds: meditationLength)
    }
    
    func trackMeditation() {
        if overTime {
            withAnimation {
                elapsed = true
            }
        }
        elapsedMeditationTotal += 1
    }
}
