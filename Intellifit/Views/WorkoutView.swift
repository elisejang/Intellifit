

//
//  WorkoutView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/3/23.
//

import SwiftUI
//import Foundation
import Firebase
import Combine
import FirebaseFirestore


// will use this to record the first selectedExercise for now (still need 2nd and 3rd)
class UserData: ObservableObject {
    @Published var selectedExercise: Exercise?
}

class ExerciseViewModel: ObservableObject {
    @Published var exercises = [Exercise]()

    private var db = Firestore.firestore()

    func fetchData() {
        db.collection("Exercises").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.exercises = documents.map { queryDocumentSnapshot -> Exercise in
                let data = queryDocumentSnapshot.data()
                let id = queryDocumentSnapshot.documentID
                let name = data["name"] as? String ?? ""
                
                return Exercise(id: id, name: name)
            }
        }
    }
}


//struct WorkoutView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State private var CalendarPage = false
//    @State private var RecommendationsView = false
//    @State private var PastActView = false
//    @State var currentImages: [String] = ["rec1", "rec2", "rec3", "rec4", "rec5"]
//    @StateObject private var fitnessManager = FitnessManager()
//    @State private var isLoading = false
//    @State private var recA: [String: String] = [:]
//
//    var body: some View {
//        VStack {
//            if isLoading {
//                ProgressView()
//            } else {
//                HStack {
//                    Spacer().frame(width: 11)
//                    Text("My Workouts")
//                        .font(.system(size: 35, weight: .bold))
//                        .font(.custom("Inter", size: 25))
//                        .foregroundColor(Color.black)
//                    Spacer()
//                    Button(action: {
//                        CalendarPage = true
//                    }) {
//                        Image("calendarIcon")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(width: 100, height: 150)
//                    }
//                    .fullScreenCover(isPresented: $CalendarPage, content: {
//                        CalendarView()
//                    })
//                }
//
//                HStack {
//                    Spacer().frame(width: 11)
//                    Text("Recommendations")
//                        .font(.system(size: 25, weight: .bold))
//                        .font(.custom("Inter", size: 25))
//                        .foregroundColor(Color.black)
//                    Spacer()
//                    Button(action: {
//                        RecommendationsView = true
//                    }) {
//                        Text("View All")
//                            .font(.system(size: 12))
//                            .font(.custom("Inter", size: 25))
//                            .foregroundColor(Color.gray)
//                    }
//                    .fullScreenCover(isPresented: $RecommendationsView, content: {
//                        RecView(recA: recA)
//                    })
//
//                    Spacer().frame(width: 11)
//                }
//
//                ScrollView(.horizontal) {
//                    LazyHStack(spacing: 10) {
//                        Spacer().frame(width: 1)
//                        ForEach(recA.sorted(by: { $0.key < $1.key }), id: \.key) { activity, priority in
////                            let imageName = activity
////                            if let imageName = Image(activity) {
//                                ZStack {
//                                    Rectangle()
//                                        .fill(Color.gray)
//
//                                        .frame(width: 100, height: 150)
//                                        .cornerRadius(10)
//                                        .overlay(
//                                            Text(activity)
//                                                .font(.body)
////                                                .fontWeight(.bold)
//                                                .font(.custom("Inter", size: 25))
//                                                .foregroundColor(.white)
//                                                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                                                            .alignmentGuide(HorizontalAlignment.center) { dimensions in
//                                                                dimensions.width / 2
//                                                            }
//                                                            .alignmentGuide(VerticalAlignment.center) { dimensions in
//                                                                dimensions.height / 2
//                                                            }
//                                                .padding()
//                                        )
//                                }
//
//                        }
//
//                    }
//                }
//
//                HStack {
//                    Spacer().frame(width: 11)
//                    Text("Past Activities")
//                        .font(.system(size: 25, weight: .bold))
//                        .font(.custom("Inter", size: 25))
//                        .foregroundColor(Color.black)
//                    Spacer()
//                    Button(action: {
//                        PastActView = true
//                    }) {
//                        Text("View All")
//                            .font(.system(size: 12))
//                            .font(.custom("Inter", size: 25))
//                            .foregroundColor(Color.gray)
//                    }
//                    .fullScreenCover(isPresented: $PastActView, content: {
//                        PastView()
//                    })
//
//                    Spacer().frame(width: 11)
//                }
//
//                ScrollView(.horizontal) {
//                    LazyHStack(spacing: 10) {
//                        Spacer().frame(width: 1)
//                        ForEach(0..<5) { index in
//                            let imageName = currentImages[index]
//                            ZStack {
//                                Image(imageName)
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 100, height: 150)
//                                    .cornerRadius(10)
//
//                                Button(action: {
//                                    if currentImages[index] == "rec1" {
//                                        currentImages[index] = "rec2"
//                                    } else {
//                                        currentImages[index] = "rec1"
//                                    }
//                                }) {
//                                    Text(imageName)
//                                        .font(.body)
//                                        .fontWeight(.bold)
//                                        .foregroundColor(.white)
//                                }
//                                .contentShape(Rectangle()) // Ensure button recognizes taps
//                            }
//                        }
//                    }
//                }
//                .padding(.top)
//
//            }
//        }
//        .onAppear {
//            isLoading = true
//            recA = [
//                    "Cycling, 10-11.9 mph, light": "0.0",
//                    "Cycling, <10 mph, leisure bicycling": "0.0",
//                    "Cycling, >20 mph, racing": "0.0",
//                    "Cycling, mountain bike, bmx": "0.0",
//                    "Weight lifting, body building, vigorous": "1.0"
//                ]
//            isLoading = false
////            fitnessManager.predictFitness(userId: "123", date: "2022-01-01") { result in
////                switch result {
////                case .success(let fitness):
////                    DispatchQueue.main.async {
////                        fitnessManager.fitness = fitness
////                        recA = fitness.sorted(by: { $0.key < $1.key }).map { $0.key }
////                        isLoading = false
////                    }
////                case .failure(let error):
////                    DispatchQueue.main.async {
////                        print("Error: \(error)")
////                        isLoading = false
////                    }
////                }
////            }
//        }
//
//    }
//}
//
//
//
//
//
//class FitnessManager: ObservableObject {
//    @Published var fitness: [String: String] = [:]
//
//    func predictFitness(userId: String, date: String, completion: @escaping (Result<[String: String], Error>) -> Void) {
//        // Define the endpoint URL for the predictFitness route
//        let baseURL = URL(string: "http://your-flask-server-url.com")!
//        let url = baseURL.appendingPathComponent("/predictFitness")
//
//        // Prepare the request body
//        let requestBody: [String: String] = [
//            "userId": userId,
//            "date": date
//        ]
//
//        // Create the request object
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // Set the request body
//        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
//
//        // Send the request
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            if let data = data {
//                // Parse and handle the response data
//                do {
//                    let responseJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
//                    if let fitness = responseJSON {
//                        completion(.success(fitness))
//                    } else {
//                        completion(.failure(NetworkError.invalidResponse))
//                    }
//                } catch {
//                    completion(.failure(error))
//                }
//            } else {
//                completion(.failure(NetworkError.invalidResponse))
//            }
//        }.resume()
//    }
//}
//
////enum NetworkError: Error {
////    case invalidResponse
////}
//
//
//struct RecView: View {
//    var recA: [String: String]
//
//    init(recA: [String: String]) {
//        self.recA = recA
//    }
//
//    @Environment(\.presentationMode) var presentationMode
//    @State var isFlipped = Array(repeating: false, count: 6)
//    @State var backDegree = Array(repeating: 0.0, count: 6)
//    @State var frontDegree = Array(repeating: -90.0, count: 6)
//    let durationAndDelay: CGFloat = 0.3
//    @State var counts = Array(repeating: 0, count: 6)
//
//    func flip(index: Int) {
//        isFlipped[index] = !isFlipped[index]
//        if isFlipped[index] {
//            withAnimation(.linear(duration: durationAndDelay)) {
//                backDegree[index] = 90
//            }
//            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
//                frontDegree[index] = 0
//            }
//        } else {
//            withAnimation(.linear(duration: durationAndDelay)) {
//                frontDegree[index] = -90
//            }
//            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
//                backDegree[index] = 0
//            }
//        }
//    }
//
//    var body: some View {
//        VStack {
//            Button(action: {
//                presentationMode.wrappedValue.dismiss()
//            }) {
//                Image("downarrow")
//                    .resizable()
//                    .frame(width: 40, height: 40)
//            }
//            ScrollView {
//                LazyVStack(spacing: 10) {
//                    Spacer().frame(width: 1)
//                    ForEach(Array(recA.sorted(by: { $0.key < $1.key }).enumerated()), id: \.element.key) { index, item in
//                        let activity = item.key
//
//                        ZStack {
//                            CardFront(w: 300, h: 150, imgName: activity, degree: $frontDegree[index], index: index) {
//                                flip(index: index)
//                            }
//                            CardBack(w: 300, h: 150, imgName: activity, size: true, degree: $backDegree[index], count: $counts[index])
//                        }
//                        .onTapGesture {
//                            flip(index: index)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//
//
//
//struct CardFront: View {
//    let w: CGFloat
//    let h: CGFloat
//    var imgName: String
//    @Binding var degree: Double
//    var index: Int
//    var flipAction: () -> Void
//
//    var body: some View {
//        ZStack {
//            Rectangle()
//                .fill(Color.gray)
//                .frame(width: w, height: h)
//                .cornerRadius(10)
//            if degree >= 0 {
//                if let image = UIImage(named: imgName) {
//                    Image(uiImage: image)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: w, height: h)
//                        .cornerRadius(10)
//                }
//                Text(imgName)
//                    .font(.body)
//                    .font(.custom("Inter", size: 25))
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .alignmentGuide(HorizontalAlignment.center) { dimensions in dimensions.width / 2}
//                    .alignmentGuide(VerticalAlignment.center) { dimensions in dimensions.height / 2}
//            }
//        }
//        .rotation3DEffect(Angle(degrees: degree), axis: (x: 0, y: 1, z: 0))
//        .onTapGesture {
//            flipAction() // Call the flip action closure
//        }
//        .id(index) // Add an identifier to ensure proper view update
//    }
//}
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
                                ZStack {
                                    Rectangle()
                                        .fill(Color.gray)

                                        .frame(width: 200, height: 250)
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
    @State var counts = Array(repeating: 0, count: 6)


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
                            CardFront(w: 300, h: 150, imgName: activity, index: index)
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
        var index: Int
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: w, height: h)
                    .cornerRadius(10)
                //            if degree >= 0 {
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



    
//struct PastView: View {
//    @Environment(\.presentationMode) var presentationMode
//    @State var isFlipped = Array(repeating: false, count: 6)
//    @State var backDegree = Array(repeating: 0.0, count: 6)
//    @State var frontDegree = Array(repeating: -90.0, count: 6)
//    let durationAndDelay: CGFloat = 0.3
//    @State var counts = Array(repeating: 0, count: 6)
//
//    func flip(index: Int) {
//        isFlipped[index] = !isFlipped[index]
//        if isFlipped[index] {
//            withAnimation(.linear(duration: durationAndDelay)) {
//                backDegree[index] = 90
//            }
//            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
//                frontDegree[index] = 0
//            }
//        } else {
//            withAnimation(.linear(duration: durationAndDelay)) {
//                frontDegree[index] = -90
//            }
//            withAnimation(.linear(duration: durationAndDelay).delay(durationAndDelay)) {
//                backDegree[index] = 0
//            }
//        }
//    }
//
//    var body: some View {
//        VStack {
//            Button(action: {
//                presentationMode.wrappedValue.dismiss()
//            }) {
//                Image("downarrow")
//                    .resizable()
//                    .frame(width: 40, height: 40)
//            }
//            ScrollView(.vertical) {
//                LazyVStack(spacing: 10) {
//                    Spacer().frame(width: 1)
//                    ForEach(0..<5) { index in
//                        let imageName = "rec\(index + 1)"
//
//                        ZStack {
//                            CardFront(w: 300, h: 150, imgName: imageName, degree: $frontDegree[index], index: index) {flip(index: index)}
//                            CardBack(w: 300, h: 150, imgName: imageName, size: true, degree: $backDegree[index], count: $counts[index])
//                        }
//                        .onTapGesture {
//                            flip(index: index)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}










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
    @ObservedObject var exerciseViewModel = ExerciseViewModel()

    let day: Int
    let month: Int
    let year: Int
    @State var workouts: [Workout] = []
    @State var selectedExercises: [Exercise?] = [nil, nil, nil] // For 3 workouts
    @State var durations: [String] = ["", "", ""] // For 3 durations
    @State var calories: [Float] = [0, 0, 0]
  
    var cancellables: Set<AnyCancellable> = []
    
    var totalCalories: Int {
        // TODO: Calculate total calories burnt by all workouts
        return 0
    }
    
    var sumCalories: Float {
        return calories.reduce(0, +)
    }

    var body: some View {
        VStack(alignment: .leading) {
            // Other views...
            if exerciseViewModel.exercises.isEmpty {
                LoadingView()
            } else {
                WorkoutHeaderView()

                ForEach(0..<3, id: \.self) { index in
                    WorkoutRowView(
                        selectedExercise: $selectedExercises[index],
                        duration: $durations[index],
                        calories: $calories[index], // <-- Pass the corresponding calories value here
                        exercises: exerciseViewModel.exercises,
                        onExerciseOrDurationChange: {
                            self.checkAndSendToServer(index: index) { error in
                                if let error = error {
                                    print("An error occurred: \(error)")
                                } else {
                                    print("Data successfully sent to server")
                                }
                            }
                        }
                    )
                    .disabled(self.calories[index] == nil)
                    Divider()
                }






                
                TotalCaloriesView(totalCalories: Float(sumCalories))

            }
        }
        .onAppear {
            exerciseViewModel.fetchData()
        }
    }
        
    
    func checkAndSendToServer(index: Int, completion: @escaping (Error?) -> Void) {
        if let exercise = selectedExercises[index],
           !durations[index].isEmpty {
            print("Exercise selected: \(exercise.name)")
            print("Duration entered: \(durations[index])")

            sendExerciseDurationPairToServer(pair: (exercise, durations[index])) { result in
                switch result {
                case .success(let response):
                    if let responseDict = response as? [String: String],
                       let caloriesString = responseDict["Calories Burned from Workout"],
                       let caloriesValue = Float(caloriesString) {
                        // Update the calories for the specific workout
                        self.calories[index] = caloriesValue
                        print("Calories burned: \(self.calories[index])")
                    }
                    sendExerciseDurationPairToFirestore(pair: (exercise, durations[index]), calories: self.calories[index], completion: completion)
                case .failure(let error):
                    print("An error occurred: \(error)")
                    completion(error)
                }
            }
        }
    }



    
    
    func sendExerciseDurationPairToServer(pair: (exercise: Exercise, duration: String), completion: @escaping (Result<Any, Error>) -> Void) {
        let weight = UserWeight.weight
        let url = URL(string: "http://127.0.0.1:5000/calorieBurn")
        let exerciseDurationPair = ExerciseDurationPair(exerciseName: pair.exercise.name, duration: pair.duration, weight: weight)

        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let jsonData = try JSONEncoder().encode(exerciseDurationPair)
            request.httpBody = jsonData
            print("Sending exercise-duration pair to server: \(pair)")
        } catch {
            print("Error encoding data: \(error)")
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error with request: \(error)")
                completion(.failure(error))
            } else if let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode, let data = data {
                do {
                    // If the response is JSON
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    print("Received JSON response: \(jsonResponse)")
                    completion(.success(jsonResponse))

                } catch {
                    print("Error decoding data: \(error)")
                    completion(.failure(error))
                }
            } else {
                print("Bad or no HTTP response")
                completion(.failure(NSError(domain: "", code: -1, userInfo: nil))) // Replace with your own error
            }
        }

        task.resume()
    }


    func sendExerciseDurationPairToFirestore(pair: (exercise: Exercise, duration: String), calories: Float, completion: @escaping (Error?) -> Void) {
        guard let currentUserID = UserDefaults.standard.string(forKey: "currentUserID") else {
            print("Unable to fetch currentUserID from UserDefaults")
            return
        }

        let db = Firestore.firestore()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd, EEEE"
        let date = dateFormatter.string(from: Date())

        db.collection("Users").document(currentUserID).collection("ExerciseEntries").document().setData([
            "exercise": pair.exercise.name,
            "hours": pair.duration,
            "calories_burnt": calories,
            "date": date
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
                completion(error)
            } else {
                print("ExerciseDurationPair successfully updated in Firestore")
                completion(nil)
            }
        }
    }



}


