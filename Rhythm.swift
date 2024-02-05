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
    var tasks = [TaskItem]()
    var emoji: String
    
    var totalMinutes: Int {
        var minutes = 0
        for task in tasks {
            minutes += task.time
        }
        return minutes
    }
    
    init(name: String, emoji: String = AppData.defaultEmoji) {
        self.name = name
        self.emoji = emoji
    }
}
