import SwiftUI

// タスク一覧の表示と詳細モーダルの起点となる画面
struct TaskListView: View {
    @State private var items = TaskListItem.sampleItems
    @State private var selectedStatus: TaskStatus?
    @State private var selectedCategory: TaskCategory?
    @State private var selectedTag: TaskTag?
    @State private var selectedItem: SelectedTask?

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
                                Button {
                                    selectedItem = SelectedTask(id: item.id)
                                } label: {
                                    TaskCardView(item: item)
                                }
                                .buttonStyle(.plain)
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
        .sheet(item: $selectedItem) { selection in
            detailSheet(for: selection.id)
        }
    }

    // 状態/カテゴリ/タグのフィルタチップを並べる
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

    // 選択されたIDに対応する詳細モーダルを返す
    private func detailSheet(for id: UUID) -> some View {
        Group {
            if let index = items.firstIndex(where: { $0.id == id }) {
                TaskDetailSheet(item: $items[index]) {
                    deleteItem(at: index)
                }
            } else {
                ProgressView()
            }
        }
    }

    // 一覧から削除し、モーダルを閉じる
    private func deleteItem(at index: Int) {
        items.remove(at: index)
        selectedItem = nil
    }
}

// sheet(item:) 用にIDを保持する軽量モデル
private struct SelectedTask: Identifiable {
    let id: UUID
}

#Preview {
    TaskListView()
}
