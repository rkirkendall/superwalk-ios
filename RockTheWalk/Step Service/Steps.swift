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
    func stepsLastWeek() -> AnyPublisher<StepWeek, StepsError>
    func stepsTodayUpdate() -> AnyPublisher<StepDay, StepsError>
}

final class StepService {
    private static let pedometer = CMPedometer()
}

extension StepService: StepsFetchable {
    func stepsLastWeek() -> AnyPublisher<StepWeek, StepsError> {
        do {
            let stepWeek = await StepService.lastWeeksSteps()
        }
    }
    
    func stepsTodayUpdate() -> AnyPublisher<StepDay, StepsError> {
        <#code#>
    }
}

// MARK: - Device Updates
extension StepService {
    public static func startStepUpdates() throws {
        try isStepCountingAvailable()
        
        pedometer.startUpdates(from: Date().startOfDay) { data, error in
            if let data = data { todayStepsUpdated.send(StepDay(pedometerData: data)) }
        }
    }
    
    public static func stopStepUpdates() { pedometer.stopUpdates() }
}

//MARK: - Data Queries
extension StepService {
    
    static func lastWeeksSteps() async throws -> StepWeek {
        var weekData: [StepDay] = []
    
        for i in 0...6 {
            // Should always build array in order. No need to sort.
            await weekData.append(StepDay(pedometerData: try stepsDataForDaysAgo(i)))
        }
        
        return StepWeek(days: weekData)
    }
        
    static func stepsDataForDaysAgo(_ days: Int) -> AnyPublisher<CMPedometerData, StepsError>  {
        
        // Handle any error that could come from attempting to access the pedometer data
        do {
            try isDataAccessAvailable()
            try isStepCountingAvailable()
        } catch let error as StepsError {
            return Fail(error: error).eraseToAnyPublisher()
        } catch { /* For compiler, not used. */ }
        
        
        let (start, end) = Date().dayStartAndEndFor(numberOfDaysAgo: days)
        guard let start = start, let end = end
        else {
            return Fail(error: StepsError.invalidQueryDateContruction).eraseToAnyPublisher()
        }
        
        pedometer.queryPedometerData(from: start, to: end) { data, error in
            if let error = error {
                return Fail(error: StepsError.queryError(description: error.localizedDescription)).eraseToAnyPublisher()
            }

            if let data = data {
//                data
            }
        }
    }
    
    func queryPedometerData(from start: Date, to end: Date) -> Future <CMPedometerData, Error> {
        pedometer.queryPedometerData(from: start, to: end) { data, error in
            return Future() 
        }
    }
}
