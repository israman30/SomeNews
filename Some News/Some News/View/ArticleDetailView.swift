//
//  ArticleDetailView.swift
//  Some News
//
//  Created by Israel Manzo on 3/29/23.
//

import SwiftUI

struct ArticleDetailView: View {
    
    var article: Articles
    @State private var imageLoadError = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Enhanced Image Section
                imageSection
                
                // Content Section
                contentSection
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
    }
    
    // MARK: - Image Section
    private var imageSection: some View {
        ZStack {
            if let imageUrl = article.urlToImage, !imageUrl.isEmpty {
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(height: 250)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipped()
                    case .failure(_):
                        fallbackImageView
                    @unknown default:
                        fallbackImageView
                    }
                }
            } else {
                fallbackImageView
            }
        }
    }
    
    private var fallbackImageView: some View {
        VStack {
            Image(systemName: "photo")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            Text("No Image Available")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(height: 250)
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
    }
    
    // MARK: - Content Section
    private var contentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Title
            if let title = article.title, !title.isEmpty {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
            }
            
            // Author and Date Row
            HStack {
                if let author = article.author, !author.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "person.circle.fill")
                            .foregroundColor(.blue)
                        Text(author)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if let publishedAt = article.publishedAt, !publishedAt.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .foregroundColor(.green)
                        Text(formatDate(publishedAt))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Divider()
            
            // Description
            if let description = article.description, !description.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Summary")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.body)
                        .foregroundColor(.primary)
                        .lineLimit(nil)
                        .multilineTextAlignment(.leading)
                }
            }
            
            // Source URL
            if let url = article.url, !url.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Source")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    Link(destination: URL(string: url) ?? URL(string: "https://example.com")!) {
                        HStack {
                            Image(systemName: "link")
                                .foregroundColor(.blue)
                            Text("Read Full Article")
                                .foregroundColor(.blue)
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.blue)
                        }
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    }
                }
            }
            
            Spacer(minLength: 20)
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    // MARK: - Helper Methods
    private func formatDate(_ dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        
        return dateString
    }
}

#Preview {
    NavigationView {
        ArticleDetailView(article: Articles(
            author: "John Doe",
            title: "Breaking News: Major Technological Breakthrough in Renewable Energy",
            description: "Scientists have discovered a revolutionary new method for harnessing solar energy that could potentially double the efficiency of current solar panels. This breakthrough technology uses advanced nanomaterials and quantum physics principles to capture and convert sunlight more effectively than ever before.",
            url: "https://example.com/article",
            urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
            publishedAt: "2023-12-20T10:30:00Z"
        ))
    }
}
