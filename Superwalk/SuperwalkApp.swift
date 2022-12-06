//
//  SuperwalkApp.swift
//  Superwalk
//
//  Created by Ricky Kirkendall on 12/1/22.
//

import SwiftUI

@main
struct SuperwalkApp: App {
    
    let stepService: StepDataPublisher
    let allDaysViewModel: WeeklyStepViewModel
    
    init() {
        stepService = StepService()
        allDaysViewModel = WeeklyStepViewModel(stepService: stepService)
    }
    
    var body: some Scene {
        WindowGroup {
            WeeklyStepView(viewModel: allDaysViewModel)
        }
    }
}
