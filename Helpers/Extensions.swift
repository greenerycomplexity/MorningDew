//
//  Extensions.swift
//  MorningDew
//
//  Created by Son Cao on 13/2/2024.
//

import Foundation


extension Double {
    var formatted: String {
        // Check if the double value is an integer
        // Since it will display nicer
        if floor(self) == self {
            return String(Int(self))
        } else {
            return String(format: "%.1f", self)
        }
    }
}
