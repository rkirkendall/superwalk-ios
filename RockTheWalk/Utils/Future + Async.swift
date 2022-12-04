//
//  Future + Async.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/4/22.
//

import Foundation
import Combine

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
