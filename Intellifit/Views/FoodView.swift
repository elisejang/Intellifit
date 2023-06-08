//
//  FoodView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/3/23.
//

import SwiftUI

struct FoodView: View {
    // change to be loaded from ML model
    let mealPlans = [
        MealPlan(meal: "Meal 1", breakfast: "Eggs", lunch: "Ceasar Salad", dinner: "Salmon"),
        MealPlan(meal: "Meal 2", breakfast: "Eggs", lunch: "Ceasar Salad", dinner: "Salmon"),
        MealPlan(meal: "Meal 3", breakfast: "Eggs", lunch: "Ceasar Salad", dinner: "Salmon"),
        MealPlan(meal: "Meal 4", breakfast: "Eggs", lunch: "Ceasar Salad", dinner: "Salmon"),
        MealPlan(meal: "Meal 5", breakfast: "Eggs", lunch: "Ceasar Salad", dinner: "Salmon")
    ]
    
    var body: some View {
        ScrollView{
            VStack {
                DateView()
                
                Text("Macro Goals")
                    .font(.system(size: 25))
                    .bold()
                HStack{
                    VStack{
                        ProgressCircleView(progress: 0.75)
                        Text("Protein")
                    }
                    VStack{
                        ProgressCircleView(progress: 0.5)
                        Text("Carbs")
                    }
                    VStack{
                        ProgressCircleView(progress: 0.25)
                        Text("Fat")
                    }
                }
                .padding()
                
                Text("Suggested Meals")
                    .font(.system(size: 25))
                    .bold()
                VStack {
                    ForEach(mealPlans, id: \.meal) { plan in
                        MealCardView(meal: plan.meal,
                            breakfast: plan.breakfast,
                            lunch: plan.lunch,
                            dinner: plan.dinner)
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
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 25))
                }
                .padding()
                
                Text(dateFormatter.string(from: currentDate))
                    .font(.system(size: 25))

                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
                }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 25))
                }
                .padding()
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

struct ProgressCircleView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 10)
                .opacity(0.3)
                .foregroundColor(.gray)
                
            
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .foregroundColor(.blue)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1.5), value: progress)
            
            Text("\(Int(progress * 100))%")
                .font(.caption)
        }
        .padding()
    }
}

struct MealCardView: View {
    let meal: String
//    let description: String
    let breakfast: String
    let lunch: String
    let dinner: String
    
    var body: some View {
        VStack {
            Text(meal)
                .font(.title2)
                .foregroundColor(.blue)
                .padding()
            
//            Text(description)
//                .font(.body)
//                .foregroundColor(.gray)
//                .padding()
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
        }
        .frame(width:300)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 4)
        .padding()
    }
}

struct MealPlan {
    let meal: String
//    let description: String
    let breakfast: String
    let lunch: String
    let dinner: String
}


struct FoodView_Previews: PreviewProvider {
    static var previews: some View {
        FoodView()
    }
}
