import Foundation
import SwiftUI

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
    var category: CategoryModel?
    var selectedTagIDs: Set<UUID>

    // 新規作成用の初期値を作成する
    init(defaultCategory: CategoryModel? = nil) {
        title = ""
        memo = ""
        status = .todo
        dueDate = Date()
        priority = .medium
        plannedStart = Date()
        plannedEnd = Date()
        plannedHoursText = ""
        actualHoursText = ""
        category = defaultCategory
        selectedTagIDs = []
    }

    // 既存タスクの値を編集用ドラフトにコピーする
    init(task: TaskModel) {
        title = task.title
        memo = task.memo
        status = task.status
        dueDate = task.dueDate
        priority = task.priority
        plannedStart = task.plannedStart
        plannedEnd = task.plannedEnd
        plannedHoursText = String(format: "%.1f", task.plannedHours)
        actualHoursText = String(format: "%.1f", task.actualHours)
        category = task.category
        selectedTagIDs = Set(task.tags.map { $0.id })
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
