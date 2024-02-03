import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment (\.modelContext) var modelContext
    @Query private var rhythms: [Rhythm]
    @State private var showAddRhythmView = false
    
    var body: some View {
        NavigationStack {
            List (rhythms) { rhythm in
                NavigationLink(value: rhythm) {
                    Text(rhythm.name)
                        .font(.title3.bold())
                        .fontDesign(.default)
                        .foregroundStyle(.primary)
                }
            }
            .navigationDestination(for: Rhythm.self) { rhythm in
                RhythmDetailView(currentRhythm: rhythm)
            }
            .onAppear(perform: {
                if rhythms.count == 0 {
                    let newRhythm = Rhythm(name: "Morning Routine")
                    modelContext.insert(newRhythm)
                }
            })
            
            .sheet(isPresented: $showAddRhythmView) {
                AddRhythmView()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Add Rhythm") {
                        showAddRhythmView = true
                    }
                }
            }
        }
    }
}


#Preview {
    return ContentView()
        .modelContainer(DataController.previewContainer)
}
