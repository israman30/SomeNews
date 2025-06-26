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
        VStack(alignment: .leading, spacing: 0) {
            // Image Section
            ZStack {
                if let imageUrl = article.urlToImage, !imageUrl.isEmpty {
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            // Loading state
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .overlay(
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                                )
                        case .success(let image):
                            // Success state
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                        case .failure(_):
                            // Error state
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .overlay(
                                    Image(systemName: "photo")
                                        .font(.system(size: 30))
                                        .foregroundColor(.gray)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    // No image available
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .overlay(
                            Image(systemName: "newspaper")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                        )
                }
            }
            .frame(height: 200)
            .clipped()
            
            // Content Section
            VStack(alignment: .leading, spacing: 8) {
                // Author and Date
                HStack {
                    if let author = article.author, !author.isEmpty {
                        Text(author)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                    
                    Spacer()
                    
                    if let publishedAt = article.publishedAt {
                        Text(formatDate(publishedAt))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Title
                if let title = article.title, !title.isEmpty {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(3)
                        .multilineTextAlignment(.leading)
                }
                
                // Description
                if let description = article.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
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
                description: "Scientists have discovered a revolutionary new method for harnessing solar energy that could transform the renewable energy industry and help combat climate change.",
                url: "https://example.com",
                urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
                publishedAt: "2023-12-20T10:30:00Z"
            )
        )
        
        CardView(
            article: Articles(
                author: "Jane Smith",
                title: "Short Title",
                description: "A brief description of the article.",
                url: "https://example.com",
                urlToImage: "",
                publishedAt: "2023-12-19T15:45:00Z"
            )
        )
    }
    .padding()
    .background(Color(.systemGroupedBackground))
}


