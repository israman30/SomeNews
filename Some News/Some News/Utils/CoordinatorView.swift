//
//  CoordinatorView.swift
//  Some News
//
//  Created by Israel Manzo on 11/21/24.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordintaor = Coordinator()
    var body: some View {
        NavigationStack(path: $coordintaor.path) {
            coordintaor.build(.homeView)
                .navigationDestination(for: Pages.self) { page in
                    coordintaor.build(page)
                }
        }
        .environmentObject(coordintaor)
    }
}
