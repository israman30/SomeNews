//
//  ArticlesViewModel.swift
//  Some News
//
//  Created by Israel Manzo on 3/28/23.
//

import SwiftUI

enum LoadingState<Value> {
    case empty
    case loading
    case loaded(Value)
    case error(Error)
}

protocol ArticlesViewModelProtocol: ObservableObject {
    func getArticles() async
}

@MainActor
class ArticlesViewModel: ArticlesViewModelProtocol {
    
    @Published private(set) var loadingState: LoadingState<[Articles]> = .empty
    
    private let services: NetworkServicesProtocol
    
    init(services: NetworkServicesProtocol) {
        self.services = services
    }
    
    func getArticles() async {
        loadingState = .loading
        do {
            let articles = try await services.fetchArticles()
            loadingState = !articles.isEmpty ? .loaded(articles) : .empty
        } catch {
            loadingState = .error(APIError.errorGettingDataFromNetworkLayer(error))
        }
    }
}
