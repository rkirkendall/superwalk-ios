//
//  AllDaysView.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/1/22.
//

import SwiftUI

struct WeeklyStepView: View {
    
    @ObservedObject var viewModel: WeeklyStepViewModel
    
    init(viewModel: WeeklyStepViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(viewModel.todayDataSource.date)
                    .font(.largeTitle)
                    .padding()
                HStack {
                    Image(systemName: "figure.walk")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    .padding()
                    Text(viewModel.todayDataSource.steps)
                        .font(.title2)
                    Text("Steps taken today")
                        .font(.title2)
                }
                
                errorSection
                
                List(viewModel.weekDataSource) { rowViewModel in
                    DailyStepRow(viewModel: rowViewModel)
                }
            }
        }
    }
}

private extension WeeklyStepView {
    var errorSection: some View {
        Section {
            if let error = viewModel.error {
                VStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)                    
                    Text(error)
                        .multilineTextAlignment(.center)
                        .padding()
                    if(viewModel.showSettingsButton) {
                        Button("Open Settings") {
                            viewModel.openSettings()
                        }
                    }
                }
            }
        }
    }
}
