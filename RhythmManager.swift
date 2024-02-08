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
    private var endTime: Date
    
    init() {
        self.rhythmState = .getReady
        self.startTime = .now
        
        // This is meant to be overwritten when the last task is finished
        self.endTime = .now
    }
    
   
//    var elapsedTime: Date {
//        let diffComponents = Calendar.current.dateComponents([.minute, .second], from: startTime, to: Date.now)
//        
//        if let date = Calendar.current.date(from: diffComponents) {
//            return date
//        } else {
//            return Date.now
//        }
//    }
}
