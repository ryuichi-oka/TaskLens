import SwiftUI
import Charts

// 分析画面（予実差分/カテゴリ別/週次サマリ）
struct AnalyticsView: View {
    private let varianceItems = AnalyticsVarianceItem.sampleItems
    private let categoryItems = AnalyticsCategoryItem.sampleItems
    private let weeklyItems = AnalyticsWeeklyItem.sampleItems

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Layout.sectionVertical) {
                varianceSection
                categorySection
                weeklySection
            }
            .padding(.horizontal, Layout.screenHorizontal)
            .padding(.vertical, Layout.sectionVertical)
        }
    }

    // 予実差分（棒グラフ）
    private var varianceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("予実差分")
                .font(.headline)

            if varianceItems.isEmpty {
                EmptyStateView(title: "データがありません", message: "タスクに予定/実績を入力すると表示されます")
            } else {
                Chart(varianceItems) { item in
                    BarMark(
                        x: .value("日付", item.date),
                        y: .value("時間", item.hours)
                    )
                    .foregroundStyle(item.kind.color)
                    .position(by: .value("種別", item.kind.title))
                }
                .frame(height: 180)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day, count: 1)) { value in
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
        }
    }

    // カテゴリ別時間（横棒グラフ）
    private var categorySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("カテゴリ別時間")
                .font(.headline)

            if categoryItems.isEmpty {
                EmptyStateView(title: "データがありません", message: "タスクに予定/実績を入力すると表示されます")
            } else {
                Chart(categoryItems) { item in
                    BarMark(
                        x: .value("時間", item.hours),
                        y: .value("カテゴリ", item.category.title)
                    )
                    .foregroundStyle(item.category.color)
                }
                .frame(height: 180)
                .chartXAxis {
                    AxisMarks(position: .bottom)
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
        }
    }

    // 週次サマリ（折れ線）
    private var weeklySection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("週次サマリ")
                .font(.headline)

            if weeklyItems.isEmpty {
                EmptyStateView(title: "データがありません", message: "タスクに予定/実績を入力すると表示されます")
            } else {
                Chart(weeklyItems) { item in
                    LineMark(
                        x: .value("週", item.weekStart),
                        y: .value("時間", item.hours)
                    )
                    .foregroundStyle(Color.accentColor)

                    PointMark(
                        x: .value("週", item.weekStart),
                        y: .value("時間", item.hours)
                    )
                    .foregroundStyle(Color.accentColor)
                }
                .frame(height: 180)
                .chartXAxis {
                    AxisMarks(values: .stride(by: .weekOfYear, count: 1)) { value in
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading)
                }
            }
        }
    }
}

#Preview {
    AnalyticsView()
}
