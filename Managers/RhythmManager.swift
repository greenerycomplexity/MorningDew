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
    case allCompleted
}

@Observable
class RhythmManager {
    var currentState: RhythmState = .active
    private(set) var startTime: Date = .now
    
    var tasks: [TaskItem]
    var currentTask: TaskItem = PreviewData.taskItemExample
    var taskElapsedSeconds = 0.0
    var progress = 0.0
    var elapsed: Bool = false
    var taskEndTime: Date = Date.now
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    init(tasks: [TaskItem]) {
        self.tasks = tasks
    }
    
    // For every new task that comes in, reset the progress ring
    func resetProgressRing() {
        taskElapsedSeconds = 0.0
        progress = 0.0
    }
    
    func next() {
        if tasks.isEmpty {
            currentState = .allCompleted
        } else {
            elapsed = false
            currentTask = tasks.remove(at: 0)
            taskEndTime = Date.now.addingTimeInterval(currentTask.seconds + 1)
            resetProgressRing()
        }
    }
    
    func prepareMeditation() {
        elapsed = false
        taskEndTime = Date.now.addingTimeInterval(20)
    }
    
    func trackMeditation() {
        if Date.now >= taskEndTime {
            withAnimation {
                elapsed = true
            }
        }
    }
    
    func track() {
        // If current time is later than endTime
        if currentState == .active {
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
}
