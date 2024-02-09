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
    private(set) var startTime: Date
    
    var tasks: [TaskItem]
    var currentTask: TaskItem
    var elapsed: Bool = false
    var allCompleted: Bool = false
    
    init(tasks: [TaskItem]) {
        self.rhythmState = .active
        self.startTime = .now
        self.tasks = tasks
        
        currentTask = tasks[0]
        self.tasks.remove(at: 0)
    }
    
    func next() {
        if tasks.isEmpty {
            allCompleted = true
        } else {
            currentTask = tasks.remove(at: 0)
            elapsed = false
        }
    }
}
