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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    private var cardShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
    }
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                // Landscape/Horizontal layout
                HStack(alignment: .top, spacing: 0) {
                    // Image section - fixed width in landscape
                    articleImage(width: 200, height: 150)
                    
                    // Text section - takes remaining space
                    VStack(alignment: .leading, spacing: 8) {
                        if let sourceName = article.source?.name, !sourceName.isEmpty {
                            Text(sourceName)
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.secondary)
                                .accessibilityLabel("Source: \(sourceName)")
                        }
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
                                .lineLimit(3)
                                .accessibilityLabel("Title: \(title)")
                        }
                        if let publishedAt = article.publishedAt {
                            Text(Constants.formatDate(publishedAt))
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .accessibilityLabel("Published: \(Constants.formatDate(publishedAt))")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color(.systemBackground))
                }
            } else {
                // Portrait/Vertical layout (original design)
                VStack(alignment: .leading, spacing: 0) {
                    // Image section - always full width
                    articleImage(height: 200)
                    
                    // Text section with improved accessibility - always full width
                    VStack(alignment: .leading, spacing: 8) {
                        if let sourceName = article.source?.name, !sourceName.isEmpty {
                            Text(sourceName)
                                .font(.caption.weight(.semibold))
                                .foregroundColor(.secondary)
                                .accessibilityLabel("Source: \(sourceName)")
                        }
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
                            Text(Constants.formatDate(publishedAt))
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .accessibilityLabel("Published: \(Constants.formatDate(publishedAt))")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
                    .background(Color(.systemBackground))
                }
            }
        }
        .frame(maxWidth: .infinity)
        .mask(cardShape)
        .contentShape(cardShape)
        .compositingGroup()
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
            label += ". Published \(Constants.formatDate(publishedAt))"
        }
        
        return label.isEmpty ? "News article" : label
    }
    
    private var articleImageURL: URL? {
        guard let raw = article.urlToImage?.trimmingCharacters(in: .whitespacesAndNewlines),
              !raw.isEmpty,
              let url = URL(string: raw) else {
            return nil
        }
        return url
    }
    
    @ViewBuilder
    private func articleImage(width: CGFloat? = nil, height: CGFloat) -> some View {
        let base = ZStack {
            Color(.systemGray5).accessibilityHidden(true)
        }
        
        Group {
            if let url = articleImageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        base
                            .overlay {
                                ProgressView()
                                    .accessibilityLabel("Loading article image")
                            }
                    case .success(let image):
                        // Use aspect-fit to avoid cropping key parts of the image (common for banners/logos).
                        base
                            .overlay {
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .transition(.opacity)
                                    .accessibilityHidden(true)
                            }
                    case .failure:
                        base
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                                    .foregroundColor(.secondary)
                                    .accessibilityLabel("No image available")
                            }
                    @unknown default:
                        base
                    }
                }
            } else {
                base
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                            .accessibilityLabel("No image available")
                    }
            }
        }
        .frame(width: width, height: height)
        .clipped(antialiased: true)
    }
}

// MARK: - Preview with different configurations
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CardView(
                article: Articles(
                    source: Source(id: nil, name: "Reuters"),
                    author: "John Doe",
                    title: "Breaking News: Major Discovery in Technology",
                    description: "This is the place for the description, for the body of the card where should be more text.",
                    url: "https://example.com",
                    urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
                    publishedAt: "2023-12-20T10:30:00Z"
                )
            )
            .frame(height: 280)
            .preferredColorScheme(.light)
            .previewDisplayName("Light Theme")
            
            CardView(
                article: Articles(
                    source: Source(id: nil, name: "The Verge"),
                    author: "Jane Smith",
                    title: "Environmental Impact Study Shows Promising Results",
                    description: "This is the place for the description, for the body of the card where should be more text.",
                    url: "https://example.com",
                    urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
                    publishedAt: "2023-12-19T15:45:00Z"
                )
            )
            .frame(height: 280)
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Theme")
            
            HStack {
                CardView(
                    article: Articles(
                        source: Source(id: nil, name: "TechCrunch"),
                        author: "Tech Reporter",
                        title: "AI Breakthrough in Medical Imaging",
                        description: "This is the place for the description, for the body of the card where should be more text.",
                        url: "https://example.com",
                        urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
                        publishedAt: "2023-12-18T09:15:00Z"
                    )
                )
                .frame(width: 300, height: 280)
                
                CardView(
                    article: Articles(
                        source: Source(id: nil, name: "Wired"),
                        author: "Science Writer",
                        title: "New Study Reveals Climate Change Patterns",
                        description: "This is the place for the description, for the body of the card where should be more text.",
                        url: "https://example.com",
                        urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
                        publishedAt: "2023-12-17T14:20:00Z"
                    )
                )
                .frame(width: 300, height: 280)
            }
            .padding()
            .previewDisplayName("Landscape")
            
            CardView(
                article: Articles(
                    source: Source(id: nil, name: "Bloomberg"),
                    author: "Business Analyst",
                    title: "Market Trends Show Strong Growth in Tech Sector",
                    description: "This is the place for the description, for the body of the card where should be more text.",
                    url: "https://example.com",
                    urlToImage: "https://www.kbb.com/wp-content/uploads/2022/08/2022-mercedes-amg-eqs-front-left-3qtr.jpg?w=918",
                    publishedAt: "2023-12-16T11:30:00Z"
                )
            )
            // .frame(maxWidth: .infinity, height: 150)
            .environment(\.horizontalSizeClass, .regular)
            .padding()
            .previewDisplayName("Landscape Layout")
        }
    }
}


