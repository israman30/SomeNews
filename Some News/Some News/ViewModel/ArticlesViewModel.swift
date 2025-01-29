//
//  ArticlesViewModel.swift
//  Some News
//
//  Created by Israel Manzo on 3/28/23.
//

import SwiftUI
import CoreData

protocol ArticlesViewModelProtocol: ObservableObject {
    func getArticles() async
}

@MainActor
class ArticlesViewModel: ArticlesViewModelProtocol {
    
    @Published private(set) var articles = [Articles]()
    
    private let services: NetworkServicesProtocol
    
    init(services: NetworkServicesProtocol) {
        self.services = services
    }
    
    private func saveData(context: NSManagedObjectContext) {
        articles.forEach { article in
            let entity = Article(context: context)
            entity.title = article.title
            entity.body = article.description
            entity.urlToImage = article.urlToImage
            entity.url = article.url
            entity.publishedAt = article.publishedAt
            entity.author = article.author
        }
    }
    
    func getArticles() async {
        do {
            self.articles = try await services.fetchArticles()
        } catch {
            print("DEBUG: \(APIError.errorGettingDataFromNetworkLayer(error.localizedDescription))")
        }
    }
}
