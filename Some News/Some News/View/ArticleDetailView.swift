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
    
    private var trimmedURL: URL? {
        guard let raw = imageURL?.trimmingCharacters(in: .whitespacesAndNewlines),
              !raw.isEmpty,
              let url = URL(string: raw) else {
            return nil
        }
        return url
    }
    
    var body: some View {
        let base = ZStack {
            Color.gray.opacity(0.2)
        }
        Group {
            if let url = trimmedURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        base
                            .overlay {
                                ProgressView()
                                    .accessibilityLabel("Loading article image")
                            }
                            .accessibilityLabel("Article image loading")
                            .accessibilityAddTraits(.updatesFrequently)
                    case .success(let image):
                        // Use aspect-fit to avoid cropping banners/logos.
                        base
                            .overlay {
                                image
                                    .resizable()
                                    .scaledToFit()
                            }
                            .accessibilityLabel("Article featured image")
                            .accessibilityAddTraits(.isImage)
                    case .failure:
                        base
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.system(size: 40, weight: .light))
                                    .foregroundColor(.gray)
                                    .accessibilityHidden(true)
                            }
                            .accessibilityLabel("Article image not available")
                            .accessibilityAddTraits(.isImage)
                    @unknown default:
                        base
                    }
                }
            } else {
                base
                    .overlay {
                        Image(systemName: "photo")
                            .font(.system(size: 40, weight: .light))
                            .foregroundColor(.gray)
                            .accessibilityHidden(true)
                    }
                    .accessibilityLabel("Article image not available")
                    .accessibilityAddTraits(.isImage)
            }
        }
        .frame(minHeight: 200, maxHeight: 300)
        .frame(maxWidth: .infinity)
        .clipped()
        .padding(.bottom, 16)
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
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Image(systemName: "person.fill")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text(formatAuthors(author))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                }
                .accessibilityLabel("Author: \(author)")
                .accessibilityAddTraits(.isStaticText)
            }
            Spacer()
            if let date = article.publishedAt {
                Label(Constants.formatDate(date), systemImage: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .accessibilityLabel("Published: \(Constants.formatDate(date))")
                    .accessibilityAddTraits(.isStaticText)
            }
        }
        .padding(.bottom, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Article metadata")
    }
    
    // Helper function to format authors for display
    private func formatAuthors(_ authorString: String) -> String {
        // Split by common delimiters and clean up
        let delimiters = [",", ";", " and ", " & "]
        var authors = [authorString]
        
        for delimiter in delimiters {
            authors = authors.flatMap { author in
                author.components(separatedBy: delimiter)
                    .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
                    .filter { !$0.isEmpty }
            }
        }
        
        // Remove duplicates and limit to reasonable number
        let uniqueAuthors = Array(Set(authors)).prefix(5)
        
        if uniqueAuthors.count == 1 {
            return uniqueAuthors.first ?? authorString
        } else if uniqueAuthors.count <= 3 {
            return uniqueAuthors.joined(separator: ", ")
        } else {
            let firstThree = Array(uniqueAuthors.prefix(3))
            return firstThree.joined(separator: ", ") + " et al."
        }
    }
}

// MARK: - Main Article Detail View
struct ArticleDetailView: View {
    
    let article: Articles
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
            description += "Published: \(Constants.formatDate(date)). "
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
            source: Source(id: nil, name: "Reuters"),
            author: "John Doe",
            title: "Breaking News: Major Technological Advancement",
            description: "This is a comprehensive description of the article that provides detailed information about the technological breakthrough and its implications for the future of computing and artificial intelligence.",
            url: "https://example.com/article",
            urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
            publishedAt: "2023-12-20T10:30:00Z"
        ))
    }
    .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    NavigationView {
        ArticleDetailView(article: Articles(
            source: Source(id: nil, name: "The Verge"),
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
            source: Source(id: nil, name: "Wired"),
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
