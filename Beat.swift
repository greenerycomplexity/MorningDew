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
    var time: Int
    var perceivedDifficulty: Int
    var orderIndex: Int
    var rhythm: Rhythm?

    
    init(name: String, time: Int, perceivedDifficulty: Int, orderIndex: Int, rhythm: Rhythm? = nil) {
        self.name = name
        self.time = time
        self.perceivedDifficulty = perceivedDifficulty
        self.orderIndex = orderIndex
        self.rhythm = rhythm
    }
}
