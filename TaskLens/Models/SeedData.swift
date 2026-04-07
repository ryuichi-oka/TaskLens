import Foundation
import SwiftData

// 初回起動時のサンプルデータ投入
struct SeedData {
    static func insertIfNeeded(context: ModelContext) {
        let categoryFetch = FetchDescriptor<CategoryModel>()
        if (try? context.fetchCount(categoryFetch)) ?? 0 > 0 {
            return
        }

        let categories = CategoryModel.sampleSeed
        categories.forEach { context.insert($0) }

        let tags = TagModel.sampleSeed
        tags.forEach { context.insert($0) }

        let calendar = Calendar.current
        let now = Date()

        let task1 = TaskModel(
            title: "新規リリース準備",
            memo: "リリースノートの最終確認",
            status: .inProgress,
            priority: .high,
            dueDate: calendar.date(byAdding: .day, value: 1, to: now) ?? now,
            plannedStart: calendar.date(byAdding: .hour, value: 10, to: now) ?? now,
            plannedEnd: calendar.date(byAdding: .hour, value: 12, to: now) ?? now,
            plannedHours: 3.0,
            actualHours: 2.4,
            category: categories.first,
            tags: tags.isEmpty ? [] : [tags[0]]
        )

        let task2 = TaskModel(
            title: "UIレビューの整理",
            memo: "指摘事項をまとめて共有",
            status: .todo,
            priority: .medium,
            dueDate: calendar.date(byAdding: .day, value: -1, to: now) ?? now,
            plannedStart: calendar.date(byAdding: .hour, value: 14, to: now) ?? now,
            plannedEnd: calendar.date(byAdding: .hour, value: 15, to: now) ?? now,
            plannedHours: 1.5,
            actualHours: 0.5,
            category: categories.count > 2 ? categories[2] : categories.first,
            tags: tags.count >= 3 ? [tags[1], tags[2]] : tags
        )

        let task3 = TaskModel(
            title: "週次レポートまとめ",
            memo: "今週の進捗を整理する",
            status: .done,
            priority: .low,
            dueDate: calendar.date(byAdding: .day, value: 3, to: now) ?? now,
            plannedStart: calendar.date(byAdding: .hour, value: 9, to: now) ?? now,
            plannedEnd: calendar.date(byAdding: .hour, value: 11, to: now) ?? now,
            plannedHours: 2.0,
            actualHours: 2.1,
            category: categories.last,
            tags: []
        )

        context.insert(task1)
        context.insert(task2)
        context.insert(task3)

        try? context.save()
    }
}
