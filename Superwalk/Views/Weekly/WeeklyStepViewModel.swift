//
//  AllDaysViewModel.swift
//  Superwalk
//
//  Created by Ricky Kirkendall on 12/3/22.
//

import Foundation
import Combine
import SwiftUI
import UIKit

/// View model for `WeeklyStepView`. Uses a `StepDay` and a `[StepDay]` as a data sources for today's step data and the last six days step data, repsectively.
/// Populates these data sources using a service that conforms to `StepDataPublisher`.
class WeeklyStepViewModel: ObservableObject {        
    /// Populated via publishers from `stepService`.
    @Published var todayDataSource: DailyStepViewModel = DailyStepViewModel()
    /// Populated via publishers from `stepService`.
    @Published var weekDataSource: [DailyStepViewModel] = []
    
    /// Set when the user taps a`DailyStepRow` in the List
    @Published var selectedDailyStep: DailyStepViewModel = DailyStepViewModel()
    
    private let stepService: StepDataPublisher
    private var cancellables = Set<AnyCancellable>()
        
    @Published var stepServiceError: StepsError?
    
    /// Several things could go wrong fetching data from the pedometer (see StepsError for a full enumeration), though the most common is a lack of user permission.
    var error: String? {
        get {
            guard let stepServiceError = stepServiceError
            else { return nil }
            
            if case .accessDenied = stepServiceError {
                return "Please grant motion data access in Settings."
            }
            return "A problem occured accessing your step data. Please make sure this device supports step counting!"
        }
    }
    /// A flag indicating whether to show a button to link the to settings to allow Superwalk access to Motion and Fitness data. True if `.accessDenied` errors are encountered.
    var showSettingsButton: Bool {
        get {
            if let stepServiceError = stepServiceError,
               case .accessDenied = stepServiceError
            { return true }
            
            return false
        }
    }
    
    /// Initialize the view model, fetch step data for the last week, and begin listening for upates to today's step count.
    init(stepService: StepDataPublisher) {
        self.stepService = stepService
        
        fetchLastWeeksSteps()
        startUpdatingSteps()
    }
    
    func openSettings(){
        guard let url = URL(string: UIApplication.openSettingsURLString)
        else { return }
        UIApplication.shared.open(url)
    }
    
    /// Clears out the data sources in the case that an error is encountered.
    func handleError(_ error: StepsError) {
        self.weekDataSource = []
        self.todayDataSource = DailyStepViewModel()
        self.stepServiceError = error
    }
    
    /// Subscribe to `stepsLastWeek` and populate data sources once values are received.
    func fetchLastWeeksSteps () {
        stepService.stepsLastWeek()
            .map { stepDays in
                stepDays
                    .sorted {$0.date > $1.date}
                    .map { DailyStepViewModel(item:$0) }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                switch value {
                case .failure(let error):
                    self.handleError(error)
                case .finished:
                  break
                }
            } receiveValue: { [weak self] lastWeek in
                guard let self = self else { return }
                
                var lastSixDays = lastWeek
                let today = lastSixDays.removeFirst()
                
                self.todayDataSource = today
                self.weekDataSource = lastSixDays
            }
            .store(in: &cancellables)
    }
    
    /// Subscribe to `stepsTodayUpdate` and update today's data source once values are received.
    func startUpdatingSteps() {
        self.stepService.stepsTodayUpdate()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .failure(let error):
                    self.handleError(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] updatedSteps in
                guard let self = self else { return }
                self.todayDataSource = DailyStepViewModel(item: updatedSteps)
            }
            .store(in: &cancellables)
    }
}

extension WeeklyStepViewModel {
    
    /// Return content for a day's pedometer "detail view".
    func dailyStepView() -> some View {
        return DailyStepView(viewModel: selectedDailyStep)
    }
}
