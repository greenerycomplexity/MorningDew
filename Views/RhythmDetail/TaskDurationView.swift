//
//  SwiftUIView.swift
//
//
//  Created by Son Cao on 21/2/2024.
//

import SwiftUI

struct TaskDurationView: View {
    @Binding var minutes: Int
    @Binding var seconds: Int
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color.offBlack.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 15) {
                Text("Duration")
                    .font(.title.bold())
                
                Text("Select how long this Task should last.")
                
                TimePickerView(minutes: $minutes, seconds: $seconds)
                    .padding(.vertical, 10)
                
                Button {
                    dismiss()
                } label: {
                    Text("Confirm")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding()
                        .frame(width: 150, height: 50)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .stroke(.buttonGradient, lineWidth: 3)
                        )
                }
            }
            .foregroundStyle(.white)
        }
    }
}

struct TimePickerView: View {
    @Binding var minutes: Int
    @Binding var seconds: Int
    
    let maxMinutes = 29
    let maxSeconds = 59

    var body: some View {
        ZStack {
            HStack(spacing: 30) {
                HStack(spacing: 0) {
                    Picker("select minutes", selection: $minutes) {
                        ForEach(0...maxMinutes, id: \.self) { minute in
                            Text("\(minute)")
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: 150)
                    .clipped()
                    
                    Text("minutes")
                        .font(.subheadline.bold())
                }
                
                HStack(spacing: 0) {
                    Picker("select seconds", selection: $seconds) {
                        ForEach(0...maxSeconds, id: \.self) { seconds in
                            Text("\(seconds)")
                                .foregroundStyle(.white)
                        }
                    }
                    .frame(height: 150)
                    .clipped()
                    
                    Text("seconds")
                        .font(.subheadline.bold())
                }
            }
            
            .pickerStyle(.wheel)
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    TaskDurationView(minutes: .constant(0), seconds: .constant(15))
}
