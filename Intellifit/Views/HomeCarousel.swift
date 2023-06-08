//
//  HomeCarousel.swift
//  Intellifit
//
//  Created by Megan Nguyen on 6/5/23.
//

import SwiftUI

struct HomeCarousel: View {
    var body: some View {
        CardCarouselView()
    }
}

struct Card: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}

struct CardCarouselView: View {
    let cards: [Card] = [
        Card(title: "Calories (food - burned)", imageName: "card1"),
        Card(title: "Workout of the Day", imageName: "card2"),
        Card(title: "Sleep Stats", imageName: "card2"),
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 16){
                ForEach(cards) { card in
                    CardView(card: card)
                }
            }
            .padding(16)
        }
    }
}

struct CardView: View {
    let card: Card
    
    var body: some View {
        VStack {
            Image(card.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 280, height: 180)
                .cornerRadius(10)
            
            Text(card.title)
                .font(.headline)
                .padding(.top, 8)
                .foregroundColor(.primary)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("Color 1").opacity(0.4), lineWidth: 5)
        )
    }
}

struct HomeCarousel_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
