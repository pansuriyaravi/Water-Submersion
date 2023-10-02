//
//  ContentView.swift
//  Water Submersion Watch App
//
//  Created by Ravi on 02/10/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var workoutManager = WorkoutManager()
    
    @State private var toMatrics: Bool = false
    
    var body: some View {
        NavigationStack {
            Button("Start", action: onStart)
                .navigationDestination(isPresented: $toMatrics) {
                    MetricsView()
                }
        }
        .environmentObject(workoutManager)
        .onAppear(perform: workoutManager.requestAuthorization)
    }
    
    func onStart() {
        workoutManager.selectedWorkout = .waterSports
        toMatrics = true
    }
}

#Preview {
    ContentView()
}
