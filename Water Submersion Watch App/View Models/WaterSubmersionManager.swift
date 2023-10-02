//
//  WaterSubmersionManager.swift
//  Water Submersion Watch App
//
//  Created by Ravi on 02/10/23.
//

import Foundation
import CoreMotion
import os.log
import WatchKit

private let logger = Logger(category: "Water submersion manager")

class WaterSubmersionManager: NSObject, ObservableObject {
    @Published var events: [CMWaterSubmersionEvent] = []
    @Published var isSubmerged: Bool = false
    @Published var measurement: CMWaterSubmersionMeasurement? = nil
    @Published var temperature: CMWaterTemperature? = nil
    @Published var diveSessionRunning: Bool = false
    
    private let submersionManager = CMWaterSubmersionManager()
    private var extendedRuntimeSession: WKExtendedRuntimeSession?
    
    private var waterSubmersionAvailable: Bool {
        return CMWaterSubmersionManager.waterSubmersionAvailable
    }
    
    override init() {
        super.init()
        
        submersionManager.delegate = self
    }
    
    @MainActor
    private func add(event: CMWaterSubmersionEvent) async {
        events.append(event)
    }
    
    @MainActor
    private func set(submerged: Bool) async {
        isSubmerged = submerged
    }
    
    @MainActor
    private func set(measurement: CMWaterSubmersionMeasurement?) {
        self.measurement = measurement
    }
    
    @MainActor
    private func set(temperature: CMWaterTemperature?) {
        self.temperature = temperature
    }
    
    func startDiveSession() {
        logger.info("[WKExtendedRuntimeSession] *** Starting a dive session. ***")


        // Create the extended runtime session.
        let session = WKExtendedRuntimeSession()


        // Assign a delegate to the session.
        session.delegate = self


        // Start the session.
        session.start()


        self.extendedRuntimeSession = session
        diveSessionRunning = true
        
        logger.debug("[WKExtendedRuntimeSession] *** Dive session started. ***")
    }

}

extension WaterSubmersionManager: CMWaterSubmersionManagerDelegate {
    func manager(_ manager: CMWaterSubmersionManager, didUpdate event: CMWaterSubmersionEvent) {
        let submerged: Bool?
        switch event.state {
        case .unknown:
            logger.info("[Event] *** Received an unknown event. ***")
            submerged = nil
            
            
        case .notSubmerged:
            logger.info("[Event] *** Not Submerged Event ***")
            submerged = false
            
            
        case .submerged:
            logger.info("[Event] *** Submerged Event ***")
            submerged = true
            
            
        @unknown default:
            fatalError("[Event] *** Unknown event received: \(event.state) ***")
        }
        
        Task {
            await add(event: event)
            if let submerged = submerged, submerged == true {
                await set(submerged: submerged)
            }
        }
    }
    
    func manager(_ manager: CMWaterSubmersionManager, didUpdate measurement: CMWaterSubmersionMeasurement) {
        
        logger.info("[Measurement] *** Received a depth measurement. ***")
        
        let currentDepth: String
        if let depth = measurement.depth {
            currentDepth = depth.description
        } else {
            currentDepth = "None"
        }
        
        
        let currentSurfacePressure: String
        let surfacePressure = measurement.surfacePressure
        currentSurfacePressure = surfacePressure.description
        
        
        let currentPressure: String
        if let pressure = measurement.pressure {
            currentPressure = pressure.description
        } else {
            currentPressure = "None"
        }
        
        
        logger.info("[Measurement] *** Depth: \(currentDepth) ***")
        logger.info("[Measurement] *** Surface Pressure: \(currentSurfacePressure) ***")
        logger.info("[Measurement] *** Pressure: \(currentPressure) ***")
        
        
        let submerged: Bool?
        switch measurement.submersionState {
        case .unknown:
            logger.info("[Measurement] *** Unknown Depth ***")
            submerged = nil
        case .notSubmerged:
            logger.info("[Measurement] *** Not Submerged ***")
            submerged = false
        case .submergedShallow:
            logger.info("[Measurement] *** Shallow Depth ***")
            submerged = true
        case .submergedDeep:
            logger.info("[Measurement] *** Deep Depth ***")
            submerged = true
        case .approachingMaxDepth:
            logger.info("[Measurement] *** Approaching Max Depth ***")
            submerged = true
        case .pastMaxDepth:
            logger.info("[Measurement] *** Past Max Depth ***")
            submerged = true
        case .sensorDepthError:
            logger.info("[Measurement] *** A depth error has occurred. ***")
            submerged = nil
        @unknown default:
            fatalError("[Measurement] *** An unknown measurement depth state: \(measurement.submersionState)")
        }
        
        
        Task {
            await set(measurement: measurement)
            if let submerged = submerged, submerged == true {
                await set(submerged: submerged)
            }
        }
    }
    
    func manager(_ manager: CMWaterSubmersionManager, didUpdate measurement: CMWaterTemperature) {
        let currentTemperature = measurement.temperature.formatted()
        
        logger.info(("[Temperature] *** \(currentTemperature) ***"))
        
        Task {
            await set(temperature:measurement)
        }
    }
    
    func manager(_ manager: CMWaterSubmersionManager, errorOccurred error: Error) {
        logger.error("*** An error occurred: \(error.localizedDescription) ***")
    }
}

extension WaterSubmersionManager: WKExtendedRuntimeSessionDelegate {
    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        logger.info("[WKExtendedRuntimeSession] *** Session invalidated with reason: \(reason.rawValue) and error: \(error?.localizedDescription ?? "nil") ***")
    }
    
    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        logger.info("[WKExtendedRuntimeSession] *** Session started. ***")
    }
    
    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        logger.info("[WKExtendedRuntimeSession] *** Session will expire. ***")
    }
}
