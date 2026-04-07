import SwiftUI

// タスクの進行状態
enum TaskStatus: String, CaseIterable, Identifiable, Codable {
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
            return Color.accentWarning
        case .inProgress:
            return Color.accentPrimary
        case .done:
            return Color.accentSuccess
        }
    }
}

// タスクの優先度
enum TaskPriority: String, CaseIterable, Codable {
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

