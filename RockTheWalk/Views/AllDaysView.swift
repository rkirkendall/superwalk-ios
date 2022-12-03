//
//  AllDaysView.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/1/22.
//

import SwiftUI

struct AllDaysView: View {
    
    @State var stepsLastSixDays = [StepDay]()
    
    var body: some View {
        
        NavigationStack {
            List(stepsLastSixDays, id:\.date) { stepDay in
                HStack {
                    Text(stepDay.displayDate)
                    Spacer()
                    Text(String(stepDay.stepCount))
                }
            }
        }
        .task {
            do {
                stepsLastSixDays = try await StepService.lastSixDays()
            } catch {
                print(error)
            }
        }
        
        VStack {
            Image(systemName: "figure.walk")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            .padding()
            Button("Start Updating") {
                try? StepService.startStepUpdates()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AllDaysView()
    }
}
