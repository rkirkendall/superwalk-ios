//
//  Steps.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/1/22.
//

import Foundation
import CoreMotion
import Combine

protocol StepsFetchable {
    func stepsLastWeek() -> AnyPublisher<[StepDay], StepsError>
    func stepsTodayUpdate() -> AnyPublisher<StepDay, StepsError>
}

final class StepService {
    private let pedometer = CMPedometer()
    private var dailyStepUpdates = PassthroughSubject<StepDay, StepsError>()
}

extension StepService: StepsFetchable {
    public func stepsLastWeek() -> AnyPublisher<[StepDay], StepsError> {
        return lastWeeksSteps()
    }

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
            if let data = data { self.dailyStepUpdates.send(StepDay(pedometerData: data)) }
        }
    }

    private func stopStepUpdates() { pedometer.stopUpdates() }
}

//MARK: - Data Queries
extension StepService {
    private func lastWeeksSteps() -> AnyPublisher<[StepDay], StepsError> {
        let pubs = (0...6).map { stepsDataForDaysAgo($0) }
        return Publishers.MergeMany(pubs)
            .collect()
            .map { pedometerDataArray in
                pedometerDataArray.map { StepDay(pedometerData: $0) }
            }
            .eraseToAnyPublisher()
    }
        
    private func stepsDataForDaysAgo(_ days: Int) -> AnyPublisher<CMPedometerData, StepsError>  {
        
        let (start, end) = Date().dayStartAndEndFor(numberOfDaysAgo: days)
        guard let start = start, let end = end
        else {
            return Fail(error: StepsError.invalidQueryDateContruction).eraseToAnyPublisher()
        }
        
        return pedometer.queryPedometerData(from: start, to: end).eraseToAnyPublisher()
    }
    
    
}
