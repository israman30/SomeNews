//
//  ArticlesViewModel.swift
//  Some News
//
//  Created by Israel Manzo on 3/28/23.
//

import SwiftUI
import CoreData

protocol ArticlesViewModelProtocol: ObservableObject {
    func getArticles(with context: NSManagedObjectContext) async throws -> [Articles]
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
        
        do {
            try context.save()
            print("SUCCESS: JSON Object saved in Cored Data")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getArticles(with context: NSManagedObjectContext) async throws -> [Articles] {
        do {
            self.articles = try await services.fetchArticles()
            self.saveData(context: context)
        } catch {
            print("DEBUG: \(APIError.errorGettingDataFromNetworkLayer(error.localizedDescription))")
        }
        return articles
    }
}
