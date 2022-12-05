//
//  StepDay.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/2/22.
//

import Foundation
import CoreMotion

/// Primary model for Superwalk. Used where possiblew to wrap CMPedometer data.
public struct StepDay {
    
    let date: Date
    let stepCount: Int
    let distanceMeters: Double?
    let floorsAscended: Int?
    let floorsDescended: Int?
    
    init(){
        date = Date()
        stepCount = 0
        distanceMeters = nil
        floorsAscended = nil
        floorsDescended = nil
    }
    
    internal init(date: Date, stepCount: Int, distanceMeters: Double? = nil, floorsAscended: Int? = nil, floorsDescended: Int? = nil) {
        self.date = date
        self.stepCount = stepCount
        self.distanceMeters = distanceMeters
        self.floorsAscended = floorsAscended
        self.floorsDescended = floorsDescended
    }
    
    
    init(pedometerData: CMPedometerData) {
        date = pedometerData.startDate
        stepCount = pedometerData.numberOfSteps.intValue
        distanceMeters = pedometerData.distance?.doubleValue
        floorsAscended = pedometerData.floorsAscended?.intValue
        floorsDescended = pedometerData.floorsDescended?.intValue
    }    
}
