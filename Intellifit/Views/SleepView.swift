//
//  SleepView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/3/23.
//

import SwiftUI

struct SleepView: View {
    var body: some View {
        ZStack {
            Color.purple
            Image(systemName: "moon.fill")
                .foregroundColor(Color.white)
                .font(.system(size:100.0))
        }
    }
}

struct SleepView_Previews: PreviewProvider {
    static var previews: some View {
        SleepView()
    }
}
