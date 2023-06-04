//
//  SettingsView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/3/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        ZStack {
            Color.gray
            Image(systemName: "gearshape")
                .foregroundColor(Color.white)
                .font(.system(size:100.0))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
