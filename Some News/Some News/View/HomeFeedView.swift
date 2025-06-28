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
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.articles) { article in
                    Button {
                        coordinator.push(.articlesDetailsView(article))
                    } label: {
                        CardView(article: article)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Some News")
            .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(.stack) // Prevents sidebar behavior in landscape
        .task {
            await self.vm.getArticles()
        }
    }
}

#Preview {
    HomeFeedView()
        .environmentObject(Coordinator())
        .environmentObject(ArticlesViewModel(services: NetworkServices()))
}






