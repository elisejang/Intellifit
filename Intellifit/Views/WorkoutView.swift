

//
//  WorkoutView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/3/23.
//

import SwiftUI
//import Foundation

struct WorkoutView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var CalendarPage = false
    @State private var RecommendationsView = false
    @State private var PastActView = false
    @State var currentImages: [String] = ["rec1", "rec2", "rec3", "rec4", "rec5"]
    @StateObject private var fitnessManager = FitnessManager()
    @State private var isLoading = false
    @State private var recA: [String: String] = [:]

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                HStack {
                    Spacer().frame(width: 11)
                    Text("My Workouts")
                        .font(.system(size: 35, weight: .bold))
                        .font(.custom("Inter", size: 25))
                        .foregroundColor(Color.black)
                    Spacer()
                    Button(action: {
                        CalendarPage = true
                    }) {
                        Image("calendarIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100, height: 150)
                    }
                    .fullScreenCover(isPresented: $CalendarPage, content: {
                        CalendarView()
                    })
                }
                
                HStack {
                    Spacer().frame(width: 11)
                    Text("Recommendations")
                        .font(.system(size: 25, weight: .bold))
                        .font(.custom("Inter", size: 25))
                        .foregroundColor(Color.black)
                    Spacer()
                    Button(action: {
                        RecommendationsView = true
                    }) {
                        Text("View All")
                            .font(.system(size: 12))
                            .font(.custom("Inter", size: 25))
                            .foregroundColor(Color.gray)
                    }
                    .fullScreenCover(isPresented: $RecommendationsView, content: {
                        RecView(recA: recA)
                    })
                    
                    Spacer().frame(width: 11)
                }
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        Spacer().frame(width: 1)
                        ForEach(recA.sorted(by: { $0.key < $1.key }), id: \.key) { activity, priority in
//                            let imageName = activity
//                            if let imageName = Image(activity) {
                                ZStack {
                                    Rectangle()
                                        .fill(Color.gray)

                                        .frame(width: 100, height: 150)
                                        .cornerRadius(10)
                                        .overlay(
                                            Text(activity)
                                                .font(.body)
//                                                .fontWeight(.bold)
                                                .font(.custom("Inter", size: 25))
                                                .foregroundColor(.white)
                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                            .alignmentGuide(HorizontalAlignment.center) { dimensions in
                                                                dimensions.width / 2
                                                            }
                                                            .alignmentGuide(VerticalAlignment.center) { dimensions in
                                                                dimensions.height / 2
                                                            }
                                                .padding()
                                        )
                                }
                            
                        }

                    }
                }
                
                HStack {
                    Spacer().frame(width: 11)
                    Text("Past Activities")
                        .font(.system(size: 25, weight: .bold))
                        .font(.custom("Inter", size: 25))
                        .foregroundColor(Color.black)
                    Spacer()
                    Button(action: {
                        PastActView = true
                    }) {
                        Text("View All")
                            .font(.system(size: 12))
                            .font(.custom("Inter", size: 25))
                            .foregroundColor(Color.gray)
                    }
                    .fullScreenCover(isPresented: $PastActView, content: {
                        PastView()
                    })
                    
                    Spacer().frame(width: 11)
                }
                
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        Spacer().frame(width: 1)
                        ForEach(0..<5) { index in
                            let imageName = currentImages[index]
                            ZStack {
                                Image(imageName)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 150)
                                    .cornerRadius(10)
                                
                                Button(action: {
                                    if currentImages[index] == "rec1" {
                                        currentImages[index] = "rec2"
                                    } else {
                                        currentImages[index] = "rec1"
                                    }
                                }) {
                                    Text(imageName)
                                        .font(.body)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .contentShape(Rectangle()) // Ensure button recognizes taps
                            }
                        }
                    }
                }
                .padding(.top)
                
            }
        }
        .onAppear {
            isLoading = true
            recA = [
                    "Cycling, 10-11.9 mph, light": "0.0",
                    "Cycling, <10 mph, leisure bicycling": "0.0",
                    "Cycling, >20 mph, racing": "0.0",
                    "Cycling, mountain bike, bmx": "0.0",
                    "Weight lifting, body building, vigorous": "1.0"
                ]
            isLoading = false
//            fitnessManager.predictFitness(userId: "123", date: "2022-01-01") { result in
//                switch result {
//                case .success(let fitness):
//                    DispatchQueue.main.async {
//                        fitnessManager.fitness = fitness
//                        recA = fitness.sorted(by: { $0.key < $1.key }).map { $0.key }
//                        isLoading = false
//                    }
//                case .failure(let error):
//                    DispatchQueue.main.async {
//                        print("Error: \(error)")
//                        isLoading = false
//                    }
//                }
//            }
        }
    }
}





