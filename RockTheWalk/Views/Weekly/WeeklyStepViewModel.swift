//
//  AllDaysViewModel.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/3/22.
//

import Foundation
import Combine
import SwiftUI
import UIKit

class WeeklyStepViewModel: ObservableObject {        
    
    @Published var todayDataSource: DailyStepViewModel = DailyStepViewModel()
    @Published var weekDataSource: [DailyStepViewModel] = []
    
    private let stepService: StepsFetchable
    private var cancellables = Set<AnyCancellable>()
    
    @Published var stepServiceError: StepsError?
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
    
    var showSettingsButton: Bool {
        get {
            if let stepServiceError = stepServiceError,
               case .accessDenied = stepServiceError
            { return true }
            
            return false
        }
    }
    
    init(stepService: StepsFetchable) {
        self.stepService = stepService
        
        fetchLastWeeksSteps()
        startUpdatingSteps()
    }
    
    func openSettings(){
        guard let url = URL(string: UIApplication.openSettingsURLString)
        else { return }
        UIApplication.shared.open(url)
    }
    
    func handleError(_ error: StepsError) {
        self.weekDataSource = []
        self.todayDataSource = DailyStepViewModel()
        self.stepServiceError = error
    }
    
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
    func dailyStepView (dailyStepViewModel: DailyStepViewModel) -> some View {
        return DailyStepView(viewModel: dailyStepViewModel)
    }
}
