//
//  MatricInfoView.swift
//  Water Submersion Watch App
//
//  Created by Ravi on 02/10/23.
//

import SwiftUI

struct MatricInfoView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(title)
                .font(.caption)
            Text(value)
        }
    }
}

#Preview {
    let temprature = Measurement<UnitTemperature>(value: 1, unit: .celsius)
    return MatricInfoView(
        title: "Temperature",
        value: temprature.formatted()
    )
}
