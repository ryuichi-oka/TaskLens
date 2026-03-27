import SwiftUI

// タスクの進行状態
enum TaskStatus: String, CaseIterable, Identifiable {
    case todo
    case inProgress
    case done

    var id: String { rawValue }

    // 表示用の日本語ラベル
    var title: String {
        switch self {
        case .todo:
            return "未着手"
        case .inProgress:
            return "進行中"
        case .done:
            return "完了"
        }
    }

    // 状態に応じた表示色
    var tint: Color {
        switch self {
        case .todo:
            return Color.orange
        case .inProgress:
            return Color.accentColor
        case .done:
            return Color.green
        }
    }
}

// タスクの優先度
enum TaskPriority: String, CaseIterable {
    case high
    case medium
    case low

    // 表示用の日本語ラベル
    var title: String {
        switch self {
        case .high:
            return "高"
        case .medium:
            return "中"
        case .low:
            return "低"
        }
    }
}

// カテゴリの表示モデル
struct TaskCategory: Identifiable, Equatable, Hashable {
    let id = UUID()
    let title: String
    let color: Color

    // 開発・プレビュー用のサンプルカテゴリ
    static let sampleCategories: [TaskCategory] = [
        TaskCategory(title: "開発", color: .blue),
        TaskCategory(title: "企画", color: .green),
        TaskCategory(title: "レビュー", color: .orange),
        TaskCategory(title: "調査", color: .purple),
        TaskCategory(title: "運用", color: .pink)
    ]
}

// タグの表示モデル
struct TaskTag: Identifiable, Equatable, Hashable {
    let id = UUID()
    let title: String

    // 開発・プレビュー用のサンプルタグ
    static let sampleTags: [TaskTag] = [
        TaskTag(title: "重要"),
        TaskTag(title: "共有"),
        TaskTag(title: "短時間")
    ]
}
