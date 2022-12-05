//
//  StepDay.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/2/22.
//

import Foundation
import CoreMotion

public struct StepDay {
    
    let date: Date
    let stepCount: Int
    let distanceMeters: Double?
    
    init(){
        date = Date()
        stepCount = 0
        distanceMeters = nil
    }
    
    init(date: Date, stepCount: Int, distanceMeters: Double? = nil) {
        self.date = date
        self.stepCount = stepCount
        self.distanceMeters = distanceMeters
    }
    
    
    init(pedometerData: CMPedometerData) {
        date = pedometerData.startDate
        stepCount = pedometerData.numberOfSteps.intValue
        distanceMeters = pedometerData.distance?.doubleValue
    }    
}
