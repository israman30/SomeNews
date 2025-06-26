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
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if let image = article.urlToImage, let url = URL(string: image) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ZStack {
                                Color.gray.opacity(0.2)
                                ProgressView()
                            }
                            .frame(height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 220)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        case .failure:
                            ZStack {
                                Color.gray.opacity(0.2)
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            }
                            .frame(height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.bottom, 16)
                }

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        if let author = article.author {
                            Label(author, systemImage: "person.fill")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if let date = article.publishedAt {
                            Label(date, systemImage: "calendar")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.bottom, 4)

                    if let title = article.title {
                        Text(title)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .padding(.bottom, 2)
                    }

                    Divider()
                        .padding(.vertical, 4)

                    if let description = article.description {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.primary)
                            .lineSpacing(4)
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.systemBackground))
                        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4)
                )
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .padding(.top)
        }
    }
    
}

#Preview {
    ArticleDetailView(article: Articles(author: "Someone", title: "Somet Title", description: "This is the place for the description", url: "", urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918", publishedAt: "12/20/23"))
}
