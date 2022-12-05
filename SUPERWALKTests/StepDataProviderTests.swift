//
//  StepDataProviderTests.swift
//  SUPERWALKTests
//
//  Created by Ricky Kirkendall on 12/4/22.
//

import XCTest
import Combine

struct MockStepDataProvider: StepDataProvider {
    
    var shouldFail = false
    
    func stepsDataForDaysAgo(_ days: Int) -> AnyPublisher<StepDay, StepsError> {
        let (start, _) = Date().dayStartAndEndFor(numberOfDaysAgo: days)
        
        if shouldFail {
            return Fail<StepDay, StepsError>(error: StepsError.accessDenied)
                .eraseToAnyPublisher()
        }
        return Just(StepDay(date: start!, stepCount: Int.random(in: 800...1600)))
            .setFailureType(to: StepsError.self)
            .eraseToAnyPublisher()
    }
}

/// Goal here it to test the Combine code that merges the query publishers and collects the results

final class StepDataProviderTests: XCTestCase {
    
    var cancellables = Set<AnyCancellable>()
    var mockProvider = MockStepDataProvider()

    func testAggregateLastWeeksStepsSuccess() throws {
        
        mockProvider.shouldFail = false
        mockProvider.aggregateLastWeeksSteps()
            .sink { result in
                switch result {
                case .failure(_):
                    XCTFail()
                default:
                    break
                }
            } receiveValue: { stepDays in
                XCTAssert(stepDays.count == 7)
            }
            .store(in: &cancellables)
    }
    
    func testAggregateLastWeeksStepsFailure() throws {
        mockProvider.shouldFail = true
        mockProvider.aggregateLastWeeksSteps()
            .sink { result in
                switch result {
                case .failure(let error):
                    XCTAssert(error == .accessDenied)
                default:
                    break
                }
            } receiveValue: { stepDays in
                XCTFail()
            }
            .store(in: &cancellables)
    }

}
