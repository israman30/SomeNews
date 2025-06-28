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
            // Image section
            if let image = article.urlToImage, let url = URL(string: image) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color(.systemGray5)
                                .accessibilityHidden(true)
                            ProgressView()
                                .accessibilityLabel("Loading article image")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                            .transition(.opacity)
                            .accessibilityHidden(true) // Hide from VoiceOver as it's decorative
                    case .failure:
                        ZStack {
                            Color(.systemGray5)
                                .accessibilityHidden(true)
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundColor(.secondary)
                                .accessibilityLabel("No image available")
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(height: 200)
                .clipped()
            } else {
                ZStack {
                    Color(.systemGray5)
                        .accessibilityHidden(true)
                    Image(systemName: "photo")
                        .font(.largeTitle)
                        .foregroundColor(.secondary)
                        .accessibilityLabel("No image available")
                }
                .frame(height: 200)
                .clipped()
            }
            
            // Text section with improved accessibility
            VStack(alignment: .leading, spacing: 8) {
                if let author = article.author {
                    Text(author)
                        .font(.headline)
                        .foregroundColor(.primary)
                        .accessibilityLabel("Author: \(author)")
                }
                if let title = article.title {
                    Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .accessibilityLabel("Title: \(title)")
                }
                if let publishedAt = article.publishedAt {
                    Text(publishedAt)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .accessibilityLabel("Published: \(publishedAt)")
                }
            }
            .padding(16)
            .background(Color(.systemBackground))
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(radius: 6, y: 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("Double tap to read full article")
        .accessibilityAddTraits(.isButton)
        .accessibilityAction(.default) {
            // Handle tap action for accessibility
            if let url = article.url, let articleURL = URL(string: url) {
                UIApplication.shared.open(articleURL)
            }
        }
    }
    
    // Computed property for accessibility label
    private var accessibilityLabel: String {
        var label = ""
        
        if let title = article.title {
            label += "Article: \(title)"
        }
        
        if let author = article.author {
            label += ". By \(author)"
        }
        
        if let publishedAt = article.publishedAt {
            label += ". Published \(publishedAt)"
        }
        
        return label.isEmpty ? "News article" : label
    }
}

// MARK: - Preview with different configurations
#Preview("Light Theme") {
    CardView(
        article: Articles(
            author: "John Doe",
            title: "Breaking News: Major Discovery in Technology",
            description: "This is the place for the description, for the body of the card where should be more text.",
            url: "https://example.com",
            urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
            publishedAt: "December 20, 2023"
        )
    )
    .frame(height: 280)
    .preferredColorScheme(.light)
}

#Preview("Dark Theme") {
    CardView(
        article: Articles(
            author: "Jane Smith",
            title: "Environmental Impact Study Shows Promising Results",
            description: "This is the place for the description, for the body of the card where should be more text.",
            url: "https://example.com",
            urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
            publishedAt: "December 20, 2023"
        )
    )
    .frame(height: 280)
    .preferredColorScheme(.dark)
}

#Preview("Landscape") {
    HStack {
        CardView(
            article: Articles(
                author: "Tech Reporter",
                title: "AI Breakthrough in Medical Imaging",
                description: "This is the place for the description, for the body of the card where should be more text.",
                url: "https://example.com",
                urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
                publishedAt: "December 20, 2023"
            )
        )
        .frame(width: 300, height: 280)
        
        CardView(
            article: Articles(
                author: "Science Writer",
                title: "New Study Reveals Climate Change Patterns",
                description: "This is the place for the description, for the body of the card where should be more text.",
                url: "https://example.com",
                urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
                publishedAt: "December 19, 2023"
            )
        )
        .frame(width: 300, height: 280)
    }
    .padding()
}


