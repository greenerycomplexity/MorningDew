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
    private(set) var rhythmState: RhythmState
    private(set) var startTime: Date = .now
    
    var tasks: [TaskItem]
    var allCompleted: Bool = false
    
    init(tasks: [TaskItem]) {
        self.rhythmState = .active
        self.tasks = tasks
    }
    
    
    var currentTask: TaskItem = AppData.taskItemExample
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
            currentTask = tasks.remove(at: 0)
            taskEndTime = Date.now.addingTimeInterval(Double(currentTask.minutes) * 60 + 1)
            elapsed = false
            resetProgressRing()
        }
    }
}
