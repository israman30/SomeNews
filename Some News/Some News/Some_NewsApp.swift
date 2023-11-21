//
//  Some_NewsApp.swift
//  Some News
//
//  Created by Israel Manzo on 3/27/23.
//

import SwiftUI

@main
struct Some_NewsApp: App {
    
    let persistControlle = PersistController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistControlle.container.viewContext)
        }
    }
}
