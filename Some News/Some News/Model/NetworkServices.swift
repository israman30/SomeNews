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
    case errorGettingDataFromNetworkLayer(_ message: Error)
    case failDecodingArticles(_ localized: String)
}

protocol NetworkServicesProtocol {
    func fetchTopHeadlines() async throws -> [Articles]
    func fetchEverything(query: String) async throws -> [Articles]
}

class NetworkServices: NetworkServicesProtocol {
    
    func fetchTopHeadlines() async throws -> [Articles] {
        try await fetchArticles(urlString: Constants.topHeadlinesEndpoint)
    }
    
    func fetchEverything(query: String) async throws -> [Articles] {
        let urlString = try Constants.everythingEndpoint(query: query)
        return try await fetchArticles(urlString: urlString)
    }
    
    private func fetchArticles(urlString: String) async throws -> [Articles] {
        guard let url = URL(string: urlString) else {
            throw APIError.wrongURLAddress
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse,
              (200...300).contains(response.statusCode) else {
            throw APIError.errorResponse
        }
        
        do {
            return try JSONDecoder().decode(ArticlesList.self, from: data).articles
        } catch {
            throw APIError.failDecodingArticles(error.localizedDescription)
        }
    }
}
