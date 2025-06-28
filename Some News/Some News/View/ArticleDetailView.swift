//
//  ArticleDetailView.swift
//  Some News
//
//  Created by Israel Manzo on 3/29/23.
//

import SwiftUI

// MARK: - Article Image View Component
struct ArticleImageView: View {
    let imageURL: String?
    
    var body: some View {
        if let image = imageURL, let url = URL(string: image) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.gray.opacity(0.2)
                        ProgressView()
                            .accessibilityLabel("Loading article image")
                    }
                    .frame(minHeight: 200, maxHeight: 300)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Article image loading")
                    .accessibilityAddTraits(.updatesFrequently)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(minHeight: 200, maxHeight: 300)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .accessibilityLabel("Article featured image")
                        .accessibilityAddTraits(.isImage)
                case .failure:
                    ZStack {
                        Color.gray.opacity(0.2)
                        Image(systemName: "photo")
                            .font(.system(size: 40, weight: .light))
                            .foregroundColor(.gray)
                            .accessibilityHidden(true)
                    }
                    .frame(minHeight: 200, maxHeight: 300)
                    .frame(maxWidth: .infinity)
                    .accessibilityLabel("Article image not available")
                    .accessibilityAddTraits(.isImage)
                @unknown default:
                    EmptyView()
                }
            }
            .padding(.bottom, 16)
        }
    }
}

// MARK: - Article Body Content Component
struct ArticleBodyView: View {
    let article: Articles
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Author and Date Section
            ArticleMetadataView(article: article)
            
            // Article Title
            if let title = article.title {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                    .padding(.bottom, 2)
                    .accessibilityLabel("Article title: \(title)")
                    .accessibilityAddTraits(.isHeader)
                    .accessibilityHeading(.h1)
            }

            Divider()
                .padding(.vertical, 4)
                .accessibilityHidden(true)

            // Article Description
            if let description = article.description {
                Text(description)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineSpacing(4)
                    .accessibilityLabel("Article description: \(description)")
                    .accessibilityAddTraits(.isStaticText)
            }
        }
        .padding(20)
        .padding(.horizontal)
        .padding(.bottom, 24)
    }
}

// MARK: - Article Metadata Component
struct ArticleMetadataView: View {
    let article: Articles
    
    var body: some View {
        HStack {
            if let author = article.author {
                Label(author, systemImage: "person.fill")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Author: \(author)")
                    .accessibilityAddTraits(.isStaticText)
            }
            Spacer()
            if let date = article.publishedAt {
                Label(date, systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Published: \(date)")
                    .accessibilityAddTraits(.isStaticText)
            }
        }
        .padding(.bottom, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Article metadata")
    }
}

// MARK: - Main Article Detail View
struct ArticleDetailView: View {
    
    var article: Articles
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.sizeCategory) private var sizeCategory
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Article Image Section
                ArticleImageView(imageURL: article.urlToImage)
                
                // Article Content Section
                ArticleBodyView(article: article)
            }
            .padding(.top)
        }
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Article detail view")
        .accessibilityHint("Scroll to read the full article content")
        // Dynamic Type Support
        .environment(\.sizeCategory, sizeCategory)
        // High Contrast Support
        .environment(\.legibilityWeight, .regular)
        // Reduce Motion Support
        .animation(.easeInOut(duration: 0.3), value: colorScheme)
    }
    
    // MARK: - Accessibility Helper Methods
    
    private func getAccessibleImageDescription() -> String {
        if let title = article.title {
            return "Featured image for article: \(title)"
        }
        return "Article featured image"
    }
    
    private func getAccessibleContentDescription() -> String {
        var description = ""
        
        if let title = article.title {
            description += "Title: \(title). "
        }
        
        if let author = article.author {
            description += "Author: \(author). "
        }
        
        if let date = article.publishedAt {
            description += "Published: \(date). "
        }
        
        if let desc = article.description {
            description += "Description: \(desc)"
        }
        
        return description
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        ArticleDetailView(article: Articles(
            author: "John Doe",
            title: "Breaking News: Major Technological Advancement",
            description: "This is a comprehensive description of the article that provides detailed information about the technological breakthrough and its implications for the future of computing and artificial intelligence.",
            url: "https://example.com/article",
            urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
            publishedAt: "December 20, 2023"
        ))
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationView {
        ArticleDetailView(article: Articles(
            author: "Jane Smith",
            title: "Environmental Impact Study Results",
            description: "A detailed analysis of environmental changes and their long-term effects on global ecosystems.",
            url: "https://example.com/article2",
            urlToImage: nil,
            publishedAt: "December 21, 2023"
        ))
    }
    .preferredColorScheme(.dark)
}

#Preview("Large Text") {
    NavigationView {
        ArticleDetailView(article: Articles(
            author: "Dr. Michael Johnson",
            title: "Scientific Discovery in Quantum Physics",
            description: "Researchers have made a groundbreaking discovery in quantum physics that could revolutionize our understanding of the universe.",
            url: "https://example.com/article3",
            urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
            publishedAt: "December 22, 2023"
        ))
    }
    .environment(\.sizeCategory, .accessibilityExtraExtraExtraLarge)
}
