//
//  CMWaterSubmersionEvent+State.swift
//  Water Submersion Watch App
//
//  Created by Ravi on 02/10/23.
//

import Foundation
import CoreMotion

extension CMWaterSubmersionEvent.State {
    var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .notSubmerged:
            return "notSubmerged"
        case .submerged:
            return "submerged"
        @unknown default:
            fatalError("*** An unknown event state: \(self)")
        }
    }
}
