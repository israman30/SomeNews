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
                categoryPicker
                    .padding(.top, 8)
                
                sortModePicker
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                
                switch vm.loadingState {
                case .empty:
                    EmptyMessageView()
                case .loading:
                    LoadingView()
                case .loaded(let articles):
                    loadedContent(articles: articles)
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
    
    @ViewBuilder
    private func loadedContent(articles: [Articles]) -> some View {
        switch vm.sortMode {
        case .all:
            ForEach(articles) { article in
                articleRow(article)
            }
        case .priority:
            ForEach(vm.prioritySorted(articles)) { article in
                articleRow(article)
            }
        case .bySource:
            let groups = vm.groupedBySource(articles)
            ForEach(groups, id: \.source) { group in
                VStack(alignment: .leading, spacing: 10) {
                    Text(group.source)
                        .font(.headline)
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 8)
                    
                    ForEach(group.articles) { article in
                        articleRow(article)
                    }
                }
            }
        }
    }
    
    private func articleRow(_ article: Articles) -> some View {
        Button {
            coordinator.push(.articlesDetailsView(article))
        } label: {
            CardView(article: article)
        }
        .buttonStyle(.plain)
    }
    
    private var sortModePicker: some View {
        Picker("Sort", selection: $vm.sortMode) {
            ForEach(FeedSortMode.allCases) { mode in
                Text(mode.rawValue).tag(mode)
            }
        }
        .pickerStyle(.segmented)
        .accessibilityLabel("Sort articles")
    }
    
    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(vm.categories) { category in
                    Button {
                        vm.selectedCategory = category
                        Task { await vm.getArticles() }
                    } label: {
                        Text(category.title)
                            .font(.subheadline.weight(.semibold))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(vm.selectedCategory == category ? Color.accentColor.opacity(0.18) : Color(.systemGray6))
                            )
                            .foregroundStyle(vm.selectedCategory == category ? .primary : .secondary)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(vm.selectedCategory == category ? Color.accentColor.opacity(0.35) : Color.clear, lineWidth: 1)
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Category \(category.title)")
                }
            }
            .padding(.vertical, 4)
        }
        .accessibilityLabel("News categories")
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
            Text("Articles not found.")
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



