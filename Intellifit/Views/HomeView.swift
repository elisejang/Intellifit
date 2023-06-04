//
//  HomeView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/3/23.
//

import SwiftUI

struct HomeView: View {
    @State private var isShowingNewUserPopUp = false
    
    var body: some View {
        ZStack {
            Color.blue
            Image(systemName: "house.fill")
                .foregroundColor(Color.white)
                .font(.system(size:100.0))
            
            VStack {
                Spacer()
                
                Button("New User") {
                    isShowingNewUserPopUp = true
                }
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(10)
                
            }.padding()

        }
        .sheet(isPresented: $isShowingNewUserPopUp) {
            NewUserPopUp(title: "Error", text: "Sorry, that email address is already used!", buttonText: "OK")
        }
    }
}

private class PopUpView: UIView {
    let popupView = UIView(frame: CGRect.zero)
    let popupTitle = UILabel(frame: CGRect.zero)
    let popupText = UILabel(frame: CGRect.zero)
        let popupButton = UIButton(frame: CGRect.zero)
        
        let BorderWidth: CGFloat = 2.0
        
        init() {
            super.init(frame: CGRect.zero)
            // Semi-transparent background
            backgroundColor = UIColor.black.withAlphaComponent(0.3)
            
            // Popup Background
            popupView.backgroundColor = .blue
            popupView.layer.borderWidth = BorderWidth
            popupView.layer.masksToBounds = true
            popupView.layer.borderColor = UIColor.white.cgColor
            
            // Popup Title
            popupTitle.textColor = UIColor.white
            popupTitle.backgroundColor = UIColor.yellow
            popupTitle.layer.masksToBounds = true
            popupTitle.adjustsFontSizeToFitWidth = true
            popupTitle.clipsToBounds = true
            popupTitle.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
            popupTitle.numberOfLines = 1
            popupTitle.textAlignment = .center
            
            // Popup Text
            popupText.textColor = UIColor.white
            popupText.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
            popupText.numberOfLines = 0
            popupText.textAlignment = .center
            
            // Popup Button
            popupButton.setTitleColor(UIColor.white, for: .normal)
            popupButton.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
            popupButton.backgroundColor = UIColor.yellow
            
            popupView.addSubview(popupTitle)
            popupView.addSubview(popupText)
            popupView.addSubview(popupButton)
            
            // Add the popupView(box) in the PopUpWindowView (semi-transparent background)
            addSubview(popupView)
            
            
            // PopupView constraints
            popupView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                popupView.widthAnchor.constraint(equalToConstant: 293),
                popupView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
                popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
                ])
            
            // PopupTitle constraints
            popupTitle.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                popupTitle.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: BorderWidth),
                popupTitle.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -BorderWidth),
                popupTitle.topAnchor.constraint(equalTo: popupView.topAnchor, constant: BorderWidth),
                popupTitle.heightAnchor.constraint(equalToConstant: 55)
                ])
            
            
            // PopupText constraints
            popupText.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                popupText.heightAnchor.constraint(greaterThanOrEqualToConstant: 67),
                popupText.topAnchor.constraint(equalTo: popupTitle.bottomAnchor, constant: 8),
                popupText.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 15),
                popupText.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -15),
                popupText.bottomAnchor.constraint(equalTo: popupButton.topAnchor, constant: -8)
                ])

            
            // PopupButton constraints
            popupButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                popupButton.heightAnchor.constraint(equalToConstant: 44),
                popupButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: BorderWidth),
                popupButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -BorderWidth),
                popupButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -BorderWidth)
                ])
            
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
}

struct NewUserPopUp : View {
    @Environment(\.presentationMode) var presentationMode
        
        let title: String
        let text: String
        let buttonText: String
        
        var body: some View {
            VStack {
                Text(title)
                    .font(.system(size: 23.0, weight: .bold))
                    .foregroundColor(.white)
                
                Text(text)
                    .font(.system(size: 16.0, weight: .semibold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Button(action: dismissView) {
                    Text(buttonText)
                        .font(.system(size: 23.0, weight: .bold))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(10)
        }
        
        func dismissView() {
            presentationMode.wrappedValue.dismiss()
        }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
