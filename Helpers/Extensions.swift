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

func makeColor(_ red: Double, _ green: Double, _ blue: Double) -> Color {
    Color(red: red/255, green: green/255, blue: blue/255)
}

extension View {
    func moveAndFade(showAnimation: Bool, duration: Double = 1.0, delay: Double = 0.0) -> some View {
        self
            .opacity(showAnimation ? 1.0 : 0)
            .offset(y: showAnimation ? 0 : 10)
            .animation(.bouncy(duration: duration).delay(delay), value: showAnimation)
    }
}

// Showing and hiding the view without moving other views around
// struct IsShown: ViewModifier {
//     var shown = false
//
//     func body(content: Content) -> some View {
//         if shown {
//             content
//         } else {
//             content.hidden()
//         }
//     }
// }
//
// extension View {
//     func isShown(shown: Bool) -> some View {
//         modifier(
//             IsShown(shown: shown)
//         )
//     }
// }
