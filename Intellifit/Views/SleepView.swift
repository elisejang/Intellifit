//
//  SleepView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/3/23.
//

import SwiftUI
import Foundation

struct SleepView: View {
    @State private var suggestedWakeTime: Date?
    var body: some View {
        VStack{
            Spacer()
            
            Text("Set Current Sleep Time:")
            TimePickerView(suggestedWakeTime: $suggestedWakeTime)

            Spacer()

            Text("Suggested Wake Time:").padding()
            if let wakeTime = suggestedWakeTime {
                Text("\(formatTime(wakeTime))")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            } else {
                Text("Select Sleep Time")
                    .font(.title)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
    }
    
    func formatTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}

struct TimePickerView: View {
    @Binding var suggestedWakeTime: Date?
    @State private var selectedHour = 0
    @State private var selectedMinute = 0
    @State private var selectedPeriod = "AM"

    var body: some View {
        VStack {
            HStack{
                HStack {
                    Picker("Hour", selection: $selectedHour) {
                        ForEach(0..<24) { hour in
                            Text("\(hour)")
                                .tag(hour)
                        }
                    }
                    .frame(width: 60)
                    .clipped()

                    Text(":")
                        .font(.title)
                        .foregroundColor(.black)

                    Picker("Minute", selection: $selectedMinute) {
                        ForEach(0..<60) { minute in
                            Text("\(minute)")
                                .tag(minute)
                        }
                    }
                    .frame(width: 60)
                    .clipped()

                    Picker("Period", selection: $selectedPeriod) {
                        Text("AM").tag("AM")
                        Text("PM").tag("PM")
                    }
                    .frame(width: 70, height: 20)
                    .clipped()

                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)

                Button(action: {
                    predictSleep(calories: 0.0) // Change 0.0 to actual model generated cals
                }) {
                    Text("Enter")
                }
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color("Color 3")).cornerRadius(10)
                    .frame(height: 50)

            }
            .padding()
        }
    }
    // Define the base URL of the Flask server
    let baseURL = URL(string: "http://your-flask-server-url.com%22%29%21/")

    // Example function to send a POST request to predictSleep route
    func predictSleep(calories: Float) {
        guard let baseURL = baseURL else {
                print("Invalid base URL")
                return
            }

            // Define the endpoint URL for the predictSleep route
            let url = baseURL.appendingPathComponent("/predictSleep")

            // Prepare the request body
            let requestBody: [String: Float] = [
                "calories": calories
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
                    print("Error: \(error.localizedDescription)")
                    return
                }

                if let data = data {
                    // Parse and handle the response data
                    if let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Response: \(responseJSON)")
                    }
                }
            }.resume()
    }

    // Call the predictSleep function
//    predictSleep()
}

struct SleepView_Previews: PreviewProvider {
    static var previews: some View {
        SleepView()
    }
}
