//
//  ContentView.swift
//  Intellifit
//
//  Created by Elise Jang on 5/23/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .scaledToFit()
                .frame( height: 50)
            Text("Intellifit!")
            TabView {
                HomeView()
                    .tabItem() {
                        Image(systemName: "house.fill")
                        Text("Home")
                    }
                WorkoutView()
                    .tabItem() {
                        Image(systemName: "dumbbell.fill")
                        Text("Workout")
                    }
                FoodView()
                    .tabItem() {
                        Image(systemName: "fork.knife")
                        Text("Food")
                    }
                SleepView()
                    .tabItem() {
                        Image(systemName: "moon.fill")
                        Text("Sleep")
                    }
                SettingsView()
                    .tabItem() {
                        Image(systemName: "gearshape")
                        Text("Settings")
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
