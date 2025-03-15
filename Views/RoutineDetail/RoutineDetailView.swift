//
//  RoutineView.swift
//  MorningDew
//
//  Created by Son Cao on 23/1/2024.
//

import SwiftData
import SwiftUI
import TipKit

struct AddTaskTip: Tip {
    var title: Text = .init("Add a new Task here")
    var message: Text? = Text("Try to give your best estimates!")
}

struct RoutineDetailView: View {
    @Environment(\.modelContext) var modelContext
    @State private var showAddTaskView = false
    @Bindable var currentRoutine: Routine
    @State private var isActive: Bool = false
    @Query var tasks: [TaskItem]
    
    init(currentRoutine: Routine) {
        self.currentRoutine = currentRoutine
        let currentRoutineID = currentRoutine.persistentModelID
    
        _tasks = Query(
            filter: #Predicate<TaskItem> { task in
                task.routine?.persistentModelID == currentRoutineID
            })
    }
    
    // Total time has to be calculated here based on the tasks @Query,
    // instead of grabbing it from Bindable currentRoutine object.
    // Else time won't be updated on post-edit (e.g deletion or modification)
    private var totalMinutes: Double {
        var minutes: Double = 0
        for task in tasks {
            minutes += task.minutes
        }
        return minutes
    }
    
    private var estimatedEndTime: Date {
        Calendar.current.date(byAdding: .second, value: currentRoutine.totalSeconds, to: Date.now) ?? .now
    }
    
    @State private var showCellAnimation = false
    @State var animationDelay = 0.5

    @State private var suggestStart: Bool = false
    @Environment(\.dismiss) var dismiss
    
    let archGradient =
        LinearGradient(colors: [.purple, .pink, .yellow], startPoint: .leading, endPoint: .trailing)
    let circleHeight: CGFloat = 300
    
    var body: some View {
        ZStack {
            Color.offBlack.ignoresSafeArea()
            if !isActive {
                VStack {
                    // MARK: Colored Gradient Ring + Time estimates

                    // Display the tasks in list view
                    List {
                        Section {
                            ZStack(alignment: .bottom) {
                                Circle()
                                    .trim(from: 0.0, to: 0.5)
                                    .stroke(archGradient, style: StrokeStyle(lineWidth: 7))
                                    .rotationEffect(.degrees(180))
                                    .frame(height: circleHeight)
                                    .frame(height: circleHeight / 2)
                                    .offset(y: circleHeight / 4)
                                    .padding(.top)

                                VStack(spacing: 10) {
                                    Text("\(totalMinutes.clean) minutes")
                                        .font(.largeTitle.bold())
                                        .fontWidth(.condensed)
                                    
                                    // Start suggestion
                                    Text(
                                        "Start now, and be ready by **\(estimatedEndTime.formatted(date: .omitted, time: .shortened))**")
                                }
                                .foregroundStyle(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.offBlack)
                        }
                        
                        ForEach(tasks.indices, id: \.self) { index in
                            TaskListCell(task: currentRoutine.tasks[index])
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
                                let task = currentRoutine.tasks[taskIndex]
                                modelContext.delete(task)
                            }
                        })
                    }
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    
                    if currentRoutine.tasks.count > 0 {
                        Button("Start Routine") {
                            withAnimation {
                                isActive = true
                            }
                        }
                        .buttonStyle(GradientButton(gradient: .buttonGradient))
                        .padding(.horizontal, 20)
                    }
                }
                .sheet(isPresented: $showAddTaskView) {
                    AddTaskView(currentRoutine: currentRoutine)
                        .presentationDetents([.fraction(0.5), .large])
                        .presentationDragIndicator(.visible)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showAddTaskView = true
                        } label: {
                            ZStack {
                                LinearGradient.buttonGradient
                                Color.white.opacity(0.5)
                            }.mask {
                                Image(systemName: "plus.circle.fill")
                            }
                            .frame(width: 40, height: 40)
                        }
                        .popoverTip(AddTaskTip())
                    }
                }
                .navigationTitle("\(currentRoutine.name) \(currentRoutine.emoji)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
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
                RoutineStartView(routine: currentRoutine)
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
                    .font(.title3.bold())
                    .foregroundStyle(.white)
                
                Text(task.seconds.detailed)
                    .foregroundStyle(.white.opacity(0.8))
                    .font(.subheadline)
            }
            .padding(.horizontal)
            Spacer()
        }
        .padding(.vertical)
        .frame(maxWidth: .infinity)
        .background(Color.offBlackHighlight)
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

#Preview {
    MainActor.assumeIsolated {
        let container = PreviewData.container
        let routine = PreviewData.routineExample
        container.mainContext.insert(routine)
        return RoutineDetailView(currentRoutine: routine)
            .modelContainer(container)
    }
}
