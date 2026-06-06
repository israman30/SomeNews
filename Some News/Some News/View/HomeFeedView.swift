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
                    EmptyMessageView()
                case .loading:
                    LoadingView()
                case .loaded(let articles):
                    ForEach(articles) { article in
                        Button {
                            coordinator.push(.articlesDetailsView(article))
                        } label: {
                            CardView(article: article)
                        }
                    }
                case .error(let error):
                    ErrorMessage(error: error, retry: {
                        Task { await vm.getArticles() }
                    })
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

struct EmptyMessageView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("No articles yet.")
                .foregroundStyle(.secondary)
                .padding(.top, 24)
            Text("404")
                .font(.largeTitle)
        }
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 12) {
            ProgressView()
            Text("Loading...")
                .foregroundStyle(.secondary)
        }
        .padding(.top, 24)
    }
}

struct ErrorMessage: View {
    let error: Error
    var retry: () -> Void
    
    init(error: Error, retry: @escaping () -> Void) {
        self.error = error
        self.retry = retry
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Something went wrong.")
                .font(.headline)
            Text(error.localizedDescription)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button("Retry") {
                retry()
            }
        }
        .padding(.top, 24)
    }
}



