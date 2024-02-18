//
//  SwiftUIView.swift
//
//
//  Created by Son Cao on 18/2/2024.
//

import SwiftUI

struct MeditationView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var numberOfPetals: Double = 1
    @State private var isMinimized = false
    @State private var animationDuration = 1.5
    @State private var breatheDuration = 5.5
             
    @State private var startBloom = false
    @State private var showLotus = false
    
    // Timer to keep updating the number of petals for smooth transition
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .indigo], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                LotusView(isMinimized: $isMinimized,
                          numberOfPetals: $numberOfPetals,
                          duration: $animationDuration)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 30)
                    .opacity(showLotus ? 1 : 0)
                    .offset(y: showLotus ? 0 : 30)
                
                    .onReceive(timer, perform: { _ in
                        if startBloom {
                            numberOfPetals += 0.5
                            if numberOfPetals >= 7.0 {
                                timer.upstream.connect().cancel()
                            
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    animationDuration = breatheDuration
                                    isMinimized.toggle()
                                }
                            }
                        }
                    })
                    .onAppear(perform: {
                        let deadline = DispatchTime.now()

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            withAnimation (.easeInOut(duration: 1.0)) {
                                showLotus = true
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: deadline + 2.5) {
                            startBloom = true
                        }
                    })
                
                Spacer()
                Spacer()
                
                Button {
                    dismiss()
                    
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(.white)
                        .frame(width: 30, height: 30)
                        .padding(20)
                        .background(.white.opacity(0.4))
                        .clipShape(Circle())
                        .padding(.bottom)
                }
                
            }
        }
    }
}

#Preview {
    MeditationView()
}
