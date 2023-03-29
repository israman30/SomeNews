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
            AsyncImage(url: URL(string: article.urlToImage ?? "")) { image in
                image.image?.resizable()
                    .scaledToFit()
            }
            VStack(alignment: .leading) {
                
                
                Text(article.author ?? "")
                    .font(.headline)
                    .foregroundColor(.secondary)
                Text(article.title ?? "")
                    .font(.title)
                    .foregroundColor(.primary)
                    .fontWeight(.bold)
                Text(article.description?.uppercased() ?? "")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding()
            .cornerRadius(10)
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0), lineWidth: 1)
            }

        }
        
    }
    
}

struct ArticleDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ArticleDetailView(article: Articles(author: "Someone", title: "Somet Title", description: "This is the place for the description", url: "", urlToImage: "", publishedAt: "12/20/23"))
    }
}
