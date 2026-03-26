//
//  ContentView.swift
//  TaskLens
//
//  Created by 岡隆一 on 2026/03/23.
//

import SwiftUI

struct ContentView: View {
    private enum Tab: Hashable {
        case tasks
        case schedule
        case analytics
    }

    @State private var selectedTab: Tab = .tasks
    @State private var isSettingsPresented = false

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                TaskListView()
                    .navigationTitle("一覧")
                    .toolbar { commonToolbar() }
            }
            .tabItem {
                Label("タスク", systemImage: "checklist")
            }
            .tag(Tab.tasks)

            NavigationStack {
                SchedulePlaceholderView()
                    .navigationTitle("スケジュール")
                    .toolbar { commonToolbar() }
            }
            .tabItem {
                Label("スケジュール", systemImage: "calendar")
            }
            .tag(Tab.schedule)

            NavigationStack {
                AnalyticsPlaceholderView()
                    .navigationTitle("分析")
                    .toolbar { commonToolbar() }
            }
            .tabItem {
                Label("分析", systemImage: "chart.bar.xaxis")
            }
            .tag(Tab.analytics)
        }
        .sheet(isPresented: $isSettingsPresented) {
            SettingsPlaceholderView()
        }
    }

    @ToolbarContentBuilder
    private func commonToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                isSettingsPresented = true
            } label: {
                Image(systemName: "line.3.horizontal")
            }
            .accessibilityLabel("設定")
        }
    }
}

private enum Layout {
    static let screenHorizontal: CGFloat = 16
    static let sectionVertical: CGFloat = 16
    static let rowSpacing: CGFloat = 6
    static let chipVertical: CGFloat = 8
    static let chipHorizontal: CGFloat = 12
    static let cardInner: CGFloat = 12
    static let fabMargin: CGFloat = 24
    static let fabSize: CGFloat = 56
}

private struct TaskListView: View {
    private let items = TaskListItem.sampleItems
    @State private var selectedStatus: TaskStatus?
    @State private var selectedCategory: TaskCategory?
    @State private var selectedTag: TaskTag?

    var body: some View {
        ZStack {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Layout.sectionVertical) {
                    filterChips

                    if items.isEmpty {
                        EmptyStateView(
                            title: "タスクがありません",
                            message: "右下の + から作成しましょう"
                        )
                        .frame(maxWidth: .infinity)
                    } else {
                        LazyVStack(spacing: Layout.sectionVertical) {
                            ForEach(items) { item in
                                TaskCardView(item: item)
                            }
                        }
                    }
                }
                .padding(.horizontal, Layout.screenHorizontal)
                .padding(.vertical, Layout.sectionVertical)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
            } label: {
                Image(systemName: "plus")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(width: Layout.fabSize, height: Layout.fabSize)
                    .background(Color.accentColor)
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.12), radius: 12, x: 0, y: 6)
            }
            .padding(.trailing, Layout.fabMargin)
            .padding(.bottom, Layout.fabMargin)
            .accessibilityLabel("タスクを追加")
        }
    }

    private var filterChips: some View {
        VStack(alignment: .leading, spacing: Layout.rowSpacing) {
            Text("フィルタ")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(TaskStatus.allCases) { status in
                        FilterChip(
                            title: status.title,
                            isSelected: selectedStatus == status,
                            tint: status.tint
                        ) {
                            selectedStatus = selectedStatus == status ? nil : status
                        }
                    }

                    Divider()
                        .frame(height: 24)

                    ForEach(TaskCategory.sampleCategories) { category in
                        FilterChip(
                            title: category.title,
                            isSelected: selectedCategory == category,
                            tint: category.color
                        ) {
                            selectedCategory = selectedCategory == category ? nil : category
                        }
                    }

                    Divider()
                        .frame(height: 24)

                    ForEach(TaskTag.sampleTags) { tag in
                        FilterChip(
                            title: tag.title,
                            isSelected: selectedTag == tag,
                            tint: Color.accentColor
                        ) {
                            selectedTag = selectedTag == tag ? nil : tag
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

private struct TaskCardView: View {
    let item: TaskListItem

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.rowSpacing) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))

                Spacer(minLength: 8)

                StatusBadge(title: item.status.title, tint: item.status.tint)
            }

            HStack(spacing: 8) {
                Text("期限: \(item.dueDateText)")
                Text("優先度: \(item.priorityText)")
            }
            .font(.caption)
            .foregroundStyle(item.isOverdue ? Color.red : Color.secondary)

            HStack(spacing: 8) {
                Text("予定")
                    .foregroundStyle(.secondary)
                Text(item.plannedText)
                    .font(.subheadline.weight(.semibold))
                Text("/ 実績")
                    .foregroundStyle(.secondary)
                Text(item.actualText)
                    .font(.subheadline.weight(.semibold))

                Spacer()

                Circle()
                    .fill(item.category.color)
                    .frame(width: 8, height: 8)
            }
            .font(.caption)
        }
        .padding(Layout.cardInner)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct StatusBadge: View {
    let title: String
    let tint: Color

    var body: some View {
        Text(title)
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(tint.opacity(0.15))
            .foregroundStyle(tint)
            .clipShape(Capsule())
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption.weight(.semibold))
                .padding(.vertical, Layout.chipVertical)
                .padding(.horizontal, Layout.chipHorizontal)
                .foregroundStyle(isSelected ? Color.white : Color.primary)
                .background(isSelected ? tint : Color(.secondarySystemBackground))
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(Color.gray.opacity(0.2), lineWidth: isSelected ? 0 : 1)
                )
        }
        .buttonStyle(.plain)
    }
}

