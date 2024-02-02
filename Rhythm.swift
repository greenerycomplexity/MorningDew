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
    var name: String = ""
    var beats = [Beat]()
    
    var totalMinutes: Int {
        var minutes = 0
        for beat in beats {
            minutes += beat.time
        }
        return minutes
    }
    
    init(name: String) {
        self.name = name
    }
}
