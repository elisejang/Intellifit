//
//  HomeView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/3/23.
//

import SwiftUI

struct HomeView: View {
    @State var isBlurred = true
    @State private var selectedTab: Tab? = .home
    
    enum Tab {
        case home, workouts, meals, sleep
    }
    
    var body: some View {
        NavigationView {
            ScrollView{
                Spacer()
                VStack(spacing: 0){
//                    HomeCarousel()
                    VStack{
                        
                        NavigationLink(destination: WorkoutView(), tag: Tab.workouts, selection: $selectedTab) {
                            Text("Workouts")
                                .frame(width: 300, height: 100)
                                .font(.system(size: 23.0, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("Color 4"))
                                .cornerRadius(10)
                        }.padding(20)
                        
                        NavigationLink(destination: FoodView(), tag: .meals, selection: $selectedTab) {
                            Text("Meals")
                                .frame(width: 300, height: 100)
                                .font(.system(size: 23.0, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("Color 4"))
                                .cornerRadius(10)
                        }.padding(20)
                        
                        NavigationLink(destination: SleepView()) {
                            Text("Sleep")
                                .frame(width: 300, height: 100)
                                .font(.system(size: 23.0, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("Color 4"))
                                .cornerRadius(10)
                        }.padding(20)
                    }
                    Spacer()
                }
                .padding()
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
