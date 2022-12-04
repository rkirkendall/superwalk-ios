//
//  AllDaysView.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/1/22.
//

import SwiftUI

struct AllDaysView: View {
    
    @ObservedObject var viewModel: AllDaysViewModel
    
    init(viewModel: AllDaysViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            Text(viewModel.todayViewModel.date)
                .font(.largeTitle)
                .padding()
            HStack {
                Image(systemName: "figure.walk")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                .padding()
                Text(viewModel.todayViewModel.steps)
                    .font(.title2)
                Text("Steps taken today")
                    .font(.title2)
            }
            List(viewModel.weekRowsViewModel) { row in
                HStack {
                    Text(row.date)
                    Spacer()
                    Text(row.steps)
                }
            }
        }
    }
}
