//
//  ElapsedTimeView.swift
//  Water Submersion Watch App
//
//  Created by Ravi on 02/10/23.
//

import SwiftUI

struct ElapsedTimeView: View {
    var elapsedTime: TimeInterval = 0
    var showSubseconds: Bool = true
    @State private var timeFormatter = ElapsedTimeFormatter()

    var body: some View {
        Text(NSNumber(value: elapsedTime), formatter: timeFormatter)
            .fontWeight(.semibold)
            .onChange(of: showSubseconds) { newValue  in
                timeFormatter.showSubseconds = newValue
            }
    }
}

#Preview {
    ElapsedTimeView()
}
