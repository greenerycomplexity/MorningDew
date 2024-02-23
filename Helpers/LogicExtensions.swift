//
//  Extensions.swift
//  MorningDew
//
//  Created by Son Cao on 13/2/2024.
//

import Foundation
import SwiftUI

extension Double {
    var clean: String {
        // Check if the double value is an integer
        // Since it will display nicer
        if floor(self) == self {
            return String(Int(self))
        } else {
            return String(format: "%.1f", self)
        }
    }
}

func delay(seconds: Double, _ perform: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds ) {
        perform()
    }
}
