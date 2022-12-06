//
//  Steps.swift
//  Superwalk
//
//  Created by Ricky Kirkendall on 12/1/22.
//

import Foundation
import CoreMotion
import Combine

/// A full implementation of `StepDataPublisher` and `StepDataProvider` that uses
/// CMPedometer as a data source.
final class StepService {
    private let pedometer = CMPedometer()
    private var dailyStepUpdates = PassthroughSubject<StepDay, StepsError>()
}

/// Describes an object that publishes weekly and current step data.
protocol StepDataPublisher {
    func stepsLastWeek() -> AnyPublisher<[StepDay], StepsError>
    func stepsTodayUpdate() -> AnyPublisher<StepDay, StepsError>
}

/// Implementation of `StepDataPublisher`.
extension StepService: StepDataPublisher {
    
    /// Publishes step data for the last week, including today.
    public func stepsLastWeek() -> AnyPublisher<[StepDay], StepsError> {
        return aggregateLastWeeksSteps()
    }

    /// Publishes the current day's step data as it updates.
    public func stepsTodayUpdate() -> AnyPublisher<StepDay, StepsError> {
        do {
            try startStepUpdates()
        } catch StepsError.stepCountUnavailable {
            dailyStepUpdates.send(completion: .failure(.stepCountUnavailable))
        } catch {}
        
        return dailyStepUpdates.eraseToAnyPublisher()
    }
}

// MARK: - Device Updates
extension StepService {    
    
    private func startStepUpdates() throws {
        guard CMPedometer.isStepCountingAvailable() else { throw StepsError.stepCountUnavailable }

        pedometer.startUpdates(from: Date().startOfDay) { data, error in
            if let error = error {
                let stepErr = StepsError.fromCMError(error)
                self.dailyStepUpdates.send(completion: .failure(stepErr))
            }
            else if let data = data { self.dailyStepUpdates.send(StepDay(pedometerData: data)) }
        }
    }

    private func stopStepUpdates() { pedometer.stopUpdates() }
}

//MARK: - Data Queries
/// Describes an object that retrieves daily step data from a source
protocol StepDataProvider {
    func stepsDataForDaysAgo(_ days: Int) -> AnyPublisher<StepDay, StepsError>
}

extension StepDataProvider {
    
    /// Aggregates daily step data across multiple days and pushes them throuh a unified publisher.
    func aggregateLastWeeksSteps() -> AnyPublisher<[StepDay], StepsError> {
        
        // Create an array of publishers for the last 7 days, inclusive of today
        let pubs = (0...6).map { stepsDataForDaysAgo($0) }
        return Publishers.MergeMany(pubs)
            .collect()
            .eraseToAnyPublisher()
    }
}

extension StepService: StepDataProvider {
    
    /// Retrieves step data for a given number of days in the past.
    /// - Parameters:
    ///      - days: Number of days ago from current date to retrieve daily step data.
    /// - Returns: A pushlisher that will publish the daily step data.
    internal func stepsDataForDaysAgo(_ days: Int) -> AnyPublisher<StepDay, StepsError> {
        
        // To query a full day's worth of step data, we need to compute the start and end times of the day
        let (start, end) = Date().dayStartAndEndFor(numberOfDaysAgo: days)
        guard let start = start, let end = end
        else {
            return Fail(error: StepsError.invalidQueryDateContruction).eraseToAnyPublisher()
        }
        
        return pedometer.queryPedometerData(from: start, to: end)
            .map { cmPedometerdata in
                // Map CMPedometerData to our StepDay struct
                StepDay(pedometerData: cmPedometerdata)
            }
            .eraseToAnyPublisher()
    }
    
    
}
