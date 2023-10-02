//
//  MetricsView.swift
//  Water Submersion Watch App
//
//  Created by Ravi on 02/10/23.
//

import SwiftUI

struct MetricsView: View {
    @EnvironmentObject var workoutManager: WorkoutManager
    @StateObject private var waterSubmersionManager = WaterSubmersionManager()
    
    private var startDate: Date {
        return workoutManager.builder?.startDate ?? Date()
    }
    
    private var isPaused: Bool {
        return workoutManager.session?.state == .paused
    }
    
    var body: some View {
        ScrollView {
            TimelineView(
                MetricsTimelineSchedule(
                    from: workoutManager.builder?.startDate ?? Date(),
                    isPaused: workoutManager.session?.state == .paused
                )
            ) { context in
                VStack(alignment: .leading) {
                    let elapsedTime = workoutManager.builder?.elapsedTime(at: context.date) ?? 0
                    ElapsedTimeView(
                        elapsedTime: elapsedTime,
                        showSubseconds: context.cadence == .live
                    )
                    .foregroundStyle(.yellow)
                    
                    matrics
                }
                .font(
                    .system(.title, design: .rounded)
                    .monospacedDigit()
                    .lowercaseSmallCaps()
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .ignoresSafeArea(edges: .bottom)
                .scenePadding()
            }
        }
        .onAppear(perform: start)
    }
    
    private var matrics: some View {
        VStack(alignment: .leading) {
            MatricInfoView(
                title: "isSubmerged",
                value: waterSubmersionManager.isSubmerged.description
            )
            
            MatricInfoView(
                title: "isDiveSessionRunning",
                value: waterSubmersionManager.diveSessionRunning.description
            )
            
            MatricInfoView(
                title: "Heart Rate",
                value: "\(workoutManager.heartRate.string()) BPM"
            )
            
            MatricInfoView(
                title: "Temperature",
                value: waterSubmersionManager.temperature?.temperature.formatted() ?? "-"
            )
            
            MatricInfoView(
                title: "Depth",
                value: waterSubmersionManager.measurement?.depth?.formatted() ?? "-"
            )
            
            MatricInfoView(
                title: "Pressure",
                value: waterSubmersionManager.measurement?.pressure?.formatted() ?? "-"
            )
            
            MatricInfoView(
                title: "Surface Pressure",
                value: waterSubmersionManager.measurement?.surfacePressure.formatted() ?? "-"
            )
        }
    }
    
    private func start() {
        waterSubmersionManager.startDiveSession()
    }
}

#Preview {
    MetricsView()
        .environmentObject(WorkoutManager())
}


private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    var isPaused: Bool

    init(from startDate: Date, isPaused: Bool) {
        self.startDate = startDate
        self.isPaused = isPaused
    }

    func entries(
        from startDate: Date,
        mode: TimelineScheduleMode
    ) -> AnyIterator<Date> {
        var baseSchedule = PeriodicTimelineSchedule(
            from: self.startDate,
            by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0)
        )
        .entries(from: startDate, mode: mode)
        
        return AnyIterator<Date> {
            guard !isPaused else { return nil }
            return baseSchedule.next()
        }
    }
}
