//
//  Coordinator.swift
//  Some News
//
//  Created by Israel Manzo on 11/21/24.
//

import SwiftUI

enum Pages: Hashable, Equatable {
    case homeView
    case articlesDetailsView(_ article: Articles)
    
    static func == (lhs: Pages, rhs: Pages) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        case .articlesDetailsView(let ariticle):
            hasher.combine(ariticle.id)
        default:
            break
        }
    }
}

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ page: Pages) {
        path.append(page)
    }
    
    @ViewBuilder
    func build(_ page: Pages) -> some View {
        switch page {
        case .homeView:
            HomeFeedView()
        case .articlesDetailsView(let article):
            ArticleDetailView(article: article)
        }
    }
}
