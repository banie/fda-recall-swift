//
//  fdaRecallApp.swift
//  fdaRecall
//
//  Created by banie setijoso on 2025-10-10.
//

import SwiftUI
import SwiftData

@main
struct fdaRecallApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            FdaRecallData.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        let repository = FdaRecallsRepositoryImpl(modelContainer: sharedModelContainer)
        WindowGroup {
            ContentView(repository: repository)
        }
        .modelContainer(sharedModelContainer)
    }
}
