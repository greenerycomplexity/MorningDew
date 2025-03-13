//
//  AnimatedText.swift
//  MorningDew
//
//  Created by Son Cao on 13/3/2025.
//

import SwiftUI

struct AnimatedText: View {
    let text: String
    @Binding var moveGradient: Bool
    var moveDuration: Double = 2
    
    var body: some View {
        let screenWidth = UIScreen.main.bounds.width
        
        Rectangle()
            .overlay{
                LinearGradient(colors: [.clear, .white, .clear], startPoint: .leading, endPoint: .trailing)
                    .offset(x: moveGradient ? -screenWidth/2 : screenWidth/2)
                    .frame(width: 50, height: 100)
            }
            .animation(.linear(duration: moveDuration).repeatForever(autoreverses: false), value: moveGradient)
            .mask {
                
                HStack {
                        
                    Text(text)
                    Image(systemName: "arrow.backward")
                }
            }
            .frame(height: 100)
        
    }
}
#Preview {
    AnimatedText(text: "Slide to continue", moveGradient: .constant(true))
}
 
