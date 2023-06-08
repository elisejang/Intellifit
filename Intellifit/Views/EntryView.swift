//
//  EntryView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/5/23.
//

import SwiftUI

struct EntryView: View {
    @State private var isActive : Bool = false
    @State private var size = 0.0
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            VStack {
                VStack {
                    Image("Logo")
                        .font(.system(size: 6))
                    Text("IntelliFit")
                        .font(.custom("Avenir", size: 100)).fontWeight(.bold)
                        .foregroundColor(Color("Color 4").opacity(0.80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.2
                        self.opacity = 1.00
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
            .fullScreenCover(isPresented: $isActive, content: {
                ContentView()
            })
        }
    }
}

struct EntryView_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
