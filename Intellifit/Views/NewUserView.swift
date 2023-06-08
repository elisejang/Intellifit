//
//  NewUserView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/7/23.
//

import SwiftUI

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
    @Environment(\.presentationMode) var presentationMode
    @Binding var isNewUser: Bool
    @Binding var isShowingHomeView: Bool
        
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var birthdate = Date()
    @State var weight: String = ""
        
    var body: some View {
        VStack {
            Text("Welcome!")
                .font(.system(size: 23.0, weight: .bold))
                .foregroundColor(Color("Color 4"))
            Text("Enter new user Information")
                .font(.system(size: 16.0, weight: .semibold))
                .foregroundColor(Color("Color 4"))
                .multilineTextAlignment(.center)
            
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
                TextField("Weight", text: $weight)
                    .textFieldStyle(.roundedBorder)
                    .frame(width:100)

            }.padding()
            
            
            Button(action: beginButtonTapped) {
                Text("Begin")
                    .font(.system(size: 23.0, weight: .bold))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color("Color 4"))
                    .cornerRadius(10)
            }
        }
        .padding()
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("Color 3").opacity(0.4), lineWidth: 5)
                .padding(10)
        )
    }
    
    func beginButtonTapped() {
        let fullName = "\(firstName) \(lastName)"
        
        // Update the isNewUser state variable
        isNewUser = false
        isShowingHomeView = true

        // Dismiss the pop-up view
        presentationMode.wrappedValue.dismiss()
    }
}

struct NewUserView_Previews: PreviewProvider {
    static var previews: some View {
        NewUserView(isNewUser: .constant(true), isShowingHomeView: .constant(false))
    }
}
