//
//  HomeFeedView.swift
//  Some News
//
//  Created by Israel Manzo on 3/27/23.
//

import SwiftUI

struct HomeFeedView: View {
    
    @StateObject var vm: ArticlesViewModel
    
    init() {
        self._vm = StateObject(wrappedValue: ArticlesViewModel(services: NetworkServices()))
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.articles, id: \.title) { article in
                    NavigationLink {
                        ArticleDetailView(article: article)
                    } label: {
                        CardView(article: article)
                            .padding(.horizontal, -10)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Some News")
        }
        .task {
            await self.vm.getArticles()
        }
    }
}

struct HomeFeedView_Previews: PreviewProvider {
    static var previews: some View {
        HomeFeedView()
    }
}






