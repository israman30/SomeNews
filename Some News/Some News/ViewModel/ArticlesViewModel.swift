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
    @Published var articles = [Articles]()
    
    private let services: NetworkServicesProtocol
    
    init(services: NetworkServicesProtocol) {
        self.services = services
    }
    
    func getArticles() {
        services.getArticles { [weak self] articlesList in
            switch articlesList {
            case .success(let articlesList):
                self?.articles = articlesList
            case .failure(let error):
                print(String(describing:error.localizedDescription))
            case .none:
                break
            }
        }
    }
}
