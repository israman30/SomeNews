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
            // Background image with improved handling
            if let imageUrl = article.urlToImage, !imageUrl.isEmpty {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        // Loading state
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .overlay(
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            )
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure(_):
                        // Fallback for failed image loading
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                            )
                    @unknown default:
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    }
                }
                .clipped()
            } else {
                // No image available
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: "newspaper")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                    )
            }
            
            // Content overlay with improved layout
            VStack {
                Spacer()
                
                VStack(alignment: .leading, spacing: 8) {
                    // Author and date section
                    HStack {
                        if let author = article.author, !author.isEmpty {
                            Text(author)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.white.opacity(0.9))
                                .lineLimit(1)
                        }
                        
                        Spacer()
                        
                        if let publishedAt = article.publishedAt {
                            Text(formatDate(publishedAt))
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.7))
                        }
                    }
                    
                    // Title section
                    if let title = article.title, !title.isEmpty {
                        Text(title)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                    }
                    
                    // Description preview (optional)
                    if let description = article.description, !description.isEmpty {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.clear,
                            Color.black.opacity(0.3),
                            Color.black.opacity(0.7)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
        .frame(height: 280)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
    }
    
    // Helper function to format date
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        
        return dateString
    }
}

#Preview {
    VStack(spacing: 20) {
        CardView(
            article: Articles(
                author: "John Doe",
                title: "Breaking News: Major Technological Breakthrough in Renewable Energy",
                description: "Scientists have discovered a revolutionary new method for harnessing solar energy that could transform the renewable energy industry.",
                url: "",
                urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
                publishedAt: "2023-12-20T10:30:00Z"
            )
        )
        
        CardView(
            article: Articles(
                author: "Jane Smith",
                title: "Article Without Image",
                description: "This article demonstrates how the card looks without an image.",
                url: "",
                urlToImage: "",
                publishedAt: "2023-12-19T15:45:00Z"
            )
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}


