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
        VStack {
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image.image?.resizable()
                    .scaledToFit()
            }
            VStack(alignment: .leading) {
                Text(article.author ?? "")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(article.title ?? "no title")
                    .font(.title)
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
                Text(article.description?.uppercased() ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .cornerRadius(10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0), lineWidth: 1)
        }
    }
}

#Preview {
    CardView(article: Articles(author: "Someone", title: "Somet Title", description: "This is the place for the description", url: "", urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918", publishedAt: "12/20/23"))
}


