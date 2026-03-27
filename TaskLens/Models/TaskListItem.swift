import Foundation

// タスク一覧で扱う表示用モデル
struct TaskListItem: Identifiable {
    let id: UUID
    var title: String
    var memo: String
    var status: TaskStatus
    var dueDate: Date
    var priority: TaskPriority
    var plannedStart: Date
    var plannedEnd: Date
    var plannedHours: Double
    var actualHours: Double
    var category: TaskCategory
    var tags: [TaskTag]

    private static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    // 期限表示用のテキスト
    var dueDateText: String {
        Self.dueDateFormatter.string(from: dueDate)
    }

    // 優先度表示用のテキスト
    var priorityText: String {
        priority.title
    }

    // 予定時間の表示用テキスト
    var plannedText: String {
        String(format: "%.1fh", plannedHours)
    }

    // 実績時間の表示用テキスト
    var actualText: String {
        String(format: "%.1fh", actualHours)
    }

    // 期限超過かどうかを判定する
    var isOverdue: Bool {
        dueDate < Calendar.current.startOfDay(for: Date())
    }

    // 開発・プレビュー用のサンプルデータ
    static let sampleItems: [TaskListItem] = {
        let categories = TaskCategory.sampleCategories
        let tags = TaskTag.sampleTags

        return [
            TaskListItem(
                id: UUID(),
                title: "新規リリース準備",
                memo: "リリースノートの最終確認",
                status: .inProgress,
                dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
                priority: .high,
                plannedStart: Calendar.current.date(byAdding: .hour, value: 10, to: Date()) ?? Date(),
                plannedEnd: Calendar.current.date(byAdding: .hour, value: 12, to: Date()) ?? Date(),
                plannedHours: 3.0,
                actualHours: 2.4,
                category: categories[0],
                tags: [tags[0]]
            ),
            TaskListItem(
                id: UUID(),
                title: "UIレビューの整理",
                memo: "指摘事項をまとめて共有",
                status: .todo,
                dueDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
                priority: .medium,
                plannedStart: Calendar.current.date(byAdding: .hour, value: 14, to: Date()) ?? Date(),
                plannedEnd: Calendar.current.date(byAdding: .hour, value: 15, to: Date()) ?? Date(),
                plannedHours: 1.5,
                actualHours: 0.5,
                category: categories[2],
                tags: [tags[1], tags[2]]
            ),
            TaskListItem(
                id: UUID(),
                title: "週次レポートまとめ",
                memo: "今週の進捗を整理する",
                status: .done,
                dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                priority: .low,
                plannedStart: Calendar.current.date(byAdding: .hour, value: 9, to: Date()) ?? Date(),
                plannedEnd: Calendar.current.date(byAdding: .hour, value: 11, to: Date()) ?? Date(),
                plannedHours: 2.0,
                actualHours: 2.1,
                category: categories[4],
                tags: []
            )
        ]
    }()
}
