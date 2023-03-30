//
//  HomeFeedView.swift
//  Some News
//
//  Created by Israel Manzo on 3/27/23.
//

import SwiftUI

struct HomeFeedView: View {
    
    @StateObject var vm: ArticlesViewModel
    @State private var path = NavigationPath()
    
    init() {
        self._vm = StateObject(wrappedValue: ArticlesViewModel(services: NetworkServices()))
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            if vm.articles.isEmpty {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
            } else {
                List {
                    ForEach(vm.articles, id: \.title) { article in
                        Button {
                            path.append(article)
                        } label: {
                            CardView(article: article)
                                .padding(.horizontal, -10)
                        }
                    }
                }
                .navigationDestination(for: Articles.self) { article in
                    ArticleDetailView(article: article)
                }
                .listStyle(.plain)
                .navigationTitle("Some News")
            }
            
        }
        .onAppear {
            self.vm.getArticles()
        }
    }
}

struct HomeFeedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFeedView()
    }
}






