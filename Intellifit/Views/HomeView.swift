//
//  HomeView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/3/23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.blue
            Image(systemName: "house.fill")
                .foregroundColor(Color.white)
                .font(.system(size:100.0))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
