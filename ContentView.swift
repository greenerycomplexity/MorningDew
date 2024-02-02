import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment (\.modelContext) var modelContext
    @Query private var rhythms: [Rhythm]
    
    @State private var currentRhythm: Rhythm
    @State private var showAddRhythmView = false
    
    
    init() {
        if rhythms.count == 0 {
            var newRhythm = Rhythm(name: "Morning Routine")
            modelContext.insert(newRhythm)
        }
        
        currentRhythm = rhythms[0]
    }
    var body: some View {
        NavigationStack {
            VStack {
                RhythmView(rhythm: $currentRhythm)
                // Start the routine
                NavigationLink {
                    Text("Hello")
                } label: {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 80))
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add Rhythm") {
                            showAddRhythmView = true
                        }
                    }
                    
                    ToolbarTitleMenu {
                        Picker("Routine", selection: $currentRhythm) {
                            ForEach(rhythms, id: \.self) { rhythm in
                                Text(rhythm.name)
                                    .tag(rhythm)
                            }
                        }
                    }
                }
            }
            .navigationTitle(currentRhythm.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


//#Preview {
//    let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
//    let container = ModelContainer(for: Rhythm.self, configurations: configuration)
//    let newRhythm = Rhythm(name: "Hello")
//    return ContentView(currentRhythm: newRhythm)
//    
//    ContentView()
//}
