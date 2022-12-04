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
}

extension StepService: StepsFetchable {
    func stepsLastWeek() -> AnyPublisher<[StepDay], StepsError> {
        return lastWeeksSteps()
    }

    func stepsTodayUpdate() -> AnyPublisher<StepDay, StepsError> {
        <#code#>
    }
}

// MARK: - Device Updates
extension StepService {
    public func startStepUpdates() throws {
        try isStepCountingAvailable()

        pedometer.startUpdates(from: Date().startOfDay) { data, error in
            if let data = data { todayStepsUpdated.send(StepDay(pedometerData: data)) }
        }
    }

    public func stopStepUpdates() { pedometer.stopUpdates() }
}

//MARK: - Data Queries
extension StepService {
    
    func lastWeeksSteps() -> AnyPublisher<[StepDay], StepsError> {
        let pubs = (0...6).map { stepsDataForDaysAgo($0) }
        return Publishers.MergeMany(pubs)
            .collect()
            .map { pedometerDataArray in
                pedometerDataArray.map { StepDay(pedometerData: $0) }
            }
            .eraseToAnyPublisher()
    }
        
    func stepsDataForDaysAgo(_ days: Int) -> AnyPublisher<CMPedometerData, StepsError>  {
        
        let (start, end) = Date().dayStartAndEndFor(numberOfDaysAgo: days)
        guard let start = start, let end = end
        else {
            return Fail(error: StepsError.invalidQueryDateContruction).eraseToAnyPublisher()
        }
        
        return pedometer.queryPedometerData(from: start, to: end).eraseToAnyPublisher()
    }
    
    
}
