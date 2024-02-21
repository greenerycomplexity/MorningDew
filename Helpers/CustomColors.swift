//
//  File.swift
//
//
//  Created by Son Cao on 21/2/2024.
//

import Foundation
import SwiftUI

struct CustomColor {
    static var offBlackBackground: Color {
        makeColor(32, 32, 32)
    }
}

extension ShapeStyle where Self == Color {
    static var offBlackBackground: Color {
        CustomColor.offBlackBackground
    }

}
