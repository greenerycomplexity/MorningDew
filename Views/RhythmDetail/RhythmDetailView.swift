//
//  RhythmView.swift
//  MorningDew
//
//  Created by Son Cao on 23/1/2024.
//

import SwiftData
import SwiftUI

struct RhythmDetailView: View {
    @Environment(\.modelContext) var modelContext
    @State private var showAddTaskView = false
    @Bindable var currentRhythm: Rhythm
    @State private var isActive: Bool = false
    
    // @Query var tasks: [TaskItem]
    //
    // init(currentRhythm: Rhythm) {
    //     self.currentRhythm = currentRhythm
    //     let currentRhythmID = currentRhythm.persistentModelID
    //
    //     _tasks = Query(
    //         filter: #Predicate<TaskItem> { task in
    //             task.rhythm?.persistentModelID == currentRhythmID
    //         }, sort: \TaskItem.name, order: .reverse)
    // }
    
    private var estimatedEndTime: Date {
        Calendar.current.date(byAdding: .second, value: currentRhythm.totalSeconds, to: Date.now) ?? .now
    }
    
    @State private var showCellAnimation = false
    @State var animationDelay = 0.5

    @State private var suggestStart: Bool = false
    
    var body: some View {
        ZStack {
            RadialGradient(colors: [.green, .white], center: .bottom, startRadius: .zero, endRadius: 1000)
                .ignoresSafeArea()
            
            if !isActive {
                VStack {
                    // Rhythm length (in minutes)
                    // Button to add new tasks
                    HStack {
                        Text("⏱️ \(currentRhythm.totalMinutes.clean) minutes")
                            .font(.largeTitle.bold())
                            .fontDesign(.rounded)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    // Display the tasks in list view
                    List {
                        ForEach(currentRhythm.tasks.indices, id: \.self) { index in
                            TaskListCell(task: currentRhythm.tasks[index])
                                .listRowSeparator(.hidden, edges: .all)
                                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                                .listRowBackground(Color.clear)
                            
                                // Animation
                                .opacity(showCellAnimation ? 1.0 : 0)
                                .offset(y: showCellAnimation ? 0 : 10)
                                .animation(.bouncy(duration: 0.5).delay(animationDelay * Double(index)), value: showCellAnimation)
                                .padding(.bottom)
                        }
                        .onDelete(perform: { indexSet in
                            for taskIndex in indexSet {
                                let task = currentRhythm.tasks[taskIndex]
                                modelContext.delete(task)
                            }
                        })
                        .onMove(perform: { source, destination in
                            for taskIndex in source {
                                let moveTask = currentRhythm.tasks[taskIndex]
                                
                                currentRhythm.tasks.remove(at: taskIndex)
                                
                                currentRhythm.tasks.insert(moveTask, at: destination)
                            }
                        })
                    }
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    
                    // Start Suggesstion
                    // Text("""
                    // If you start now,
                    // you'll be ready by **\(estimatedEndTime.formatted(date: .omitted, time: .shortened))**
                    // """)
                    
                    Text("""
                    Start now, 
                    and be ready by **\(estimatedEndTime.formatted(date: .omitted, time: .shortened))**
                    """)
                    .multilineTextAlignment(.center)
                    .padding()
                    .opacity(suggestStart ? 1.0 : 0)
                    .offset(y: suggestStart ? 0 : 30.0)
                    .foregroundStyle(.primary)
                    
                    if currentRhythm.tasks.count > 0 {
                        // Start the routine
                        Image(systemName: "play.circle.fill")
                            .foregroundStyle(.green)
                            .font(.system(size: 80))
                            .background(.white)
                            .clipShape(Circle())
                            .onTapGesture(perform: {
                                withAnimation {
                                    isActive = true
                                }
                            })
                    }
                }
                .navigationTitle(currentRhythm.name)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(isPresented: $showAddTaskView) {
                    AddTaskView(currentRhythm: currentRhythm)
                        .presentationDetents([.fraction(0.50)])
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add Task") {
                            showAddTaskView = true
                        }
                    }
                }
                .onAppear(perform: {
                    withAnimation(.easeIn(duration: 0.8).delay(3.5)) {
                        suggestStart = true
                    }
                    
                    // Because onAppear might execute too early,
                    // before the List view is fully initialized and ready for animation
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showCellAnimation = true
                    }
                })
            } else {
                RhythmStartView(rhythm: currentRhythm)
            }
        }
    }
}

struct TaskListCell: View {
    var task: TaskItem
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(task.name)
                    .foregroundStyle(.primary)
                    .font(.title2.bold())
                    .fontDesign(.default)
                
                if task.minutes == 1.0 {
                    Text("\(task.minutes.clean) minute")
                        .foregroundStyle(.secondary)
                } else {
                    Text("\(task.minutes.clean) minutes")
                        .foregroundStyle(.secondary)
                }
            }
            .font(.subheadline)
            .padding(.horizontal)
            
            Spacer()
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewData.container
        let rhythm = PreviewData.rhythmExample
        container.mainContext.insert(rhythm)
        return RhythmDetailView(currentRhythm: rhythm)
            .modelContainer(container)
    }
}