class FitnessManager: ObservableObject {
    @Published var fitness: [String: String] = [:]

    func predictFitness(userId: String, date: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
        // Define the endpoint URL for the predictFitness route
        let baseURL = URL(string: "http://your-flask-server-url.com")!
        let url = baseURL.appendingPathComponent("/predictFitness")

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
                    if let fitness = responseJSON {
                        completion(.success(fitness))
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

//enum NetworkError: Error {
//    case invalidResponse
//}


struct RecView: View {
    var recA: [String: String]

    init(recA: [String: String]) {
        self.recA = recA
    }

    @Environment(\.presentationMode) var presentationMode
    @State var isFlipped = Array(repeating: false, count: 6)
    @State var backDegree = Array(repeating: 0.0, count: 6)
    @State var frontDegree = Array(repeating: -90.0, count: 6)
    let durationAndDelay: CGFloat = 0.3
    @State var counts = Array(repeating: 0, count: 6)

    func flip(index: Int) {
        isFlipped[index] = !isFlipped[index]
        if isFlipped[index] {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree[index] = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                frontDegree[index] = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree[index] = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                backDegree[index] = 0
            }
        }
    }

    var body: some View {
        VStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("downarrow")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            ScrollView {
                LazyVStack(spacing: 10) {
                    Spacer().frame(width: 1)
                    ForEach(Array(recA.sorted(by: { $0.key < $1.key }).enumerated()), id: \.element.key) { index, item in
                        let activity = item.key
                        
                        ZStack {
                            CardFront(w: 300, h: 150, imgName: activity, degree: $frontDegree[index], index: index) {
                                flip(index: index)
                            }
                            CardBack(w: 300, h: 150, imgName: activity, size: true, degree: $backDegree[index], count: $counts[index])
                        }
                        .onTapGesture {
                            flip(index: index)
                        }
                    }
                }
            }
        }
    }
}



struct CardFront: View {
    let w: CGFloat
    let h: CGFloat
    var imgName: String
    @Binding var degree: Double
    var index: Int
    var flipAction: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray)
                .frame(width: w, height: h)
                .cornerRadius(10)
            if degree >= 0 {
                if let image = UIImage(named: imgName) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: w, height: h)
                        .cornerRadius(10)
                }
                Text(imgName)
                    .font(.body)
                    .font(.custom("Inter", size: 25))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .alignmentGuide(HorizontalAlignment.center) { dimensions in dimensions.width / 2}
                    .alignmentGuide(VerticalAlignment.center) { dimensions in dimensions.height / 2}
            }
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            flipAction() // Call the flip action closure
        }
        .id(index) // Add an identifier to ensure proper view update
    }
}




struct CardBack: View {
    let w: CGFloat
    let h: CGFloat
    var imgName: String
    var size: Bool
    @Binding var degree: Double
    @Binding var count: Int

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray)
                .frame(width: w, height: h)
                .cornerRadius(10)
            if degree >= 0 {
                VStack {
                    Text("Hour \(count)")
                    HStack {
                        Button(action: {
                            if count == 0 {
                                count = 0
                            } else {
                                count -= 1
                            }
                        }) {
                            Image(systemName: "minus.circle")
                        }
                        .font(.largeTitle)

                        Button(action: {
                            count += 1
                        }) {
                            Image(systemName: "plus.circle")
                        }
                        .font(.largeTitle)
                    }
                    Text("Total Calories : #")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
            }
        }
        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
    }
}



    
struct PastView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var isFlipped = Array(repeating: false, count: 6)
    @State var backDegree = Array(repeating: 0.0, count: 6)
    @State var frontDegree = Array(repeating: -90.0, count: 6)
    let durationAndDelay: CGFloat = 0.3
    @State var counts = Array(repeating: 0, count: 6)
    
    func flip(index: Int) {
        isFlipped[index] = !isFlipped[index]
        if isFlipped[index] {
            withAnimation(.linear(duration: durationAndDelay)) {
                backDegree[index] = 90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                frontDegree[index] = 0
            }
        } else {
            withAnimation(.linear(duration: durationAndDelay)) {
                frontDegree[index] = -90
            }
            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
                backDegree[index] = 0
            }
        }
    }
    
    var body: some View {
        VStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("downarrow")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            ScrollView(.vertical) {
                LazyVStack(spacing: 10) {
                    Spacer().frame(width: 1)
                    ForEach(0..<5) { index in
                        let imageName = "rec\(index + 1)"
                        
                        ZStack {
                            CardFront(w: 300, h: 150, imgName: imageName, degree: $frontDegree[index], index: index) {flip(index: index)}
                            CardBack(w: 300, h: 150, imgName: imageName, size: true, degree: $backDegree[index], count: $counts[index])
                        }
                        .onTapGesture {
                            flip(index: index)
                        }
                    }
                }
            }
        }
    }
}










