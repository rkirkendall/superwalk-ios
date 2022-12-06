//
//  Settings.swift
//  SUPERWALK
//
//  Created by Ricky Kirkendall on 12/4/22.
//

import Foundation
import Combine
import MediaPlayer

class Settings: ObservableObject {
    static let shared = Settings()
    
    @Published var usesMeters: Bool = true
}
