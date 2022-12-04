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
            List(viewModel.weekDataSource) { rowViewModel in
                DailyStepRow(viewModel: rowViewModel)
            }
        }
    }
}

struct DailyStepRow: View {
    private let viewModel: DailyStepRowViewModel
    
    init(viewModel: DailyStepRowViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            Text(viewModel.date)
            Spacer()
            Text(viewModel.steps)
        }
    }
}
