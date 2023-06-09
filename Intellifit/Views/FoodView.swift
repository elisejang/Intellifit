//
//  FoodView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/3/23.
//

import SwiftUI

struct FoodView: View {
    // change to be loaded from ML model
//    @State var proteinP :Int
//    @State var carbP :Int
//    @State var fatP :Int
    let mealPlans = [
<<<<<<< Updated upstream
        MealPlan(meal: "meal 1", breakfast: "eggs", bProtein: "5", bCarb: "5", bFat: "5", lunch: "Caesar Salad", lProtein: "5", lCarb: "5", lFat: "5", dinner: "Salmon", dProtein: "5", dCarb: "5", dFat: "5"),
        MealPlan(meal: "meal 1", breakfast: "eggs", bProtein: "5", bCarb: "5", bFat: "5", lunch: "Caesar Salad", lProtein: "5", lCarb: "5", lFat: "5", dinner: "Salmon", dProtein: "5", dCarb: "5", dFat: "5"),
        MealPlan(meal: "meal 1", breakfast: "eggs", bProtein: "5", bCarb: "5", bFat: "5", lunch: "Caesar Salad", lProtein: "5", lCarb: "5", lFat: "5", dinner: "Salmon", dProtein: "5", dCarb: "5", dFat: "5"),
        MealPlan(meal: "meal 1", breakfast: "eggs", bProtein: "5", bCarb: "5", bFat: "5", lunch: "Caesar Salad", lProtein: "5", lCarb: "5", lFat: "5", dinner: "Salmon", dProtein: "5", dCarb: "5", dFat: "5"),
        MealPlan(meal: "meal 1", breakfast: "eggs", bProtein: "5", bCarb: "5", bFat: "5", lunch: "Caesar Salad", lProtein: "5", lCarb: "5", lFat: "5", dinner: "Salmon", dProtein: "5", dCarb: "5", dFat: "5"),
        MealPlan(meal: "meal 1", breakfast: "eggs", bProtein: "5", bCarb: "5", bFat: "5", lunch: "Caesar Salad", lProtein: "5", lCarb: "5", lFat: "5", dinner: "Salmon", dProtein: "5", dCarb: "5", dFat: "5")
=======
        MealPlan(meal: "Meal Plan 1", breakfast: "Eggs", lunch: "Ceasar Salad", dinner: "Salmon"),
        MealPlan(meal: "Meal Plan 2", breakfast: "Eggs", lunch: "Ceasar Salad", dinner: "Salmon"),
        MealPlan(meal: "Meal Plan 3", breakfast: "Eggs", lunch: "Ceasar Salad", dinner: "Salmon"),
        MealPlan(meal: "Meal Plan 4", breakfast: "Eggs", lunch: "Ceasar Salad", dinner: "Salmon"),
        MealPlan(meal: "Meal Plan 5", breakfast: "Eggs", lunch: "Ceasar Salad", dinner: "Salmon")
>>>>>>> Stashed changes
    ]
    
    var body: some View {
        ScrollView{
            VStack {
                DateView()
                Text("Suggested Meals")
                    .font(.system(size: 25))
                    .bold()
                VStack {
                    ForEach(mealPlans, id: \.meal) { plan in
                        MealCardView(meal: plan.meal, breakfast: plan.breakfast, bProtein: plan.bProtein, bCarb: plan.bCarb, bFat: plan.bFat, lunch: plan.lunch, lProtein: plan.lProtein, lCarb: plan.lCarb, lFat: plan.lFat, dinner: plan.dinner, dProtein: plan.dProtein, dCarb: plan.dCarb, dFat: plan.dFat)
                    }
                }
            }
        }
    }
}

struct DateView: View {
    @State private var currentDate = Date()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter
    }()
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 25))
                }
                .padding()
                
                Spacer()
                
                Text(dateText(for: currentDate))
                    .font(.system(size: 25))
                
                Spacer()

                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 25))
                }
                .padding()
                
                Spacer()
            }
        }
    }
    private func dateText(for date: Date) -> String {
       let calendar = Calendar.current
       let now = calendar.startOfDay(for: Date())
       let dateToCompare = calendar.startOfDay(for: date)
       
       if dateToCompare == now {
           return "Today"
       } else if dateToCompare == calendar.date(byAdding: .day, value: -1, to: now) {
           return "Yesterday"
       } else if dateToCompare == calendar.date(byAdding: .day, value: 1, to: now) {
           return "Tomorrow"
       } else {
           let formatter = DateFormatter()
           formatter.dateFormat = "MMMM d, yyyy"
           return formatter.string(from: date)
       }
   }
}




struct MealCardView: View {
    let meal: String
    let breakfast: String
    let bProtein: String
    let bCarb: String
    let bFat: String
    
    let lunch: String
    let lProtein: String
    let lCarb: String
    let lFat: String
    
    let dinner: String
    let dProtein: String
    let dCarb: String
    let dFat: String
    
    
    @State private var combinedMeals: String = "" //this is what we call from backend
    
    func combineMeals(breakfast: String, lunch: String, dinner: String) -> String {
            let combinedMeals = "\(breakfast), \(lunch), \(dinner)"
            return combinedMeals
        }
    
    var body: some View {
        Button(action: {
            combinedMeals = combineMeals(breakfast: breakfast, lunch: lunch, dinner: dinner)
            
//            print(combinedMeals)
        }){
            VStack {
                Text(breakfast)
                    .font(.headline)
                    .padding(.bottom, 10)
                
                HStack(spacing: 20) {
                    MacroSection(title: "Fats", value: bFat)
                    MacroSection(title: "Carbs", value: bCarb)
                    MacroSection(title: "Protein", value: bProtein)
                }
                Text(lunch)
                    .font(.headline)
                    .padding(.bottom, 10)
                
                HStack(spacing: 20) {
                    MacroSection(title: "Fats", value: lFat)
                    MacroSection(title: "Carbs", value: lCarb)
                    MacroSection(title: "Protein", value: lProtein)
                }
                Text(dinner)
                    .font(.headline)
                    .padding(.bottom, 10)
                
                HStack(spacing: 20) {
                    MacroSection(title: "Fats", value: dFat)
                    MacroSection(title: "Carbs", value: dCarb)
                    MacroSection(title: "Protein", value: dProtein)
                }
            }
        }
        .foregroundColor(Color.white)
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
        
        }
}

struct MacroSection: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
<<<<<<< Updated upstream
            Text(title)
                .font(.subheadline)
            Text(value)
                .font(.headline)
=======
            Text(meal)
                .font(.title2)
                .foregroundColor(.blue)
                .padding()
            Text(breakfast)
                .font(.body)
                .foregroundColor(.gray)
                .padding(5)
            Text(lunch)
                .font(.body)
                .foregroundColor(.gray)
                .padding(5)
            Text(dinner)
                .font(.body)
                .foregroundColor(.gray)
                .padding(5)
>>>>>>> Stashed changes
        }
        .foregroundColor(.black)
    }
}

struct MealPlan {
    let meal: String
//    let description: String
    let breakfast: String
    let bProtein: String
    let bCarb: String
    let bFat: String
    
    let lunch: String
    let lProtein: String
    let lCarb: String
    let lFat: String
    
    let dinner: String
    let dProtein: String
    let dCarb: String
    let dFat: String
    
}


struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView()
    }
}
