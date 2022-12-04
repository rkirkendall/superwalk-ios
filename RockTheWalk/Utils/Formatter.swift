//
//  Formatter.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/3/22.
//

import Foundation

let dayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d"
    return formatter
}()
