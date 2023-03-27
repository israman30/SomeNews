//
//  ContentView.swift
//  Some News
//
//  Created by Israel Manzo on 3/26/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<5) {
                    Text("\($0)")
                }
            }
            .navigationTitle("Some News")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
