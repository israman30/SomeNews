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
        ZStack(alignment: .bottom) {
            if let image = article.urlToImage, let url = URL(string: image) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.2)
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                            .transition(.opacity)
                    case .failure:
                        ZStack {
                            Color.gray.opacity(0.2)
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(radius: 4, y: 2)
            } else {
                ZStack {
                    Color.gray.opacity(0.2)
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                }
                .frame(height: 220)
                .clipShape(RoundedRectangle(cornerRadius: 14))
                .shadow(radius: 4, y: 2)
            }

            VStack(alignment: .leading, spacing: 6) {
                if let author = article.author {
                    Text(author)
                        .font(.headline)
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                }
                if let title = article.title {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .shadow(radius: 2)
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
            .padding([.horizontal, .bottom], 8)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(radius: 6, y: 4)
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


