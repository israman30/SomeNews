//
//  CardView.swift
//  Some News
//
//  Created by Israel Manzo on 3/27/23.
//
// 219d19ee586b4a049fafb28d3ecb7707
import SwiftUI

struct CardView: View {
    
    var article: Articles?
    var fetchedData: Article?
    
    var body: some View {
        VStack {
            if let fetchedURLToImage = fetchedData?.urlToImage, let urlToImage = article?.urlToImage {
                AsyncImage(url: URL(string: urlToImage.isEmpty ? fetchedURLToImage : urlToImage)!) { image in
                    image.image?.resizable()
                        .scaledToFit()
                }
            }
            VStack(alignment: .leading) {
                if let author = article?.author, let fetchedAuthor = fetchedData?.author, let title = article?.title, let fetchedTitle = fetchedData?.title, let body = article?.description, let fetchedBody = fetchedData?.body {
                    Text(author.isEmpty ? fetchedAuthor : author)
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text(title.isEmpty ? fetchedTitle : title)
                        .font(.title)
                        .foregroundColor(.primary)
                        .fontWeight(.bold)
                    Text(body.isEmpty ? fetchedBody : body)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .cornerRadius(10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(.sRGB, red: 150/255, green: 150/255, blue: 150/255, opacity: 0), lineWidth: 1)
        }
    }
}

//#Preview {
//    CardView(article: Articles(author: "Someone", title: "Somet Title", description: "This is the place for the description", url: "", urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918", publishedAt: "12/20/23"))
//}


