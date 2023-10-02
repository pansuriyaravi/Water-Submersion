//
//  Logger.swift
//  Water Submersion Watch App
//
//  Created by Ravi on 02/10/23.
//

import Foundation
import os.log

extension Logger {
    init(category: String) {
        guard let bundleIdentifier = Bundle.main.bundleIdentifier else {
            fatalError("Unable to retrieve bundle identifier.")
        }
        self.init(subsystem: bundleIdentifier, category: category)
    }
}
