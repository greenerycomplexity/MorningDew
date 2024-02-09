//
//  Task.swift
//  MorningDew
//
//  Created by Son Cao on 17/1/2024.
//

import Foundation
import SwiftData

@Model
class TaskItem {
    var name: String
    var minutes: Int
    var perceivedDifficulty: Int
    var orderIndex: Int
    var rhythm: Rhythm?
    
    var seconds : Double {
        Double(minutes) * 60
    }

    
    init(name: String, minutes: Int, perceivedDifficulty: Int = 3, orderIndex: Int, rhythm: Rhythm? = nil) {
        self.name = name
        self.minutes = minutes
        self.perceivedDifficulty = perceivedDifficulty
        self.orderIndex = orderIndex
        self.rhythm = rhythm
    }
}