struct LoadingView: View {
    var body: some View {
        Text("Loading workouts...")
            .font(.headline)
            .foregroundColor(.gray)
    }
}

struct WorkoutHeaderView: View {
    var body: some View {
        HStack {
            Text("Workout")
                .font(.headline)
                .frame(width: 100)
            Text("Duration")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("Calories")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}


struct WorkoutRowView: View {
    @Binding var selectedExercise: Exercise?
    @Binding var duration: String
    @Binding var calories: Float // <-- Add this line
    let exercises: [Exercise]
    let onExerciseOrDurationChange: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            Picker(selection: $selectedExercise, label: Text("Select an Exercise")) {
                ForEach(exercises, id: \.self) { exercise in
                    Text(exercise.name).tag(exercise as Exercise?)
                }
            }
            .labelsHidden()
            .frame(width: 100)
            .onChange(of: selectedExercise) { _ in
                onExerciseOrDurationChange()
            }
            
            TextField("Enter duration", text: $duration)
                .padding()
                .border(Color.gray)
                .keyboardType(.decimalPad)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: duration) { _ in
                    onExerciseOrDurationChange()
                }
                
            Text("\(calories)") // <-- Use the calories value here
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 10)
    }
}


struct TotalCaloriesView: View {
    let totalCalories: Float

    var body: some View {
        VStack {
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


struct Workout: Identifiable {
    var id = UUID()
    let exercise: Exercise
    let hours: Double
    let calories: Int
}


struct WorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutView()
    }
}

struct Exercise: Identifiable, Hashable {
    var id: String
    var name: String
}

struct ExerciseView: View {
    @ObservedObject private var viewModel = ExerciseViewModel()

    var body: some View {
        VStack {
            List(viewModel.exercises) { exercise in
                Text(exercise.name)
            }
        }
        .onAppear() {
            self.viewModel.fetchData()
        }
    }
}

struct ExerciseDurationPair: Codable {
    let exerciseName: String
    let duration: String
    let weight: Double
}
