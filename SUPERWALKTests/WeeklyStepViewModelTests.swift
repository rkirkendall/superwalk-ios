//
//  SUPERWALKTests.swift
//  SUPERWALKTests
//
//  Created by Ricky Kirkendall on 12/4/22.
//

import XCTest
import Combine

@testable import SUPERWALK

class MockStepDataPublisher: StepDataPublisher {
    
    var shouldFail = false
    
    func stepsLastWeek() -> AnyPublisher<[SUPERWALK.StepDay], SUPERWALK.StepsError> {
        
        var toReturn: [StepDay] = []
        
        for days in 0...6 {
            let (start, _) = Date().dayStartAndEndFor(numberOfDaysAgo: days)
            toReturn.append(StepDay(date: start!, stepCount: Int.random(in: 800...1600)))
        }
        
        if shouldFail {
            return Fail<[StepDay], StepsError>(error: StepsError.accessDenied)
                .eraseToAnyPublisher()
        }
        return Just(toReturn)
            .setFailureType(to: StepsError.self)
            .eraseToAnyPublisher()
    }
    
    func stepsTodayUpdate() -> AnyPublisher<SUPERWALK.StepDay, SUPERWALK.StepsError> {
        if shouldFail {
            return Fail<StepDay, StepsError>(error: StepsError.accessDenied)
                .eraseToAnyPublisher()
        }
        return Just(StepDay(date: Date(), stepCount: Int.random(in: 800...1600)))
            .setFailureType(to: StepsError.self)
            .eraseToAnyPublisher()
    }
    
    
}

final class WeeklyStepViewModelTests: XCTestCase {

    func testErrorHandling() throws {
        
        let mockStepPublisher = MockStepDataPublisher()
        let weeklyStepViewModel = WeeklyStepViewModel(stepService: mockStepPublisher)
        
        weeklyStepViewModel.handleError(.accessDenied)
        
        XCTAssertNotNil(weeklyStepViewModel.error)
        XCTAssert(weeklyStepViewModel.weekDataSource.count == 0)
        XCTAssertTrue(weeklyStepViewModel.showSettingsButton)
        
        weeklyStepViewModel.handleError(.accessRestricted)
        XCTAssertFalse(weeklyStepViewModel.showSettingsButton)
                
    }

}
