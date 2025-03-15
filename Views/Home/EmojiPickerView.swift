//
//  EmojiPickerView.swift
//
//  Created by Son Cao on 05/02/2024
//

import SwiftUI

struct EmojiPickerView: View {
    @Binding var chosenEmoji: String
    @Environment(\.dismiss) var dismiss
    
    private let emojiUnicodeRanges = [
        0x1F300...0x1F5FF, // Misc Symbols and Pictographs
        0x1F680...0x1F6FF, // Transport and Map
        0x1F600...0x1F64F, // Emoticons
    ]
    private var emojis = [String]()
    
    init(chosenEmoji: Binding<String>) {
        for range in emojiUnicodeRanges {
            for emoji in range {
                guard let scalar = UnicodeScalar(emoji) else { continue }
                emojis.append(String(scalar))
            }
        }
        self._chosenEmoji = chosenEmoji
    }
    
    private let gridLayout = [
        GridItem(.flexible(minimum: 70)),
        GridItem(.flexible(minimum: 70)),
        GridItem(.flexible(minimum: 70)),
        GridItem(.flexible(minimum: 70)),
    ]
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            VStack {
                Text("Choose an icon for your Routine")
                    .font(.headline)
                    .foregroundStyle(.white)
                
                ScrollView {
                    LazyVGrid(columns: gridLayout) {
                        ForEach(emojis, id: \.self) { emoji in
                            Text(emoji)
                                .font(.system(size: 45))
                                .frame(minWidth: 80, minHeight: 80)
                                .background(.white.opacity(0.2))
                                .clipShape(.rect(cornerRadius: 15))
                                .onTapGesture {
                                    chosenEmoji = emoji
                                    dismiss()
                                }
                                .padding(.bottom, 2)
                        }
                    }
                    .padding()
                }
            }
            .padding(.top, 30)
        }
    }
}

#Preview {
    @State var emoji = "🚀"
    return EmojiPickerView(chosenEmoji: $emoji)
}
