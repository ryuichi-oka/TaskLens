import SwiftUI
import SwiftData

// スケジュール画面（時間軸 + 予定枠表示）
struct ScheduleView: View {
    @State private var selectedDate = Date()
    @Query(sort: \TaskModel.plannedStart) private var tasks: [TaskModel]

    var body: some View {
        VStack(spacing: Layout.sectionVertical) {
            dateHeader

            if filteredTasks.isEmpty {
                EmptyStateView(title: "予定がありません", message: "+ から予定を追加")
                    .padding(.horizontal, Layout.screenHorizontal)
            } else {
                ScheduleTimeline(items: filteredTasks, selectedDate: selectedDate)
                    .padding(.horizontal, Layout.screenHorizontal)
            }
        }
        .padding(.vertical, Layout.sectionVertical)
        .background(Color.backgroundPrimary)
    }

    // 日付切替と「今日」ボタンを表示する
    private var dateHeader: some View {
        HStack(spacing: 12) {
            Button("今日") {
                selectedDate = Date()
            }
            .buttonStyle(.bordered)
            .tint(Color.accentPrimary)

            Spacer()

            Button {
                shiftDate(by: -1)
            } label: {
                Image(systemName: "chevron.left")
            }

            Text(dateText)
                .font(.titleMedium)
                .foregroundStyle(Color.textPrimary)

            Button {
                shiftDate(by: 1)
            } label: {
                Image(systemName: "chevron.right")
            }
        }
    }

    private var dateText: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: selectedDate)
    }

    private func shiftDate(by value: Int) {
        selectedDate = Calendar.current.date(byAdding: .day, value: value, to: selectedDate) ?? selectedDate
    }

    // 選択中の日付に一致する予定だけを表示対象にする
    private var filteredTasks: [TaskModel] {
        let calendar = Calendar.current
        return tasks.filter { task in
            calendar.isDate(task.plannedStart, inSameDayAs: selectedDate)
        }
    }
}

private struct ScheduleTimeline: View {
    private let hourHeight: CGFloat = 80
    private let timeLabelWidth: CGFloat = 56
    private let lineLeadingPadding: CGFloat = 8

    let items: [TaskModel]
    let selectedDate: Date

    var body: some View {
        ScrollView {
            GeometryReader { proxy in
                let totalHeight = hourHeight * 24
                let availableWidth = max(proxy.size.width - timeLabelWidth - lineLeadingPadding, 0)
                let layouts = buildLayouts(items: items, availableWidth: availableWidth)

                ZStack(alignment: .topLeading) {
                    timeGrid(totalHeight: totalHeight)

                    ForEach(layouts) { layout in
                        ScheduleBlockView(task: layout.task)
                            .frame(width: layout.width, height: layout.height)
                            .offset(x: timeLabelWidth + lineLeadingPadding + layout.xOffset, y: layout.yOffset)
                    }
                }
                .frame(height: totalHeight)
            }
            .frame(height: hourHeight * 24)
        }
    }

    // 0:00-24:00 の時間軸と15分補助線を描画する
    private func timeGrid(totalHeight: CGFloat) -> some View {
        ZStack(alignment: .topLeading) {
            ForEach(0...96, id: \.self) { index in
                let isHour = index % 4 == 0
                Rectangle()
                    .fill(Color.borderPrimary.opacity(isHour ? 0.7 : 0.4))
                    .frame(height: 1)
                    .offset(y: CGFloat(index) * (hourHeight / 4))
                    .padding(.leading, timeLabelWidth)
            }

            VStack(spacing: 0) {
                ForEach(0..<24, id: \.self) { hour in
                    HStack(alignment: .top, spacing: 0) {
                        Text(String(format: "%02d:00", hour))
                            .font(.captionRegular)
                            .foregroundStyle(Color.textSecondary)
                            .frame(width: timeLabelWidth, alignment: .leading)

                        Spacer()
                    }
                    .frame(height: hourHeight, alignment: .top)
                }
            }
        }
        .frame(height: totalHeight)
    }

