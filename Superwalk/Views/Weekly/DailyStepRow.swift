//
//  DailyStepRow.swift
//  Superwalk
//
//  Created by Ricky Kirkendall on 12/4/22.
//

import Foundation
import SwiftUI

struct DailyStepRow: View {
    private let viewModel: DailyStepViewModel
    
    init(viewModel: DailyStepViewModel) {
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
