//
//  DailyStepRowViewModel.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/3/22.
//

import Foundation

struct DailyStepRowViewModel: Identifiable {
    private let item: StepDay
    
    init(item: StepDay = StepDay()) {
        self.item = item
    }
    
    var id: String {
        return date
    }
    
    var date: String {
        return dayFormatter.string(from: item.date)
    }
    
    var steps: String {
        if item.stepCount == 0 {
            return "--"
        }
        return "\(item.stepCount)"
    }
}
