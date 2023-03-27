//
//  NewsFeedView.swift
//  Some News
//
//  Created by Israel Manzo on 3/26/23.
//

import SwiftUI

struct NewsFeedView: View {
    
    @StateObject private var vm: ArticlesViewModelImplementation
    
    init() {
        self._vm = StateObject(wrappedValue: ArticlesViewModelImplementation(services: NetworkServicesImplementation()))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.articles, id: \.title) { article in
                    VStack {
                        Image(systemName: "person")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        VStack(alignment: .leading) {
                            Text("SwfitUI")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Text(article.title)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                                .lineLimit(2)
                            Text(article.description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            
        }
        
    }
}

struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}

struct Constants {
    static var endopint = "https://newsapi.org/v1/articles?source=google-news&sortBy=top&apiKey=066d82458ed84eeeac28a86095ec88b9"
}

enum APIError: Error {
    case errorResponse
}

protocol NetworkServices {
    func fetchUsers() async throws -> [Articles]
}

struct ArticlesList: Decodable {
    let articles: [Articles]
}

struct Articles: Decodable {
    let title: String
    let description: String
}

final class NetworkServicesImplementation: NetworkServices {
    func fetchUsers() async throws -> [Articles] {
        let url = URL(string: Constants.endopint)
        let (data, response) = try await URLSession.shared.data(from: url!)
        
        guard let response = response as? HTTPURLResponse,
              (200...300).contains(response.statusCode) else {
            throw APIError.errorResponse
        }
        
        return try JSONDecoder().decode([Articles].self, from: data)
    }
}
