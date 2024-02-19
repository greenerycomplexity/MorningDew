//
//  SwiftUIView.swift
//
//
//  Created by Son Cao on 19/2/2024.
//

import SwiftUI

struct RhythmStatisticsView: View {
    @Bindable var rhythmManager: RhythmManager

    var body: some View {
        Text("Well done, you've completed your morning routine!")
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .background(.clear)
            .padding(.horizontal, 20)
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewData.container
        let rhythm = PreviewData.rhythmExample
        container.mainContext.insert(rhythm)

        return RhythmStatisticsView(rhythmManager: RhythmManager(tasks: rhythm.tasks))
            .modelContainer(container)
    }
}
