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
    
    private var estimatedEndTime: Date {
        Calendar.current.date(byAdding: .minute, value: currentRhythm.totalMinutes, to: Date.now) ?? .now
    }
    
    @State private var showCellAnimation = false
    @State var animationDelay = 0.5

    @State private var suggestStart: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.cyan, .teal, .yellow], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            if !isActive {
                VStack {
                    // Rhythm length (in minutes)
                    // Button to add new tasks
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Time to complete")
                                .font(.title3.bold())
                                .fontDesign(.rounded)
                            
                            
                            Text("\(currentRhythm.totalMinutes) minutes")
                                .font(.largeTitle.bold())
                                .fontDesign(.rounded)
                            
                        }
                        
                        
                        Spacer()
                        
                        Button {
                            showAddTaskView = true
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                        }
                    }
                    
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
                    Text("""
                    If you start now,
                    you'll be ready by **\(estimatedEndTime.formatted(date: .omitted, time: .shortened))**
                    """)
                    .multilineTextAlignment(.center)
                    .padding()
                    .opacity(suggestStart ? 1.0 : 0)
                    .offset(y: suggestStart ? 0 : 30.0)
                    
                    
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
                .padding()
                .sheet(isPresented: $showAddTaskView) {
                    AddTaskView(currentRhythm: currentRhythm)
                }
                .toolbar {
                    if currentRhythm.tasks.count > 0 {
                        ToolbarItem(placement: .topBarTrailing) {
                            EditButton()
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
                
                // For the RhythmActiveView to show up nicely later
                .transition(.scale(.zero, anchor: .bottom))
            } else {
                RhythmActiveView(rhythm: currentRhythm)
            }
        }
    }
}

struct TaskListCell: View {
    var task: TaskItem
    
    var body: some View {
            VStack(alignment: .center) {
                Text(task.name)
                    .font(.title2.bold())
                    .fontDesign(.default)
                    .foregroundStyle(.primary)
                
                // Text("\(task.minutes) minutes")
                Text("^[\(task.minutes) minute](inflect:true)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        .padding(.vertical)
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = AppData.previewContainer
        let rhythm = AppData.rhythmExample
        container.mainContext.insert(rhythm)
        return RhythmDetailView(currentRhythm: rhythm)
            .modelContainer(container)
    }
}
