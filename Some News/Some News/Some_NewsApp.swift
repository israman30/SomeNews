//
//  Some_NewsApp.swift
//  Some News
//
//  Created by Israel Manzo on 3/27/23.
//

import SwiftUI

@main
struct Some_NewsApp: App {
    
    @StateObject private var articlesViewModel: ArticlesViewModel
    
    init() {
        self._articlesViewModel = StateObject(
            wrappedValue: ArticlesViewModel(services: NetworkServices())
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(articlesViewModel)
        }
    }
}
