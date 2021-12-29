//
//  xkcdApp.swift
//  xkcd
//
//  Created by Maddiee on 28/12/21.
//

import SwiftUI

@main
struct xkcdApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
