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
            await self.vm.getArticles(with: context)
        }
    }
}

#Preview {
    HomeFeedView()
        .environmentObject(Coordinator())
        .environmentObject(ArticlesViewModel(services: NetworkServices()))
}






