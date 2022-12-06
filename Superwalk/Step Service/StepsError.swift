//
//  StepsError.swift
//  Superwalk
//
//  Created by Ricky Kirkendall on 12/3/22.
//

import Foundation
import CoreMotion

public enum StepsError: Error {
    case invalidQueryDateContruction    
    case accessDenied
    case accessRestricted
    case unknownAccessIssue
    case stepCountUnavailable
    case stepEventsUnavailable
    
    static func fromCMError(_ error: Error) -> StepsError {
        let CMErrorDomainCodeNotAuthorized: Int = 105
        
        if let nserror = error as NSError? {
            if nserror.code == CMErrorDomainCodeNotAuthorized {
                return .accessDenied
            }
        }
        
        // Doesn't matter much for our purposes
        return .unknownAccessIssue
    }
}
