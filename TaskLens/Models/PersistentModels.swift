import Foundation
import SwiftData
import SwiftUI

// SwiftData 用のタスクモデル
@Model
final class TaskModel: Identifiable {
    var id: UUID
    var title: String
    var memo: String
    var status: TaskStatus
    var priority: TaskPriority
    var dueDate: Date
    var plannedStart: Date
    var plannedEnd: Date
    var plannedHours: Double
    var actualHours: Double
    var category: CategoryModel?
    var tags: [TagModel]

    init(
        id: UUID = UUID(),
        title: String,
        memo: String = "",
        status: TaskStatus = .todo,
        priority: TaskPriority = .medium,
        dueDate: Date = Date(),
        plannedStart: Date = Date(),
        plannedEnd: Date = Date(),
        plannedHours: Double = 0,
        actualHours: Double = 0,
        category: CategoryModel? = nil,
        tags: [TagModel] = []
    ) {
        self.id = id
        self.title = title
        self.memo = memo
        self.status = status
        self.priority = priority
        self.dueDate = dueDate
        self.plannedStart = plannedStart
        self.plannedEnd = plannedEnd
        self.plannedHours = plannedHours
        self.actualHours = actualHours
        self.category = category
        self.tags = tags
    }
}

// SwiftData 用のカテゴリモデル
@Model
final class CategoryModel: Identifiable {
    var id: UUID
    var title: String
    var colorHex: String
    var sortOrder: Int

    init(id: UUID = UUID(), title: String, colorHex: String, sortOrder: Int = 0) {
        self.id = id
        self.title = title
        self.colorHex = colorHex
        self.sortOrder = sortOrder
    }

    // 画面表示用の色
    var color: Color {
        Color(hex: colorHex)
    }

    // 開発・プレビュー用のサンプルカテゴリ
    static let sampleSeed: [CategoryModel] = [
        CategoryModel(title: "開発", colorHex: "#3B82F6", sortOrder: 0),
        CategoryModel(title: "企画", colorHex: "#22C55E", sortOrder: 1),
        CategoryModel(title: "レビュー", colorHex: "#F97316", sortOrder: 2),
        CategoryModel(title: "調査", colorHex: "#8B5CF6", sortOrder: 3),
        CategoryModel(title: "運用", colorHex: "#EC4899", sortOrder: 4)
    ]
}

// SwiftData 用のタグモデル
@Model
final class TagModel: Identifiable {
    var id: UUID
    var title: String
    var sortOrder: Int

    init(id: UUID = UUID(), title: String, sortOrder: Int = 0) {
        self.id = id
        self.title = title
        self.sortOrder = sortOrder
    }

    // 開発・プレビュー用のサンプルタグ
    static let sampleSeed: [TagModel] = [
        TagModel(title: "重要", sortOrder: 0),
        TagModel(title: "共有", sortOrder: 1),
        TagModel(title: "短時間", sortOrder: 2)
    ]
}
