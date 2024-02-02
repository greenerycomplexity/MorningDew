import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment (\.modelContext) var modelContext
    @Query private var rhythms: [Rhythm]
    @State private var showAddRhythmView = false
    @State private var showAddTaskView = false
    @State private var currentRhythm = Rhythm(name: "Morning Routine")
    
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Total")
                        .font(.title3.bold())
                        .fontDesign(.rounded)
                    
                    Spacer()
                }
                HStack {
                    Text("\(currentRhythm.totalMinutes) minutes")
                        .font(.largeTitle.bold())
                        .fontDesign(.rounded)
                    
                    
                    Spacer()
                    
                    Button {
                        showAddTaskView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.green)
                    }
                }
                
                RhythmListView(rhythm: currentRhythm)
                
                // Start the routine
                NavigationLink {
                    Text("Hello")
                } label: {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 80))
                }
                
            }
            .navigationTitle(currentRhythm.name)
            .navigationBarTitleDisplayMode(.inline)
            .padding(.vertical)
            .padding(.horizontal)
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
                
                if currentRhythm.tasks.count > 0 {
                    ToolbarItem(placement: .topBarTrailing) {
                        EditButton()
                    }
                }
                
            }
            .onAppear(perform: {
                if rhythms.count == 0 {
                    let newRhythm = Rhythm(name: "Morning Routine")
                    modelContext.insert(newRhythm)
                }
                
                //            currentRhythm = rhythms[0]
            })
            .sheet(isPresented: $showAddTaskView) {
                AddTaskView()
            }
            .sheet(isPresented: $showAddRhythmView) {
                AddRhythmView()
            }
        }
    }
}


#Preview {
    do {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Rhythm.self, configurations: configuration)
        
        let rhythms = [
            Rhythm(name: "Morning"),
            Rhythm(name: "Night"),
            Rhythm(name: "Workday")
        ]
        
        for item in rhythms {
            container.mainContext.insert(item)
        }
        
        return ContentView()
            .modelContainer(container)
    } catch {
        fatalError("Failed to create container")
    }
}
