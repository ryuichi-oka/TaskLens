import Foundation

// タスク詳細モーダルの編集状態を保持するドラフト
struct TaskDetailDraft {
    var title: String
    var memo: String
    var status: TaskStatus
    var dueDate: Date
    var priority: TaskPriority
    var plannedStart: Date
    var plannedEnd: Date
    var plannedHoursText: String
    var actualHoursText: String
    var category: TaskCategory
    var selectedTagIDs: Set<UUID>

    // 既存タスクの値を編集用ドラフトにコピーする
    init(item: TaskListItem) {
        title = item.title
        memo = item.memo
        status = item.status
        dueDate = item.dueDate
        priority = item.priority
        plannedStart = item.plannedStart
        plannedEnd = item.plannedEnd
        plannedHoursText = String(format: "%.1f", item.plannedHours)
        actualHoursText = String(format: "%.1f", item.actualHours)
        category = item.category
        selectedTagIDs = Set(item.tags.map { $0.id })
    }

    // 予定時間の数値変換（不正入力は0）
    var plannedHours: Double {
        Double(plannedHoursText) ?? 0
    }

    // 実績時間の数値変換（不正入力は0）
    var actualHours: Double {
        Double(actualHoursText) ?? 0
    }
}
