//
//  FoodView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/3/23.
//

import SwiftUI

struct FoodView: View {
    var targetCal : Float = 700+1800
    //if gain weight add 200 to target cal
    //if lose weight decrease 200 to target cal
    //target should be extracted from database and 1800 added after
    
    
    // change to be loaded from ML model
//    @State var proteinP :Int
//    @State var carbP :Int
//    @State var fatP :Int
    let mealPlans = [

            MealPlan(meal: "meal1", breakfast: "eggs", lunch: "caesar salad", dinner: "salmon", dProtein: "5", dCarb: "5", dFat: "5"),
            MealPlan(meal: "meal2", breakfast: "eggs", lunch: "caesar salad", dinner: "salmon", dProtein: "5", dCarb: "5", dFat: "5"),
            MealPlan(meal: "meal3", breakfast: "eggs", lunch: "caesar salad", dinner: "salmon", dProtein: "5", dCarb: "5", dFat: "5"),
            MealPlan(meal: "meal4", breakfast: "eggs", lunch: "caesar salad", dinner: "salmon", dProtein: "5", dCarb: "5", dFat: "5"),
            MealPlan(meal: "meal5", breakfast: "eggs", lunch: "caesar salad", dinner: "salmon", dProtein: "5", dCarb: "5", dFat: "5")
    ]
    @State private var isLoading = false
    @State private var FoodDict: [String: String] = [:]
    @StateObject private var foodManager = FoodManager()

    
    var body: some View {
        ScrollView{
            VStack {
                if isLoading {
                    ProgressView()
                } else {
                    DateView()
                    Text("Suggested Meals")
                        .font(.system(size: 25))
                        .bold()
                    VStack {
//                        ForEach(Array(FoodDict.sorted(by: { $0.key < $1.key }).enumerated()), id: \.element.key) { index, item in
//                            let activity = item.key
//                            let priority = item.value
//
//
                        ForEach(mealPlans, id: \.meal) { plan in
                            MealCardView(meal: plan.meal, breakfast: plan.breakfast, lunch: plan.lunch, dinner: plan.dinner, dProtein: plan.dProtein, dCarb: plan.dCarb, dFat: plan.dFat)
                        }
                    }
                }
            }.onAppear {
                isLoading = true
                FoodDict = ["['Best Breakfast Burrito', 'Spinach Mushroom Omelette with Parmesan', 'Grilled Chuck Burgers with Extra Sharp Cheddar and Lemon Garlic Aioli']": "[1999.97, 121.62, 82.84, 145.23]",
                "['Crab Cakes Eggs Benedict', 'Pesto Fresh Caprese Sandwich', 'Baby Spinach With Fettuccini, Apricots & Walnuts']": "[1999.96, 112.37, 101.37, 141.85]",
                "['Granola', 'Chicken and Miso Ramen Noodle Soup', 'Creamy zucchini and ham pasta']": "[2000.09, 89.41, 84.45, 214.35]",
                "['Protein Packed Carrot Muffins', 'Ground Pork Ramen', 'Low Carb Brunch Burger']": "[1999.97, 146.64, 105.17, 85.43]",
                "['Strawberry Shortcake w. Mini Strawberry PopTarts', 'Tex-Mex Burger', 'Cavatelli with Chicken Sausage and Kale']": "[1999.96, 97.1, 87.15, 194.85]"]
                isLoading = false
//                foodManager.predictMeals(userId: "123", date: "2022-01-01") { result in
//                    switch result {
//                    case .success(let Meals):
//                        DispatchQueue.main.async {
//                            foodManager.Meals = Meals
//                            FoodDict = Meals
//                            isLoading = false
//                        }
//                    case .failure(let error):
//                        DispatchQueue.main.async {
//                            print("Error: \(error)")
//                            isLoading = false
//                        }
//                    }
//                }
                
            }
        }
    }
}

//only need to enum network error once
enum NetworkError: Error {
    case invalidResponse
}

class FoodManager: ObservableObject {
    @Published var Meals: [String: String] = [:]
    
    func predictMeals(userId: String, date: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
        // Define the endpoint URL for the predictFitness route
        let baseURL = URL(string: "http://your-flask-server-url.com")!
        let url = baseURL.appendingPathComponent("/mealRecommendation")

        // Prepare the request body
        let requestBody: [String: String] = [
            "userId": userId,
            "date": date
        ]

        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Set the request body
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        // Send the request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let data = data {
                // Parse and handle the response data
                do {
                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
                    if let Meals = responseJSON {
                        completion(.success(Meals))
                    } else {
                        completion(.failure(NetworkError.invalidResponse))
                    }
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(NetworkError.invalidResponse))
            }
        }.resume()
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
    
    let lunch: String
    
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
                Text(meal)
                    .font(.title)
                    .padding(.bottom, 10)
                
                Text(breakfast)
                    .font(.headline)
                    .padding(.bottom, 10)
                
            
                Text(lunch)
                    .font(.headline)
                    .padding(.bottom, 10)
                
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
            Text(title)
                .font(.subheadline)
            Text(value)
                .font(.headline)
        }
        .foregroundColor(.black)
    }
}

struct MealPlan {
    let meal: String
    
    let breakfast: String
    
    let lunch: String
    
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
