//
//  SUPERWALKTests.swift
//  SUPERWALKTests
//
//  Created by Ricky Kirkendall on 12/4/22.
//

import XCTest
import Combine

class MockStepDataPublisher: StepDataPublisher {
    
    var shouldFail = false
    
    var mockDailyUpdates = PassthroughSubject<StepDay, StepsError>()
    
    func stepsLastWeek() -> AnyPublisher<[StepDay], StepsError> {
        
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
    
    func stepsTodayUpdate() -> AnyPublisher<StepDay, StepsError> {
        return self.mockDailyUpdates
            .eraseToAnyPublisher()
    }
    
    func sendTodayUpdate(_ stepCount: Int) {
        if shouldFail {
            mockDailyUpdates.send(completion: .failure(.stepCountUnavailable))
        } else {
            mockDailyUpdates.send(StepDay(date: Date(), stepCount: stepCount))
        }
    }
    
}

final class WeeklyStepViewModelTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()

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
    
    func testStartUpdatingStepsSuccess() {
        let mockStepPublisher = MockStepDataPublisher()
        let weeklyStepViewModel = WeeklyStepViewModel(stepService: mockStepPublisher)
        
        mockStepPublisher.sendTodayUpdate(100)
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for n seconds")], timeout: 1.0)
        
        XCTAssert(weeklyStepViewModel.todayDataSource.steps == "100")
    }
    
    func testStartUpdatingStepsFailure() {
        let mockStepPublisher = MockStepDataPublisher()
        mockStepPublisher.shouldFail = true
        let weeklyStepViewModel = WeeklyStepViewModel(stepService: mockStepPublisher)
        
        mockStepPublisher.sendTodayUpdate(100)
        _ = XCTWaiter.wait(for: [expectation(description: "Wait for n seconds")], timeout: 1.0)
        
        XCTAssert(weeklyStepViewModel.todayDataSource.steps == "--")
    }

}
