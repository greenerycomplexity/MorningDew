import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query private var routines: [Routine]
    @State private var showAddRoutineView = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                RadialGradient(colors: [.green, .teal], center: .bottom, startRadius: .zero, endRadius: 500)
                    .ignoresSafeArea()
                
                VStack {
                    HStack {
                        Text("Your Routines")
                            .font(.title.bold())
                            .fontWidth(.expanded)
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    List {
                        ForEach(routines) { routine in
                            NavigationLink(value: routine) {
                                HStack(spacing: 10) {
                                    Text(routine.emoji)
                                        .font(.title)
                                    
                                    Text(routine.name)
                                        .font(.title3.bold())
                                        .fontDesign(.default)
                                        .foregroundStyle(.primary)
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text("\(routine.totalMinutes.clean)")
                                            .font(.title2.bold())
                                        
                                        Text("minutes")
                                            .font(.subheadline)
                                    }
                                    .padding(.trailing, 3)
                                    .foregroundStyle(.primary)
                                    .fontDesign(.rounded)
                                }
                            }
                            // This is needed since SwiftUI row sometimes would stay highlighted after exiting from other views
                            .listRowBackground(Color(.systemBackground))
                        }
                        .onDelete(perform: { indexSet in
                            for routineIndex in indexSet {
                                let routine = routines[routineIndex]
                                modelContext.delete(routine)
                            }
                        })
                        
                        Section {} footer: {
                            Button {
                                showAddRoutineView = true
                            } label: {
                                HStack {
                                    Spacer()
                                    HStack {
                                        Text("Add Routine")
                                            .font(.headline)
                                            .foregroundStyle(.black)
                                            .fontDesign(.rounded)
                                            .padding(.leading)
                                            
                                        Image(systemName: "plus")
                                            .font(.headline)
                                            .foregroundStyle(.green)
                                    }
                                    .padding(10)
                                    .background(.white)
                                    .clipShape(Capsule())
                                    Spacer()
                                }
                            }
                            .sheet(isPresented: $showAddRoutineView) {
                                AddRoutineView()
                                    .presentationDetents([.fraction(0.65), .large])
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .navigationDestination(for: Routine.self) { routine in
                        RoutineDetailView(currentRoutine: routine)
                    }
                    .onAppear(perform: {
                        if routines.count == 0 {
                            let newRoutine = Routine(name: "Morning")
                            modelContext.insert(newRoutine)
                        }
                    })
                    
                    Button("Reset Onboarding") {
                        @AppStorage("isOnboarding") var isOnboarding: Bool?
                        
                        isOnboarding = true
                    }
                    .foregroundStyle(.white)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(alignment: .bottom) {
                        Image("dawn")
                            .resizable()
                            .scaledToFit()
                        
                        Text(AppData.name)
                            .font(.title3.bold())
                            .foregroundStyle(.white)
                            .fontDesign(.monospaced)
                        
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(PreviewData.container)
}
