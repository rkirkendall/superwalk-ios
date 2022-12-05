//
//  AllDaysView.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/1/22.
//

import SwiftUI
import Charts

struct WeeklyStepView: View {
    
    @ObservedObject var viewModel: WeeklyStepViewModel
    
    init(viewModel: WeeklyStepViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "figure.walk")
                        .imageScale(.large)
                        .foregroundColor(.accentColor)
                    Text("SUPERWALK")
                        .font(.largeTitle)
                        .bold()
                        .tracking(5)
                }
                
                VStack {
                    Text(viewModel.todayDataSource.steps)
                        .font(.system(size:60))
                        .bold()
                        .tracking(5)
                    Text("Steps Today")
                        .bold()
                }
                .padding([.bottom], 20)
                .padding([.top], -20)
                
                HStack {
                    Text("LAST WEEK")
                        .tracking(3)
                        .bold()
                        .padding([.leading])
                    Spacer()
                }
                Chart {
                    ForEach(viewModel.weekDataSource) { dailySteps in
                        BarMark(
                            x: .value("Day", dailySteps.shortDate),
                            y: .value("Step Count", dailySteps.stepsInt)
                        )
                    }
                }
                .padding()
                .frame(height: 200)
                
                errorSection
                
                List(viewModel.weekDataSource) { rowViewModel in
                    NavigationLink (
                        destination: {
                            viewModel.dailyStepView(dailyStepViewModel: rowViewModel)
                            
                        }, label: {
                            DailyStepRow(viewModel: rowViewModel)
                    })
                }
                .scrollContentBackground(.hidden)
            }
        }
        .navigationBarTitleDisplayMode(.large)
    }
}

private extension WeeklyStepView {
    var errorSection: some View {
        VStack {
            if let error = viewModel.error {
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
