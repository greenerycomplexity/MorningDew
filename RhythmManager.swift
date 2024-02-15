//
//  RhythmManager.swift
//  MorningDew
//
//  Created by Son Cao on 8/2/2024.
//

import Foundation
import SwiftUI


// Track the state and move to view, or change background color accordingly
enum RhythmState {
    case getReady
    case active
    case meditation
}

@Observable
class RhythmManager {
    var rhythmState: RhythmState = .active
    private(set) var startTime: Date = .now
    
    var tasks: [TaskItem]
    var allCompleted: Bool = false
    
    init(tasks: [TaskItem]) {
        self.tasks = tasks
    }
    
    
    var currentTask: TaskItem = PreviewData.taskItemExample
    var taskElapsedSeconds = 0.0
    var progress = 0.0
    var elapsed: Bool = false
    var taskEndTime: Date = Date.now
    
    // For every new task that comes in, reset the progress ring
    func resetProgressRing() {
        taskElapsedSeconds = 0.0
        progress = 0.0
    }
    
    func next() {
        if tasks.isEmpty {
            allCompleted = true
        } else {
            elapsed = false
            currentTask = tasks.remove(at: 0)
            taskEndTime = Date.now.addingTimeInterval(currentTask.seconds + 1)
            resetProgressRing()
        }
    }
    
    func track() {
        // If current time is later than endTime
        if Date.now >= taskEndTime {
            elapsed = true
            next()
        } else {
            elapsed = false
            taskElapsedSeconds += 1
            progress = taskElapsedSeconds / (currentTask.seconds - 1)
        }
    }
}
