//
//  WorkoutView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/3/23.
//

import SwiftUI

struct WorkoutView: View {
    var body: some View {
        ZStack {
            Color.red
            Image(systemName: "dumbbell.fill")
                .foregroundColor(Color.white)
                .font(.system(size:100.0))
        }
    }
}

struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
