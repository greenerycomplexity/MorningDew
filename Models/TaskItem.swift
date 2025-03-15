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
    var seconds: Double
    var minutes: Double {
        Double(seconds) / 60
    }
    var perceivedDifficulty: Int
    var routine: Routine?


    init(name: String, seconds: Double, perceivedDifficulty: Int = 3, routine: Routine? = nil) {
        self.name = name
        self.seconds = seconds
        self.perceivedDifficulty = perceivedDifficulty
        self.routine = routine
    }
}
