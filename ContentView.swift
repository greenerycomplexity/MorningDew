import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment (\.modelContext) var modelContext
    @Query private var rhythms: [Rhythm]
    @State private var showAddRhythmView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(colors: [.green, .teal], center: .bottom, startRadius: .zero, endRadius: 500)
                    .ignoresSafeArea()
                
                
                VStack {
                    
                    HStack (alignment: .bottom) {
                        Image("dawn")
                            .resizable()
                            .scaledToFit()
                            .containerRelativeFrame(.horizontal) { width, axis in
                                width * 0.1
                            }
                        
                        Text(AppData.name)
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                            .fontDesign(.monospaced)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    VStack (spacing: 0) {
                        HStack {
                            Text("Your rhythms")
                                .font(.largeTitle.bold())
                                .fontDesign(.rounded)
                                .foregroundStyle(.white)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        List {
                            ForEach(rhythms) { rhythm in
                                NavigationLink(value: rhythm) {
                                    HStack (spacing: 10) {
                                        Text("🌻")
                                            .font(.title)
                                        
                                        Text(rhythm.name)
                                            .font(.title3.bold())
                                            .fontDesign(.default)
                                            .foregroundStyle(.primary)
                                        
                                        Spacer()
                                        
                                        VStack {
                                            Text("\(rhythm.totalMinutes)")
                                                .font(.title2.bold())
                                                .fontWeight(.heavy)
                                            
                                            Text ("minutes")
                                                .font(.subheadline)
                                            
                                        }
                                        .padding(.trailing,3)
                                        .foregroundStyle(.black)
                                        .fontDesign(.rounded)
                                    }
                                }
                                
                            }
                            .onDelete(perform: { indexSet in
                                for rhythmIndex in indexSet {
                                    let rhythm = rhythms[rhythmIndex]
                                    modelContext.delete(rhythm)
                                }
                            })
                            
                            Section {} footer: {
                                Button {
                                    showAddRhythmView = true
                                } label: {
                                    HStack {
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Image(systemName: "plus.circle")
                                                .font(.title3)
                                            
                                            Text("Add Rhythm..")
                                                .font(.headline)
                                                .fontDesign(.rounded)
                                        }
                                        .padding(10)
                                        .background(.white)
                                        .clipShape(Capsule())
                                        
                                        Spacer()
                                    }
                                }
                            }
                            
                            
                            //                        Button {
                            //
                            //                        } label: {
                            //                            HStack {
                            //                                Image(systemName: "plus.circle")
                            //                                    .font(.title3)
                            //
                            //                                Text("Add more")
                            //                                    .font(.headline)
                            //                                    .fontDesign(.rounded)
                            //                            }
                            //                        }
                            
                            
                        }
                        .scrollContentBackground(.hidden)
                        .navigationDestination(for: Rhythm.self) { rhythm in
                            RhythmDetailView(currentRhythm: rhythm)
                        }
                        
                        .onAppear(perform: {
                            if rhythms.count == 0 {
                                let newRhythm = Rhythm(name: "Morning")
                                modelContext.insert(newRhythm)
                            }
                        })
                        
                        .sheet(isPresented: $showAddRhythmView) {
                            AddRhythmView()
                        }
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
