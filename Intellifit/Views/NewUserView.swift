//
//  NewUserView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/7/23.
//

import SwiftUI
import FirebaseFirestore
import Foundation

struct NewUserView: View {
    @State private var isShowingNewUserPopUp = false
    @Binding var isNewUser: Bool
    @Binding var isShowingHomeView: Bool
    
    var body: some View {
        ZStack{
            VStack{
                Text("Need to make this better!")
                Button("New User") {
                    isShowingNewUserPopUp = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color("Color 4"))
                .cornerRadius(10)
                .sheet(isPresented: $isShowingNewUserPopUp) {
                    NewUserPopUp(isNewUser: $isNewUser, isShowingHomeView: $isShowingHomeView)
                }
            }
        }
    }
}

struct NewUserPopUp : View {
    enum PopupPage {
        case userInfo
        case additionalInfo
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var isNewUser: Bool
    @Binding var isShowingHomeView: Bool
    
    @State private var currentPage: PopupPage = .userInfo
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var birthdate = Date()
    @State var weight: Int = 0
    
    var body: some View {
        VStack {
            
            if currentPage == .userInfo {
                UserInfoView(firstName: $firstName, lastName: $lastName, birthdate: $birthdate, weight: $weight, nextButtonTapped: next1Tapped)
            } else if currentPage == .additionalInfo {
                ActivityHistoryView(nextButtonTapped: beginButtonTapped)
            }
        }
    }
    
    func beginButtonTapped() {
        let db = Firestore.firestore()
//        {
//            print("Error creating a reference to Firestore")
//            return
//        }
        
        let fullName = "\(firstName) \(lastName)"
        
        // Compute the user's age based on their birthdate
        let now = Date()
        let ageComponents = Calendar.current.dateComponents([.year], from: birthdate, to: now)
        let age = ageComponents.year!
        let weightValue = weight
        
        // Create a new document in the "Users" collection
        var ref: DocumentReference? = nil
        ref = db.collection("Users").addDocument(data: [
            "first_name": firstName,
            "last_name": lastName,
            "age": age,
            "weight": weightValue,
            "birthday": birthdate
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                if let documentID = ref?.documentID {
                    print("Document added with ID: \(documentID)")
                    
                    // Save the current user's ID to UserDefaults so we can send it to the Flask server later
                    UserDefaults.standard.set(documentID, forKey: "currentUserID")
                    
                    // Add the empty subcollections
                    ref?.collection("ExerciseEntries").document().setData([:]) { err in
                        if let err = err {
                            print("Error adding ExerciseEntries subcollection: \(err)")
                        } else {
                            print("ExerciseEntries subcollection added for user \(documentID)")
                        }
                    }
                    
                    ref?.collection("Meals").document().setData([:]) { err in
                        if let err = err {
                            print("Error adding Meals subcollection: \(err)")
                        } else {
                            print("Meals subcollection added for user \(documentID)")
                        }
                    }
                    
                    trainModel(userId: documentID)
                    predictActivity(userId: documentID, date: "June 9") { result in
                        switch result {
                        case .success(let response):
                            // Assign the response to a variable or perform any desired action
                            let serverResponse = response
                            print("Received response: \(serverResponse)")
                            
                        case .failure(let error):
                            // Handle the error
                            print("Request failed with error: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("Error retrieving document ID")
                }
            }
        }
//        predictActivity(userId: <#T##String#>, date: <#T##String#>, completion: (Result<[String : Any], any Error>) -> Void)
        
        // Update the isNewUser state variable
        isNewUser = false
        isShowingHomeView = true
        
        // Dismiss the pop-up view
        presentationMode.wrappedValue.dismiss()
    }
    func next1Tapped() {
        if currentPage == .userInfo {
            currentPage = .additionalInfo
        } else if currentPage == .additionalInfo {
//            let fullName = "\(firstName) \(lastName)"
            // Save user information or perform necessary actions
            
            // Update the isNewUser and isShowingHomeView state variables
            isNewUser = false
            isShowingHomeView = true
            
            // Dismiss the pop-up view
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    let baseURL = URL(string: "http://your-flask-server-url.com%22%29%21/")
    
    func trainModel(userId: String) {
        // Define the endpoint URL for the predictSleep route
        guard let baseURL = baseURL,
                  var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            else {
                print("Invalid base URL")
                return
            }
            
            urlComponents.path.append("/trainModel")
            
            // Prepare the request URL
            guard let url = urlComponents.url else {
                print("Invalid URL")
                return
            }

        // Prepare the request body
        let requestBody: [String: String] = ["userId": userId]

        // Create the request object
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Set the request body
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        // Send the request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: (error.localizedDescription)")
            }

            if let data = data {
                // Parse and handle the response data
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response: (responseJSON)")
                }
            }
        }.resume()
    }

    // Example function to send a POST request to predictSleep route
    func predictActivity(userId: String, date: String, completion: @escaping (Result<[String: Any], Error>) -> Void) {
        // Define the endpoint URL for the predictSleep route
        guard let baseURL = baseURL,
                  var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
            else {
                print("Invalid base URL")
                return
            }
            
            urlComponents.path.append("/predictActivity")
            
            // Prepare the request URL
            guard let url = urlComponents.url else {
                print("Invalid URL")
                return
            }

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
                print("Error: (error.localizedDescription)")
            }

            if let data = data {
                // Parse and handle the response data
                if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Response: (responseJSON)")
                    completion(.success(responseJSON)) // Pass the response data to the completion handler
                }
            }
        }.resume()
    }
}
    
