//
//  RockTheWalkApp.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/1/22.
//

import SwiftUI

@main
struct RockTheWalkApp: App {
    
    let stepService: StepsFetchable
    let allDaysViewModel: AllDaysView.AllDaysViewModel
    
    init() {
        stepService = StepService()
        allDaysViewModel = AllDaysView.AllDaysViewModel(stepService: stepService)
    }
    
    var body: some Scene {
        WindowGroup {
            AllDaysView(viewModel: allDaysViewModel)
        }
    }
}
