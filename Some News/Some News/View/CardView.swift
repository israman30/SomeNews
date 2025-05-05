//
//  CardView.swift
//  Some News
//
//  Created by Israel Manzo on 3/27/23.
//
// 219d19ee586b4a049fafb28d3ecb7707
import SwiftUI

struct CardView: View {
    
    var article: Articles
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image.image?.resizable()
                    .scaledToFit()
            }
            .cornerRadius(10)
            VStack {
                Spacer()
                VStack(alignment: .leading) {
                    Text(article.author ?? "")
                        .font(.headline)
                    Text(article.title ?? "no title")
                        .font(.title)
                        .fontWeight(.bold)
                        .lineLimit(2)
                }
                .padding(.horizontal, 5)
                .frame(maxWidth: .infinity, maxHeight: 100)
                .foregroundStyle(.white)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .top, endPoint: .bottom)
                )
            }
        }
        .cornerRadius(10)
    }
}

#Preview {
    CardView(
        article: Articles(
            author: "Someone",
            title: "Somet Title",
            description: "This is the place for the description, for the body of the card where should be more text.",
            url: "",
            urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
            publishedAt: "12/20/23"
        )
    )
    .frame(height: 220)
}


