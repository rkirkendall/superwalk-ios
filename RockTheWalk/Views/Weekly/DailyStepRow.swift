//
//  DailyStepRow.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/4/22.
//

import Foundation
import SwiftUI

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
