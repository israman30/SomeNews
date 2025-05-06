//
//  ArticleDetailView.swift
//  Some News
//
//  Created by Israel Manzo on 3/29/23.
//

import SwiftUI

struct ArticleDetailView: View {
    
    var article: Articles
    
    var body: some View {
        VStack {
            if let image = article.urlToImage {
                AsyncImage(url: URL(string: image)) { image in
                    image.image?.resizable()
                        .scaledToFit()
                }
            }
            
            VStack(alignment: .leading) {
                if let author = article.author, let title = article.title, let description = article.description?.uppercased() {
                    Text(author)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(title)
                        .font(.title)
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                    Text(description)
                        .padding(.top, 2)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding()
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0),
                        lineWidth: 1
                    )
            }

        }
        
    }
    
}

#Preview {
    ArticleDetailView(article: Articles(author: "Someone", title: "Somet Title", description: "This is the place for the description", url: "", urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918", publishedAt: "12/20/23"))
}
