//
//  HKUnit+heartRateUnit.swift
//  Water Submersion Watch App
//
//  Created by Ravi on 02/10/23.
//

import Foundation
import HealthKit

extension HKUnit {
    static let heartRateUnit = HKUnit.count().unitDivided(by: HKUnit.minute())
}
