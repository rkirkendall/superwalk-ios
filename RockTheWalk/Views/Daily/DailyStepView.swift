//
//  DailyStepView.swift
//  SUPERWALK
//
//  Created by Ricky Kirkendall on 12/4/22.
//

import Foundation
import SwiftUI

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
            
            Section {
                HStack{
                    Text("Units")
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
