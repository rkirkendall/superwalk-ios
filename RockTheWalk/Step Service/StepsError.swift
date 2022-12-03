//
//  StepsError.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/3/22.
//

import Foundation
import CoreMotion

public enum StepsError: Error {
    case invalidQueryDateContruction
    case queryError(description: String)
    case accessDenied
    case accessRestricted
    case unknownAccessIssue
    case stepCountUnavailable
    case stepEventsUnavailable
}

extension StepService {
    public static func isDataAccessAvailable() throws {
        switch CMPedometer.authorizationStatus() {
        case .restricted:
            throw StepsError.accessRestricted
        case .denied:
            throw StepsError.accessDenied
        default:
            return
        }
    }
    
    public static func isStepCountingAvailable() throws {
        guard CMPedometer.isStepCountingAvailable() else { throw StepsError.stepCountUnavailable }
    }
    public static func isPedometerEventTrackingAvailable() throws {
        guard CMPedometer.isPedometerEventTrackingAvailable() else { throw StepsError.stepEventsUnavailable }
    }
}
