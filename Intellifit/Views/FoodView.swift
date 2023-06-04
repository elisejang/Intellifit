//
//  FoodView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/3/23.
//

import SwiftUI

struct FoodView: View {
    var body: some View {
        ZStack {
            Color.green
            Image(systemName: "fork.knife")
                .foregroundColor(Color.white)
                .font(.system(size:100.0))
        }
    }
}

struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView()
    }
}
