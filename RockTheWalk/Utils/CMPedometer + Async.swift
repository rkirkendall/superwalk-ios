//
//  CMPedometer + Async.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/3/22.
//

import Foundation
import CoreMotion
import Combine


///Goal of this file is to modernize the CMPedometer query API so it will work nicely with
///Combine, which we will be using in the rest of the app.
///
///One complicating factor is that the closure for the `queryPedometerData` callback
///is non-escaping, so we cannot return a future from within it. My work around is to
///convert the function to async using continuations, and then create a future using tasks
///to handle the await call.

// Adapted from
// https://tanaschita.com/20220822-bridge-async-await-to-combine-future/
extension Future where Failure == StepsError {
    convenience init(asyncFunc: @escaping () async throws -> Output) {
        self.init { promise in
            Task {
                do {
                    let result = try await asyncFunc()
                    promise(.success(result))
                } catch {
                    if let stepsError = error as? StepsError {
                        promise(.failure(stepsError))
                    } else {
                        promise(.failure(StepsError.unknownAccessIssue))
                    }
                }
            }
        }
    }
}

extension CMPedometer {
    
    public func queryPedometerData(from start: Date, to end: Date) -> Future<CMPedometerData, StepsError> {
        return Future(asyncFunc: {
            try await self.queryPedometerData(from: start, to: end)            
        })
    }
    
    private func queryPedometerData(from start: Date, to end: Date) async throws -> CMPedometerData {
        
        guard CMPedometer.isStepCountingAvailable() else { throw StepsError.stepCountUnavailable }
        switch CMPedometer.authorizationStatus() {
        case .restricted:
            throw StepsError.accessRestricted
        case .denied:
            throw StepsError.accessDenied
        default:
            break
        }
        
        return try await withCheckedThrowingContinuation({ continuation in
            queryPedometerData(from: start, to: end) { data, error in
                if let error = error {
                    continuation.resume(throwing: StepsError.queryError(description: error.localizedDescription))
                }
                
                if let data = data { continuation.resume(returning: data) }
            }
        })
    }
}
