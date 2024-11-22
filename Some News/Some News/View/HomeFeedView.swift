//
//  HomeFeedView.swift
//  Some News
//
//  Created by Israel Manzo on 3/27/23.
//

import SwiftUI

struct HomeFeedView: View {
    
    @StateObject var vm: ArticlesViewModel
    @EnvironmentObject private var coordinator: Coordinator
    
    init() {
        self._vm = StateObject(wrappedValue: ArticlesViewModel(services: NetworkServices()))
    }
    
    var body: some View {
        NavigationView {
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
        }
        .task {
            await self.vm.getArticles()
        }
    }
}

#Preview {
    HomeFeedView()
        .environmentObject(Coordinator())
}






