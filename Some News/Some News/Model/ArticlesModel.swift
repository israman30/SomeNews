//
//  ArticlesModel.swift
//  Some News
//
//  Created by Israel Manzo on 3/28/23.
//

import Foundation

struct ArticlesList: Decodable {
    let articles: [Articles]
}

struct Source: Codable {
    let id: String?
    let name: String?
}

struct Articles: Codable, Identifiable {
    // Use a stable local id for items missing a URL.
    private let localId: String = UUID().uuidString
    var id: String { url ?? localId }
    
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    
    // Local-only metadata (not returned by NewsAPI).
    var matchedQuery: String? = nil
    
    enum CodingKeys: String, CodingKey {
        case source
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
    }
}
