//
//  Rhythm.swift
//  MorningDew
//
//  Created by Son Cao on 18/1/2024.
//

import Foundation
import SwiftData

@Model
class Rhythm {
    var name: String
    var tasks: [TaskItem]
    var emoji: String
    
    var totalMinutes: Int {
        var total = 0
        for task in tasks {
            total += task.minutes
        }
        return total
    }
    
    init(name: String, tasks: [TaskItem] = [TaskItem](), emoji: String = AppData.defaultEmoji) {
        self.name = name
        self.tasks = tasks
        self.emoji = emoji
    }
}

