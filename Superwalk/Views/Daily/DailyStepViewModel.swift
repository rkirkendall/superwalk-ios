//
//  DailyStepRowViewModel.swift
//  Superwalk
//
//  Created by Ricky Kirkendall on 12/3/22.
//

import Foundation
import SwiftUI
import Combine

let dayFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "EEEE, MMM d"    
    return df
}()

let shortDayFormatter: DateFormatter = {
    let df = DateFormatter()
    df.dateFormat = "MM/dd"
    return df
}()

/// View model used for `DailyStepView` and `DailyStepRow`. Takes a `StepDay` as a data source.
class DailyStepViewModel: Identifiable, ObservableObject {
    
    /// Published to allow for updates if the user toggles Mi / Km
    @Published var distance: String = "--"
    
    var id: UUID
    var date: String
    var shortDate: String
    var steps: String
    var stepsInt: Int
    var floorsAscended: String? = nil
    var floorsDescended: String? = nil
    
    private let item: StepDay
    private var cancellables = Set<AnyCancellable>()

    
    init(item: StepDay = StepDay()) {
        self.item = item
        self.date = dayFormatter.string(from: item.date)
        self.shortDate = shortDayFormatter.string(from: item.date)
        self.id = UUID()
        
        self.stepsInt = item.stepCount
        
        if item.stepCount == 0 {
            self.steps = "--"
        } else {
            self.steps = "\(item.stepCount)"
        }
        
        if let descended = item.floorsDescended {
            self.floorsDescended = String(descended)
        }
        
        if let ascended = item.floorsAscended {
            self.floorsAscended = String(ascended)
        }
        
        Settings.shared.$usesMeters
            .sink { [weak self] usesMeters in
                guard let self = self else { return }
                self.updateDistanceLabel(usesMeters)
            }
            .store(in: &cancellables)
    }
    
    func updateDistanceLabel(_ usesMeters: Bool) {
        guard let distanceM = item.distanceMeters
        else {
            self.distance = "Not available"
            return
        }
        
        let mToKm = 0.001
        let mtoMi = 0.000621371
        
        if usesMeters {
            let km = distanceM * mToKm
            self.distance = String(format: "%.2f km", km)
        } else {
            let mi = distanceM * mtoMi
            self.distance = String(format: "%.2f mi", mi)
        }
    }
}
