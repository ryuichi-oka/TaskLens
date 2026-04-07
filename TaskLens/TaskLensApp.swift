//
//  TaskLensApp.swift
//  TaskLens
//
//  Created by 岡隆一 on 2026/03/23.
//

import SwiftUI
import SwiftData

@main
struct TaskLensApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            TaskModel.self,
            CategoryModel.self,
            TagModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            SeedData.insertIfNeeded(context: container.mainContext)
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