struct CalendarView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var DayPage = false
    
    @State private var dayPage: Int?
    @State var isDayViewPresented: Bool = false
//    @State var selectedDay: Int?
    @State var selectedDay: DayIdentifier?
    let calendar = Calendar.current
    let currentDate = Date()
    
    var body: some View {
        
        func currentMonthName() -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM yyyy"
            
            let components = calendar.dateComponents([.year, .month], from: currentDate)
            
            guard let date = calendar.date(from: components) else {
                return ""
            }
            
            return dateFormatter.string(from: date)
        }
        
        func numberOfDaysInMonth() -> Range<Int> {
            let components = calendar.dateComponents([.year, .month], from: currentDate)
            guard let startDate = calendar.date(from: components),
                  let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate),
                  let startDay = calendar.dateComponents([.day], from: startDate).day,
                  let endDay = calendar.dateComponents([.day], from: endDate).day else {
                return 1..<1
            }
            
            return startDay..<endDay+1
        }
        
        
        @State var CurrentMonthYear = currentMonthName()
        @State var CurrentDays = numberOfDaysInMonth()
        
        func isCurrentDate(day: Int) -> Bool {
            let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
            return components.year == calendar.component(.year, from: currentDate) && components.month == calendar.component(.month, from: currentDate) && components.day == day
        }
        
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        //calendar images
        return VStack {
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("downarrow")
                    .resizable()
                    .frame(width: 40, height: 40)
                
            }
            Spacer()
            
            
            
            Text(CurrentMonthYear)
                .font(.system(size: 25, weight: .bold))
                .font(.custom("Inter", size: 25))
                .foregroundColor(Color.black)
            
            

            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
                ForEach(CurrentDays, id: \.self) { day in
                    Button(action: {
                        selectedDay = DayIdentifier(id: day, day: day)
                    }){Text("\(day)")
                            .frame(width: 40, height: 40)
                            .background(isCurrentDate(day: day) ? Color.blue : Color.clear)
                            .cornerRadius(20)
                            .foregroundColor(isCurrentDate(day: day) ? .white : .black)
                    }
                    .sheet(item: $selectedDay) { dayIdentifier in
                        DayView(day: dayIdentifier.day, month: currentMonth, year: currentYear)
                                }
                                
                }
                
            }
            Spacer()
        }
    }
}

struct DayIdentifier: Identifiable {
    let id: Int
    let day: Int

}
            
            

struct DayView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let day: Int
    let month: Int
    let year: Int
    let workouts: [Workout] = [
        
        ///CHANGE DATA
        ///
        
        Workout(name: "Running", hours: 1.5, calories: 600),
        Workout(name: "Swimming", hours: 2.0, calories: 700),
        Workout(name: "Yoga", hours: 1.0, calories: 300)
        
    ]
    
    var totalCalories: Int {
        workouts.reduce(0) { $0 + $1.calories }
    }
    
    var date: Date? {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        return Calendar.current.date(from: components)
    }
    
    var monthString: String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }
    
    var yearString: String {
            guard let date = date else { return "" }
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy"
            return formatter.string(from: date)
        }

    var body: some View {
        VStack{
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("downarrow")
                    .resizable()
                    .frame(width: 40, height: 40)
            }
            
            
            Text("\(monthString) \(day), \(yearString)") // Example content for the day view
                .font(.system(size: 50, weight: .bold))
                .font(.custom("Inter", size: 50))
                .foregroundColor(Color.black)
                .padding(10)
            
            
           
            
            
            if workouts.isEmpty {
                Text("No workouts to display.")
                    .font(.headline)
                    .foregroundColor(.gray)
            } else {
                HStack {
                    Text("Workout")
                        .font(.headline)
                    Spacer()
                    Text("Duration")
                        .font(.headline)
                    Spacer()
                    Text("Calories")
                        .font(.headline)
                }
                .padding()
                
                ForEach(workouts) { workout in
                    HStack {
                        Text(workout.name)
                            .frame(maxWidth: .infinity)
                        Text("\(workout.hours, specifier: "%.1f")")
                            .frame(maxWidth: .infinity)
                        Text("\(workout.calories)")
                            .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
                
                Text("Total Calories Burnt:")
                    .font(.system(size: 20, weight: .bold))
                    .font(.custom("Inter", size: 20))
                    .foregroundColor(Color.gray)
                    .padding(10)
                Text("\(totalCalories)")
                    .font(.system(size: 40, weight: .bold))
                    .font(.custom("Inter", size: 40))
                    .foregroundColor(Color.black)
                    .padding(10)
                
                
                
                }
                
            }
        }
    }
    
struct Workout: Identifiable {
    var id = UUID()
    let name: String
    let hours: Double
    let calories: Int
}


struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}