    private func buildLayouts(items: [TaskModel], availableWidth: CGFloat) -> [ScheduleTaskLayout] {
        let sorted = items.sorted { lhs, rhs in
            if lhs.plannedStart == rhs.plannedStart {
                return lhs.schedulePriorityRank < rhs.schedulePriorityRank
            }
            return lhs.plannedStart < rhs.plannedStart
        }

        var layouts: [ScheduleTaskLayout] = []
        var cluster: [TaskModel] = []
        var clusterEnd = Date.distantPast

        func flushCluster() {
            guard !cluster.isEmpty else { return }
            layouts.append(contentsOf: layoutCluster(cluster, availableWidth: availableWidth))
            cluster = []
            clusterEnd = Date.distantPast
        }

        for task in sorted {
            if cluster.isEmpty {
                cluster = [task]
                clusterEnd = task.plannedEnd
                continue
            }

            if task.plannedStart < clusterEnd {
                cluster.append(task)
                if task.plannedEnd > clusterEnd {
                    clusterEnd = task.plannedEnd
                }
            } else {
                flushCluster()
                cluster = [task]
                clusterEnd = task.plannedEnd
            }
        }

        flushCluster()
        return layouts
    }

    private func layoutCluster(_ items: [TaskModel], availableWidth: CGFloat) -> [ScheduleTaskLayout] {
        let sorted = items.sorted { lhs, rhs in
            if lhs.plannedStart == rhs.plannedStart {
                return lhs.schedulePriorityRank < rhs.schedulePriorityRank
            }
            return lhs.plannedStart < rhs.plannedStart
        }

        var columnEndTimes: [Date] = []
        var columnIndices: [UUID: Int] = [:]

        for task in sorted {
            if let index = columnEndTimes.firstIndex(where: { $0 <= task.plannedStart }) {
                columnEndTimes[index] = task.plannedEnd
                columnIndices[task.id] = index
            } else {
                columnEndTimes.append(task.plannedEnd)
                columnIndices[task.id] = columnEndTimes.count - 1
            }
        }

        let columnCount = max(columnEndTimes.count, 1)
        let columnSpacing: CGFloat = 8
        let totalSpacing = columnSpacing * CGFloat(max(columnCount - 1, 0))
        let width = max((availableWidth - totalSpacing) / CGFloat(columnCount), 80)

        return items.compactMap { task in
            guard let columnIndex = columnIndices[task.id] else { return nil }
            let yOffset = minuteOffset(for: task.plannedStart) * (hourHeight / 60)
            let height = max(minuteOffset(for: task.plannedEnd) - minuteOffset(for: task.plannedStart), 30) * (hourHeight / 60)
            let xOffset = CGFloat(columnIndex) * (width + columnSpacing)
            return ScheduleTaskLayout(
                task: task,
                width: width,
                height: height,
                xOffset: xOffset,
                yOffset: yOffset
            )
        }
    }

    private func minuteOffset(for date: Date) -> CGFloat {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: selectedDate)
        let components = calendar.dateComponents([.minute], from: startOfDay, to: date)
        return CGFloat(components.minute ?? 0)
    }
}

private struct ScheduleBlockView: View {
    let task: TaskModel

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(task.title)
                .font(.captionEmphasis)
                .foregroundStyle(Color.textPrimary)
                .lineLimit(2)

            Text(task.timeRangeText)
                .font(.captionRegular)
                .foregroundStyle(Color.textSecondary)
        }
        .padding(8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(task.scheduleCategoryColor.opacity(0.18))
        .overlay(
            Rectangle()
                .fill(task.scheduleCategoryColor)
                .frame(width: 3),
            alignment: .leading
        )
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

private struct ScheduleTaskLayout: Identifiable {
    let id = UUID()
    let task: TaskModel
    let width: CGFloat
    let height: CGFloat
    let xOffset: CGFloat
    let yOffset: CGFloat
}

#Preview {
    ScheduleView()
        .modelContainer(for: [TaskModel.self, CategoryModel.self, TagModel.self], inMemory: true)
}

private extension TaskModel {
    // スケジュール表示用の優先度ソート値
    var schedulePriorityRank: Int {
        switch priority {
        case .high:
            return 0
        case .medium:
            return 1
        case .low:
            return 2
        }
    }

    // スケジュール表示用のカテゴリ色
    var scheduleCategoryColor: Color {
        category?.color ?? Color.accentPrimary
    }

    // 表示用の時間レンジ
    var timeRangeText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "\(formatter.string(from: plannedStart)) - \(formatter.string(from: plannedEnd))"
    }
}
