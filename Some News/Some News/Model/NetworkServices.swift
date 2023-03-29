//
//  NetworkServices.swift
//  Some News
//
//  Created by Israel Manzo on 3/28/23.
//

import Foundation

enum APIError: Error {
    case errorResponse
    case failDecodingArticles(_ localized: String)
}

protocol NetworkServicesProtocol {
    func getArticles(completion: @escaping(Result<[Articles], APIError>?) -> Void)
}

class NetworkServices: NetworkServicesProtocol {
    
    func getArticles(completion: @escaping(Result<[Articles], APIError>?) -> Void) {
        guard let url = URL(string: Constants.endpoint) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(nil)
            }
            guard let data = data else {
                return
            }
            do {
                let articlesList = try JSONDecoder().decode(ArticlesList.self, from: data)
                print(articlesList.articles)
                DispatchQueue.main.async {
                    completion(.success(articlesList.articles))
                }
            } catch {
                print("Error: \(error.localizedDescription)")
                completion(.failure(APIError.failDecodingArticles(error.localizedDescription)))
                print(String(describing: error))
            }
        }
        task.resume()
    }
}
