//
//  ArticlesViewModel.swift
//  Some News
//
//  Created by Israel Manzo on 3/26/23.
//

import SwiftUI

protocol ArticlesViewModel: ObservableObject {
    func getUsers() async
}

@MainActor
final class ArticlesViewModelImplementation: ArticlesViewModel {
    
    @Published private(set) var articles = [Articles]()
    
    private let services: NetworkServices
    
    init(services: NetworkServices) {
        self.services = services
    }
    
    func getUsers() async {
        do {
            self.articles = try await services.fetchUsers()
        } catch {
            print("Some error")
        }
    }
}
