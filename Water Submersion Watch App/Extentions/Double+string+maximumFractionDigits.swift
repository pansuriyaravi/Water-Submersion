//
//  string+maximumFractionDigits.swift
//  Water Submersion Watch App
//
//  Created by Ravi on 02/10/23.
//

import Foundation

extension Double {
    func string(maximumFractionDigits: Int = 1) -> String {
        let s = String(format: "%.\(maximumFractionDigits)f", self)
        for i in stride(from: 0, to: -maximumFractionDigits, by: -1) {
            if s[s.index(s.endIndex, offsetBy: i - 1)] != "0" {
                return String(s[..<s.index(s.endIndex, offsetBy: i)])
            }
        }
        return String(s[..<s.index(s.endIndex, offsetBy: -maximumFractionDigits - 1)])
    }
}
