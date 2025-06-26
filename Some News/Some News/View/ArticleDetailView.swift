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
                // Enhanced Image Section
                if let imageUrl = article.urlToImage, !imageUrl.isEmpty {
                    AsyncImage(url: URL(string: imageUrl)) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 250)
                                .overlay(
                                    ProgressView()
                                        .scaleEffect(1.5)
                                )
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 300)
                                .clipped()
                        case .failure:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(height: 250)
                                .overlay(
                                    VStack {
                                        Image(systemName: "photo")
                                            .font(.system(size: 40))
                                            .foregroundColor(.gray)
                                        Text("Image unavailable")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                
                VStack(alignment: .leading, spacing: 20) {
                    // Article Content
                    VStack(alignment: .leading, spacing: 16) {
                        // Title Section
                        if let title = article.title, !title.isEmpty {
                            Text(title)
                                .font(.system(size: 28, weight: .bold, design: .serif))
                                .foregroundColor(.primary)
                                .lineLimit(nil)
                                .multilineTextAlignment(.leading)
                        }
                        
                        // Author and Date Section
                        HStack {
                            if let author = article.author, !author.isEmpty {
                                HStack(spacing: 6) {
                                    Image(systemName: "person.circle.fill")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 16))
                                    Text(author)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                            }
                            
                            Spacer()
                            
                            if let publishedAt = article.publishedAt, !publishedAt.isEmpty {
                                HStack(spacing: 6) {
                                    Image(systemName: "calendar")
                                        .foregroundColor(.orange)
                                        .font(.system(size: 14))
                                    Text(formatDate(publishedAt))
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        
                        // Divider
                        Divider()
                            .padding(.vertical, 8)
                        
                        // Description Section
                        if let description = article.description, !description.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Summary")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.primary)
                                
                                Text(description)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(.secondary)
                                    .lineLimit(nil)
                                    .multilineTextAlignment(.leading)
                                    .lineSpacing(4)
                            }
                        }
                        
                        // Read More Button
                        if let url = article.url, !url.isEmpty {
                            Button(action: {
                                if let url = URL(string: url) {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                HStack {
                                    Text("Read Full Article")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "arrow.up.right")
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 24)
                }
                .background(Color(.systemBackground))
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .offset(y: -20)
            }
        }
        .background(Color(.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    // Share functionality
                    if let url = article.url, let shareUrl = URL(string: url) {
                        let activityVC = UIActivityViewController(
                            activityItems: [shareUrl],
                            applicationActivities: nil
                        )
                        
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                           let window = windowScene.windows.first {
                            window.rootViewController?.present(activityVC, animated: true)
                        }
                    }
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.blue)
                }
            }
        }
    }
    
    // Helper function to format date
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

// Extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
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