struct UserInfoView: View {
    
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var birthdate: Date
    @Binding var weight: Int
    var nextButtonTapped: () -> Void
    
    var body: some View {
        VStack{
            Text("Welcome!")
                .font(.system(size: 23.0, weight: .bold))
                .foregroundColor(Color("Color 4"))
            Text("Enter new user Information")
                .font(.system(size: 16.0, weight: .semibold))
                .foregroundColor(Color("Color 4"))
                .multilineTextAlignment(.center)
        }.padding(.vertical, 80)
        
        HStack{
            Spacer()
            VStack{
                Text("First Name:")
                    .font(.system(size: 16.0, weight: .semibold))
                    .foregroundColor(Color("Color 4"))
                    .frame(alignment: .leading)
                    .padding(0)
                TextField("First Name", text: $firstName)
                    .textFieldStyle(.roundedBorder)
            }
            Spacer()
            VStack{
                Text("Last Name:")
                    .font(.system(size: 16.0, weight: .semibold))
                    .foregroundColor(Color("Color 4"))
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(.roundedBorder)
            }
        }
        .padding()
        
        HStack{
            Text("Birth Date:")
                .font(.system(size: 16.0, weight: .semibold))
                .foregroundColor(Color("Color 4"))
                .padding(0)
            
            DatePicker("Birthdate", selection: $birthdate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
                .padding()
        }
        
        HStack{
            Text("Weight:")
                .font(.system(size: 16.0, weight: .semibold))
                .foregroundColor(Color("Color 4"))
                .padding(0)
            TextField("Weight", value: $weight, format: .number)
                .textFieldStyle(.roundedBorder)
                .frame(width:100)
            
        }.padding()
        
        
        Button(action: nextButtonTapped) {
            Image(systemName: "arrow.forward")
                .font(.system(size: 15.0, weight: .bold))
                .foregroundColor(.white)
                .padding()
                .background(Color("Color 4"))
                .cornerRadius(10)
        }
        .padding(80)
        //            .frame()
    }
}

struct ActivityHistoryView: View {
    struct UserData: Codable {
        var activities: [String] = []
    }
    
    var nextButtonTapped: () -> Void
    var history: [UserData] = []
    
    var body: some View{
//        ScrollView{
            CalendarView().padding()
            Text("[User name]'s Month of Activities").padding(.bottom, 30).bold()
        Text("For each day above, click and input workout activities you have done or want to do on that day. Tap 'Begin' when complete!").padding()
            Button(action: nextButtonTapped) {
                Text("Begin")
                    .font(.system(size: 15.0, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("Color 4"))
                    .cornerRadius(10)
            }
            .padding(80)
    //        }
    }
}

struct NewUserView_Previews: PreviewProvider {
    static var previews: some View {
        NewUserView(isNewUser: .constant(true), isShowingHomeView: .constant(false))
    }
}
