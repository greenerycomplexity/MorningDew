import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment (\.modelContext) var modelContext
    @Query private var rhythms: [Rhythm]
    @State private var showAddRhythmView = false
    
    var body: some View {
        NavigationStack {
            Text("Let's get started!")
            
            
            
            
            
            
            
            
            List (rhythms) { rhythm in
                NavigationLink(value: rhythm) {
                    
                    HStack {
                        Text(rhythm.name)
                            .font(.title3.bold())
                            .fontDesign(.default)
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        VStack {
                            Text("\(rhythm.totalMinutes)")
                                .font(.title2.bold())
                                .fontWeight(.heavy)
                                .foregroundStyle(.black)
                            
                            Text ("minutes")
                                .font(.subheadline)
                                .foregroundStyle(.black)
                        }
                        .padding(.trailing,3)
                        .foregroundStyle(.white)
                        .fontDesign(.rounded)
                        
                    }
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
