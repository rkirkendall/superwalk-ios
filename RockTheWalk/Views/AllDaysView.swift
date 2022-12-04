//
//  AllDaysView.swift
//  RockTheWalk
//
//  Created by Ricky Kirkendall on 12/1/22.
//

import SwiftUI

struct AllDaysView: View {
    
    @State var stepsLastSixDays = [StepDay]()
    let steps = StepService()
    
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
        
        VStack {
            Image(systemName: "figure.walk")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            .padding()
            Button("Get data") {
                steps.lastWeeksSteps()
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
