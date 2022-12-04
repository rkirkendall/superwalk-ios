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
