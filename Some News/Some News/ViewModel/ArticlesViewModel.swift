//
//  ArticlesViewModel.swift
//  Some News
//
//  Created by Israel Manzo on 3/28/23.
//

import SwiftUI
import CoreData

protocol ArticlesViewModelProtocol: ObservableObject {
    func getArticles(context: NSManagedObjectContext) async
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
            entity.articleDescription = article.description
            entity.author = article.author
            entity.publishedAt = article.publishedAt
            entity.url = article.url
            entity.urlToImage = article.urlToImage
        }
        do {
            try context.save()
            print("DEBUG: - Success saving data -")
        } catch {
            print("DEBIG: - Error saving data \(error.localizedDescription) -")
        }
    }
    
    func getArticles(context: NSManagedObjectContext) async {
        do {
            self.articles = try await services.fetchArticles()
            self.saveData(context: context)
        } catch {
            print("DEBUG: \(APIError.errorGettingDataFromNetworkLayer(error.localizedDescription))")
        }
    }
}
