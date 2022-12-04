//
//  AllDaysViewModel.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/3/22.
//

import Foundation
import Combine

class WeeklyStepViewModel: ObservableObject {
    
    @Published var todayDataSource: DailyStepRowViewModel = DailyStepRowViewModel()
    @Published var weekDataSource: [DailyStepRowViewModel] = []
    
    private let stepService: StepsFetchable
    private var cancellables = Set<AnyCancellable>()
    
    init(stepService: StepsFetchable) {
        self.stepService = stepService
        
        fetchLastWeeksSteps()
        startUpdatingSteps()
    }
    
    func fetchLastWeeksSteps () {
        stepService.stepsLastWeek()
            .map { stepDays in
                stepDays
                    .sorted {$0.date > $1.date}
                    .map { DailyStepRowViewModel(item:$0) }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                switch value {
                    case .failure:
                        self.weekDataSource = []
                        self.todayDataSource = DailyStepRowViewModel()
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
            .sink { result in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] updatedSteps in
                guard let self = self else { return }
                self.todayDataSource = DailyStepRowViewModel(item: updatedSteps)
            }
            .store(in: &cancellables)
    }
}
