//
//  ViewExtensions.swift
//
//
//  Created by Son Cao on 21/2/2024.
//

import Foundation
import SwiftUI


// MARK: Custom colors
struct CustomColor {
    static func makeColor(_ red: Double, _ green: Double, _ blue: Double) -> Color {
        Color(red: red/255, green: green/255, blue: blue/255)
    }
}

extension ShapeStyle where Self == Color {
    static var offBlack: Color {
        CustomColor.makeColor(32, 32, 32)
    }
    
    static var offBlackHighlight: Color {
        CustomColor.makeColor(68, 68, 68)
    }
}


// MARK: Gradients for buttons
extension ShapeStyle where Self == LinearGradient {
    static var buttonGradient: LinearGradient {
        .init(colors: [.teal, .green], startPoint: .leading, endPoint: .trailing)
    }
}

struct GradientButton: ButtonStyle {
    var gradient: LinearGradient
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundStyle(.black)
            .padding()
            .frame(maxWidth: .infinity, maxHeight: 60)
            .background(.white.opacity(0.5))
            .background(gradient)
            .clipShape(Capsule())
    }
}

// MARK: Off black highlight frame to stand out from darker backgrounds
struct OffBlackHighlightFrame: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.offBlackHighlight)
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    // MARK: Fade in from bottom animation
    func moveAndFade(showAnimation: Bool, duration: Double = 1.0, delay: Double = 0.0) -> some View {
        self
            .opacity(showAnimation ? 1.0 : 0)
            .offset(y: showAnimation ? 0 : 10)
            .animation(.bouncy(duration: duration).delay(delay), value: showAnimation)
    }
    
    func charcoalFrame() -> some View {
        modifier(OffBlackHighlightFrame())
    }
}

