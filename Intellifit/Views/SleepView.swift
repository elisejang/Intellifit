//
//  SleepView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/3/23.
//

import SwiftUI

struct SleepView: View {
    @State private var suggestedWakeTime: Date?
    var body: some View {
//        ZStack {
//            Color.purple
//            Image(systemName: "moon.fill")
//                .foregroundColor(Color.white)
//                .font(.system(size:100.0))
//        }
        VStack{
            Spacer()
            Text("Set Current Sleep Time:")
            TimePickerView(suggestedWakeTime: $suggestedWakeTime)
            
            Spacer()
            
            Text("Suggested Wake Time:")
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
                        .foregroundColor(.gray)
                    
                    Picker("Minute", selection: $selectedMinute) {
                        ForEach(0..<60) { minute in
                            Text("\(minute)")
                                .tag(minute)
                        }
                    }
                    .frame(width: 80)
                    .clipped()
                    
                    Picker("Period", selection: $selectedPeriod) {
                        Text("AM").tag("AM")
                        Text("PM").tag("PM")
                    }
                    .frame(width: 80)
                    .clipped()
                    
                }
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
                Button(action: calculateWakeTime){
                    Text("Enter")
                }
                    .padding()
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color("Color 2").opacity(0.4), lineWidth: 5)
//                    )
                    .foregroundColor(Color.white)
                    .background(Color("Color 2")).cornerRadius(10)
                
            }
            .padding()
        }
    }
    func calculateWakeTime() {
        let calendar = Calendar.current
        var components = DateComponents()

        components.hour = selectedHour
        components.minute = selectedMinute

        if selectedPeriod == "PM" {
            components.hour! += 12
        }

        if let sleepTime = calendar.date(from: components) {
            let wakeTime = calendar.date(byAdding: .hour, value: 8, to: sleepTime)
            suggestedWakeTime = wakeTime
        }
    }
}

struct SleepView_Previews: PreviewProvider {
    static var previews: some View {
        SleepView()
    }
}
