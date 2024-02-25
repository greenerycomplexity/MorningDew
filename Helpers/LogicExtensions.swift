//
//  Extensions.swift
//  MorningDew
//
//  Created by Son Cao on 13/2/2024.
//

import Foundation
import SwiftUI

extension Double {
    // MARK: Return a rounded down value for minutes Double values. Displays better.

    var clean: String {
        return String(Int(self.rounded(.down)))
    }

    // MARK: Return a detailed minute and second string from a Seconds Double value

    // When not used directly in a Text view, the return type must be LocalizedStringKey for the inflection engine to work
    var detailed: LocalizedStringKey {
        let minutes = Int(self / 60)
        let remainingSeconds = Int(self) % 60

        if minutes > 0 {
            if remainingSeconds > 0 {
                return "^[\(minutes) minute](inflect: true) and ^[\(remainingSeconds) second](inflect: true)"
            } else {
                return "^[\(minutes) minute](inflect: true)"
            }
        } else {
            return "^[\(remainingSeconds) second](inflect: true)"
        }
    }

    func roundTo(nearest: Double) -> Double {
        (self / nearest).rounded() * nearest
    }
}

func delay(seconds: Double, _ perform: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        perform()
    }
}
