//
//  ContentView.swift
//  Intellifit
//
//  Created by Elise Jang on 5/23/23.
//

import SwiftUI
//import Firebase


struct ContentView: View {
    @State var isNewUser = true
    @State private var isShowingNewUserPopUp = false
    @State private var isShowingHomeView = false

    var body: some View {
        if isNewUser{
            NewUserView(isNewUser: $isNewUser, isShowingHomeView: $isShowingHomeView)
        } else if isShowingHomeView {
            ZStack{
                VStack {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame( height: 40)
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
//                        ProfileView()
//                            .tabItem() {
//                                Image(systemName: "person.crop.circle")
//                                Text("Profile")
//                            }
                    }
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
