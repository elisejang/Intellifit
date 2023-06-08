//
//  IntellifitApp.swift
//  Intellifit
//
//  Created by Elise Jang on 5/23/23.
//

import SwiftUI
import Firebase

@main
struct IntellifitApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            EntryView()
        }
    }
}

struct Previews_IntellifitApp_Previews: PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
