//
//  DailyStepView.swift
//  SUPERWALK
//
//  Created by Ricky Kirkendall on 12/4/22.
//

import Foundation
import SwiftUI

/// "Detail view" to show additional pedometer related data for a day.
struct DailyStepView: View {
    
    @ObservedObject var viewModel: DailyStepViewModel
    
    init(viewModel: DailyStepViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        Text(viewModel.date)
            .font(.largeTitle)
            .padding()
        List {
            DailyDetailRow(key: "Steps", value: viewModel.steps)
            DailyDetailRow(key: "Distance", value: viewModel.distance)
            
            if let ascended = viewModel.floorsAscended {
                DailyDetailRow(key: "Floors ascended", value: ascended)
            }
            
            if let descended = viewModel.floorsDescended {
                DailyDetailRow(key: "Floors descended", value: descended)
            }
            
            Section {
                HStack{
                    Text("Kilometers / Miles")
                    Toggle("",isOn: Binding<Bool>(
                        get: {Settings.shared.usesMeters},
                        set: {Settings.shared.usesMeters = $0}))
                }
            }
        }
    }
}

struct DailyDetailRow: View {
    var key: String
    var value: String
    
    var body: some View {
        HStack {
            Text(key)
            Spacer()
            Text(value)
        }
    }
}
