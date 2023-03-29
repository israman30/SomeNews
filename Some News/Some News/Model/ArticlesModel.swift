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

struct Articles: Codable, Identifiable {
    var id = UUID().uuidString
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case author
        case title
        case description
        case url
        case urlToImage
        case publishedAt
    }
}
