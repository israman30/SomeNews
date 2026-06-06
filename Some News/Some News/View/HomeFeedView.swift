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
    
    var body: some View {
        ScrollView {
            LazyVStack {
                switch vm.loadingState {
                case .empty:
                    Text("No articles yet.")
                        .foregroundStyle(.secondary)
                        .padding(.top, 24)
                case .loading:
                    VStack(spacing: 12) {
                        ProgressView()
                        Text("Loading...")
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top, 24)
                case .loaded(let articles):
                    ForEach(articles) { article in
                        Button {
                            coordinator.push(.articlesDetailsView(article))
                        } label: {
                            CardView(article: article)
                        }
                    }
                case .error(let error):
                    VStack(spacing: 12) {
                        Text("Something went wrong.")
                            .font(.headline)
                        Text(error.localizedDescription)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Retry") {
                            Task { await vm.getArticles() }
                        }
                    }
                    .padding(.top, 24)
                }
            }
            .padding(.horizontal, 12)
        }
        .navigationTitle("Some News")
        .navigationBarTitleDisplayMode(.large)
        .task {
            await self.vm.getArticles()
        }
    }
}

#Preview {
    NavigationStack {
        HomeFeedView()
    }
    .environmentObject(Coordinator())
    .environmentObject(ArticlesViewModel(services: NetworkServices()))
}






