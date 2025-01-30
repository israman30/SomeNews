//
//  HomeFeedView.swift
//  Some News
//
//  Created by Israel Manzo on 3/27/23.
//

import SwiftUI

struct HomeFeedView: View {
    
    @EnvironmentObject private var vm: ArticlesViewModel
    @EnvironmentObject private var coordinator: Coordinator
    @Environment(\.managedObjectContext) var context
    // MARK: - Fetching data from Core Data
    @FetchRequest(
        entity: Article.entity(),
        sortDescriptors: []
    ) var results: FetchedResults<Article>
    
    var body: some View {
        NavigationView {
            VStack {
                if !vm.articles.isEmpty {
                    List(results) { article in
                        CardView(fetchedData: article)
                    }
                } else {
                    List(vm.articles) { article in
                        CardView(article: article)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Some News")
        }
    }
}

#Preview {
    HomeFeedView()
        .environmentObject(Coordinator())
        .environmentObject(ArticlesViewModel(services: NetworkServices()))
}






