//
//  ArticlesViewModel.swift
//  Some News
//
//  Created by Israel Manzo on 3/28/23.
//

import SwiftUI

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
    
    func getArticles() async {
        do {
            self.articles = try await services.fetchArticles()
        } catch {
            print("DEBUG: \(APIError.errorGettingDataFromNetworkLayer(error.localizedDescription))")
        }
    }
}
