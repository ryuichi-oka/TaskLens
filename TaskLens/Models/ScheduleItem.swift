import SwiftUI

// スケジュール画面で表示する予定データ
struct ScheduleItem: Identifiable {
    let id: UUID
    let title: String
    let startAt: Date
    let endAt: Date
    let category: TaskCategory
    let priority: TaskPriority

    // 優先度順のソート用値（小さいほど高優先）
    var priorityRank: Int {
        switch priority {
        case .high:
            return 0
        case .medium:
            return 1
        case .low:
            return 2
        }
    }

    // 表示用の時間レンジ
    var timeRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "\(formatter.string(from: startAt)) - \(formatter.string(from: endAt))"
    }

    // 開発・プレビュー用のサンプル予定
    static let sampleItems: [ScheduleItem] = {
        let calendar = Calendar.current
        let baseDate = calendar.startOfDay(for: Date())
        let categories = TaskCategory.sampleCategories

        func makeDate(hour: Int, minute: Int) -> Date {
            calendar.date(byAdding: .minute, value: hour * 60 + minute, to: baseDate) ?? baseDate
        }

        return [
            ScheduleItem(
                id: UUID(),
                title: "デザインレビュー",
                startAt: makeDate(hour: 9, minute: 0),
                endAt: makeDate(hour: 10, minute: 30),
                category: categories[2],
                priority: .high
            ),
            ScheduleItem(
                id: UUID(),
                title: "API 仕様確認",
                startAt: makeDate(hour: 9, minute: 30),
                endAt: makeDate(hour: 11, minute: 0),
                category: categories[0],
                priority: .medium
            ),
            ScheduleItem(
                id: UUID(),
                title: "週次レポート",
                startAt: makeDate(hour: 13, minute: 0),
                endAt: makeDate(hour: 14, minute: 0),
                category: categories[4],
                priority: .low
            )
        ]
    }()
}
