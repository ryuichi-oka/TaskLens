import SwiftUI

// 予実差分の棒グラフに使うデータ
struct AnalyticsVarianceItem: Identifiable {
    let id = UUID()
    let date: Date
    let hours: Double
    let kind: AnalyticsVarianceKind

    static let sampleItems: [AnalyticsVarianceItem] = {
        let calendar = Calendar.current
        let base = calendar.startOfDay(for: Date())
        return [
            AnalyticsVarianceItem(date: base, hours: 3.5, kind: .planned),
            AnalyticsVarianceItem(date: base, hours: 2.8, kind: .actual),
            AnalyticsVarianceItem(date: calendar.date(byAdding: .day, value: 1, to: base) ?? base, hours: 4.0, kind: .planned),
            AnalyticsVarianceItem(date: calendar.date(byAdding: .day, value: 1, to: base) ?? base, hours: 3.2, kind: .actual),
            AnalyticsVarianceItem(date: calendar.date(byAdding: .day, value: 2, to: base) ?? base, hours: 2.0, kind: .planned),
            AnalyticsVarianceItem(date: calendar.date(byAdding: .day, value: 2, to: base) ?? base, hours: 2.4, kind: .actual)
        ]
    }()
}

// 予実差分の系列種別
enum AnalyticsVarianceKind: String {
    case planned
    case actual

    var title: String {
        switch self {
        case .planned:
            return "予定"
        case .actual:
            return "実績"
        }
    }

    var color: Color {
        switch self {
        case .planned:
            return Color.accentPrimary.opacity(0.55)
        case .actual:
            return Color.accentPrimary
        }
    }
}

// カテゴリ別時間の棒グラフに使うデータ
struct AnalyticsCategoryItem: Identifiable {
    let id = UUID()
    let category: CategoryModel
    let hours: Double

    static let sampleItems: [AnalyticsCategoryItem] = {
        let categories = CategoryModel.sampleSeed
        return [
            AnalyticsCategoryItem(category: categories[0], hours: 6.0),
            AnalyticsCategoryItem(category: categories[1], hours: 4.5),
            AnalyticsCategoryItem(category: categories[2], hours: 3.0),
            AnalyticsCategoryItem(category: categories[3], hours: 2.0)
        ]
    }()
}

// 週次サマリの折れ線に使うデータ
struct AnalyticsWeeklyItem: Identifiable {
    let id = UUID()
    let weekStart: Date
    let hours: Double

    static let sampleItems: [AnalyticsWeeklyItem] = {
        let calendar = Calendar.current
        let base = calendar.startOfDay(for: Date())
        return (0..<5).compactMap { offset in
            let date = calendar.date(byAdding: .weekOfYear, value: -offset, to: base) ?? base
            return AnalyticsWeeklyItem(weekStart: date, hours: Double(4 + offset))
        }.reversed()
    }()
}
