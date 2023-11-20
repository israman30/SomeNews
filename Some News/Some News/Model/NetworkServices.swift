//
//  NetworkServices.swift
//  Some News
//
//  Created by Israel Manzo on 3/28/23.
//

import Foundation

enum APIError: Error {
    case wrongURLAddress
    case errorResponse
    case errorGettingDataFromNetworkLayer(_ message: String)
    case failDecodingArticles(_ localized: String)
}

protocol NetworkServicesProtocol {
    func fetchArticles() async throws -> [Articles]
}

class NetworkServices: NetworkServicesProtocol {
    
    func fetchArticles() async throws -> [Articles] {
        guard let url = URL(string: Constants.endpoint) else {
            throw APIError.wrongURLAddress
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, 
                (200...300).contains(response.statusCode) else {
            throw APIError.errorResponse
        }
        
        return try JSONDecoder().decode(ArticlesList.self, from: data).articles
    }
    
}
