//
//  ArticlesViewModel.swift
//  Some News
//
//  Created by Israel Manzo on 3/28/23.
//

import SwiftUI

enum LoadingState<Value> {
    case empty
    case loading
    case loaded(Value)
    case error(Error)
}

protocol ArticlesViewModelProtocol: ObservableObject {
    func getArticles() async
}

enum FeedSortMode: String, CaseIterable, Identifiable {
    case all = "All"
    case bySource = "By Source"
    case priority = "Priority"
    
    var id: String { rawValue }
}

struct NewsCategory: Identifiable, Hashable {
    let title: String
    /// Query used for `/v2/everything?q=...`. If `nil`, fetches all categories and merges results.
    let query: String?
    
    var id: String { title }
    
    static let all = NewsCategory(title: "All", query: nil)
}

@MainActor
class ArticlesViewModel: ArticlesViewModelProtocol {
    
    @Published private(set) var loadingState: LoadingState<[Articles]> = .empty
    @Published var selectedCategory: NewsCategory = .all
    @Published var sortMode: FeedSortMode = .all
    
    let categories: [NewsCategory] = [
        .all,
        NewsCategory(title: "Bitcoin", query: "bitcoin"),
        NewsCategory(title: "Apple", query: "apple"),
        NewsCategory(title: "Tesla", query: "tesla"),
        NewsCategory(title: "AI", query: "artificial intelligence"),
        NewsCategory(title: "Markets", query: "stock market")
    ]
    
    /// Higher priority sources appear first when `sortMode == .priority`.
    let prioritySources: [String] = [
        "Reuters",
        "Associated Press",
        "Bloomberg",
        "The Wall Street Journal",
        "Financial Times",
        "The Verge",
        "TechCrunch",
        "Wired"
    ]
    
    private let services: NetworkServicesProtocol
    private let store: ArticlesStore
    
    init(services: NetworkServicesProtocol, store: ArticlesStore = CoreDataArticlesStore()) {
        self.services = services
        self.store = store
    }
    
    func getArticles() async {
        // Show cached content first (if available) to improve perceived performance/offline.
        if let cached = try? await store.fetchArticles(matchedQuery: selectedCategory.query),
           !cached.isEmpty {
            let deduped = deduplicateByURLKeepingFirst(cached)
            let datedSorted = deduped.sorted(by: sortByPublishedDateDesc)
            loadingState = .loaded(datedSorted)
        } else {
            loadingState = .loading
        }
        
        do {
            let fetched = try await fetchForSelectedCategory()
            let deduped = deduplicateByURLKeepingFirst(fetched)
            let datedSorted = deduped.sorted(by: sortByPublishedDateDesc)
            // Best effort persistence: don’t block UI updates on disk writes.
            do { try await store.upsertArticles(datedSorted) } catch { }
            loadingState = !datedSorted.isEmpty ? .loaded(datedSorted) : .empty
        } catch {
            // If we already have cached content on screen, keep it.
            if case .loaded = loadingState { return }
            loadingState = .error(APIError.errorGettingDataFromNetworkLayer(error))
        }
    }
    
    func groupedBySource(_ articles: [Articles]) -> [(source: String, articles: [Articles])] {
        let groups = Dictionary(grouping: articles) { article in
            article.source?.name?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
            ? (article.source?.name ?? "Unknown Source")
            : "Unknown Source"
        }
        
        let sortedSources = groups.keys.sorted { lhs, rhs in
            let lc = groups[lhs]?.count ?? 0
            let rc = groups[rhs]?.count ?? 0
            if lc != rc { return lc > rc }
            return lhs.localizedCaseInsensitiveCompare(rhs) == .orderedAscending
        }
        
        return sortedSources.map { source in
            let items = (groups[source] ?? []).sorted(by: sortByPublishedDateDesc)
            return (source: source, articles: items)
        }
    }
    
    func prioritySorted(_ articles: [Articles]) -> [Articles] {
        articles.sorted { a, b in
            let ap = sourcePriorityIndex(a.source?.name)
            let bp = sourcePriorityIndex(b.source?.name)
            if ap != bp { return ap < bp }
            
            let aq = queryPriorityIndex(a.matchedQuery)
            let bq = queryPriorityIndex(b.matchedQuery)
            if aq != bq { return aq < bq }
            
            return sortByPublishedDateDesc(a, b)
        }
    }
    
    // MARK: - Private
    
    private func fetchForSelectedCategory() async throws -> [Articles] {
        if let query = selectedCategory.query, !query.isEmpty {
            var items = try await services.fetchEverything(query: query)
            for i in items.indices {
                items[i].matchedQuery = query
            }
            return items
        }
        
        // "All" category: fetch all queries (excluding `.all`) and merge.
        let queries = categories.compactMap(\.query)
        var combined: [Articles] = []
        for query in queries where !query.isEmpty {
            var items = try await services.fetchEverything(query: query)
            for i in items.indices {
                items[i].matchedQuery = query
            }
            combined.append(contentsOf: items)
        }
        return combined
    }
    
    private func deduplicateByURLKeepingFirst(_ articles: [Articles]) -> [Articles] {
        var seen = Set<String>()
        var result: [Articles] = []
        result.reserveCapacity(articles.count)
        
        for article in articles {
            let key = article.url?.trimmingCharacters(in: .whitespacesAndNewlines)
            if let key, !key.isEmpty {
                if seen.contains(key) { continue }
                seen.insert(key)
                result.append(article)
            } else {
                // No URL: keep it (can’t reliably dedupe).
                result.append(article)
            }
        }
        return result
    }
    
    private func sourcePriorityIndex(_ sourceName: String?) -> Int {
        guard let name = sourceName?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty else {
            return Int.max / 2
        }
        return prioritySources.firstIndex(where: { $0.caseInsensitiveCompare(name) == .orderedSame }) ?? (Int.max / 2)
    }
    
    private func queryPriorityIndex(_ query: String?) -> Int {
        guard let q = query?.trimmingCharacters(in: .whitespacesAndNewlines), !q.isEmpty else {
            return Int.max / 2
        }
        let queries = categories.compactMap(\.query)
        return queries.firstIndex(where: { $0.caseInsensitiveCompare(q) == .orderedSame }) ?? (Int.max / 2)
    }
    
    private func sortByPublishedDateDesc(_ a: Articles, _ b: Articles) -> Bool {
        let ad = a.publishedAt.flatMap(Constants.parseAPIDate)
        let bd = b.publishedAt.flatMap(Constants.parseAPIDate)
        
        switch (ad, bd) {
        case let (a?, b?):
            return a > b
        case (.some, .none):
            return true
        case (.none, .some):
            return false
        case (.none, .none):
            let at = a.title ?? ""
            let bt = b.title ?? ""
            return at.localizedCaseInsensitiveCompare(bt) == .orderedAscending
        }
    }
}
