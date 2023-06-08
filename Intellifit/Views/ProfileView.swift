//
//  SleepView.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/3/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack{
            VStack{
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 100.0))
                    .foregroundColor(Color("Color 4"))
                Text("[User Name]")
            }
            .padding(40)
            
            VStack(alignment: .leading){
                HStack{
                    Text("Age:")
                        .font(.system(size: 20))
                        .foregroundColor(Color("Color 4"))
                        .padding(30)

                    Text("Weight:")
                        .font(.system(size: 20))
                        .foregroundColor(Color("Color 4"))
                        .padding(30)
                }
                
                VStack{
                    Text("Goal:")
                        .font(.system(size: 20))
                        .foregroundColor(Color("Color 4"))
                        .padding(30)
                }
            }
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
