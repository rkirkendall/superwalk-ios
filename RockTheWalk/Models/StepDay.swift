//
//  StepDay.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/2/22.
//

import Foundation
import CoreMotion

public struct StepWeek {
    let days: [StepDay]
}

public struct StepDay {
    let date: Date
    let stepCount: Int
    let distanceMeters: Double?
    
    init(pedometerData: CMPedometerData) {
        date = pedometerData.startDate
        stepCount = pedometerData.numberOfSteps.intValue
        distanceMeters = pedometerData.distance?.doubleValue
    }
    
    var displayDate: String {
        get {
            let df = DateFormatter()
            df.dateFormat = "EEEE, MMM d"
            return df.string(from: date)
        }
    }
}
