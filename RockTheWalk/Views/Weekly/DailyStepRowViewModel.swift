//
//  DailyStepRowViewModel.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/3/22.
//

import Foundation

let dayFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "EEEE, MMM d"    
    return df
}()

struct DailyStepRowViewModel: Identifiable {
    private let item: StepDay
    init(item: StepDay = StepDay()) {
        self.item = item
        self.date = dayFormatter.string(from: item.date)
        self.id = UUID()
        if item.stepCount == 0 {
            self.steps = "--"
        } else {
            self.steps = "\(item.stepCount)"
        }
    }
    
    var id: UUID
    var date: String
    var steps: String
}