private struct EmptyStateView: View {
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(Layout.sectionVertical)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct TaskListItem: Identifiable {
    let id = UUID()
    let title: String
    let status: TaskStatus
    let dueDate: Date
    let priority: TaskPriority
    let plannedHours: Double
    let actualHours: Double
    let category: TaskCategory

    private static let dueDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()

    var dueDateText: String {
        Self.dueDateFormatter.string(from: dueDate)
    }

    var priorityText: String {
        priority.title
    }

    var plannedText: String {
        String(format: "%.1fh", plannedHours)
    }

    var actualText: String {
        String(format: "%.1fh", actualHours)
    }

    var isOverdue: Bool {
        dueDate < Calendar.current.startOfDay(for: Date())
    }

    static let sampleItems: [TaskListItem] = [
        TaskListItem(
            title: "新規リリース準備",
            status: .inProgress,
            dueDate: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date(),
            priority: .high,
            plannedHours: 3.0,
            actualHours: 2.4,
            category: TaskCategory.sampleCategories[0]
        ),
        TaskListItem(
            title: "UIレビューの整理",
            status: .todo,
            dueDate: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(),
            priority: .medium,
            plannedHours: 1.5,
            actualHours: 0.5,
            category: TaskCategory.sampleCategories[2]
        ),
        TaskListItem(
            title: "週次レポートまとめ",
            status: .done,
            dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
            priority: .low,
            plannedHours: 2.0,
            actualHours: 2.1,
            category: TaskCategory.sampleCategories[4]
        )
    ]
}

private enum TaskStatus: String, CaseIterable, Identifiable {
    case todo
    case inProgress
    case done

    var id: String { rawValue }

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

private enum TaskPriority: String {
    case high
    case medium
    case low

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

private struct TaskCategory: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let color: Color

    static let sampleCategories: [TaskCategory] = [
        TaskCategory(title: "開発", color: .blue),
        TaskCategory(title: "企画", color: .green),
        TaskCategory(title: "レビュー", color: .orange),
        TaskCategory(title: "調査", color: .purple),
        TaskCategory(title: "運用", color: .pink)
    ]
}

private struct TaskTag: Identifiable, Equatable {
    let id = UUID()
    let title: String

    static let sampleTags: [TaskTag] = [
        TaskTag(title: "重要"),
        TaskTag(title: "共有"),
        TaskTag(title: "短時間")
    ]
}

private struct SchedulePlaceholderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("スケジュール画面")
                .font(.headline)
            Text("T-004で実装します")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial)
    }
}

private struct AnalyticsPlaceholderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("分析画面")
                .font(.headline)
            Text("T-005で実装します")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial)
    }
}

private struct SettingsPlaceholderView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("設定")
                    .font(.headline)
                Text("T-006で実装します")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ContentView()
}
