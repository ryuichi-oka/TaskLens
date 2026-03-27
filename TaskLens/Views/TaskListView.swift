import SwiftUI

// タスク一覧の表示と詳細モーダルの起点となる画面
struct TaskListView: View {
    @State private var items = TaskListItem.sampleItems
    @State private var selectedStatus: TaskStatus?
    @State private var selectedCategory: TaskCategory?
    @State private var selectedTag: TaskTag?
    @State private var selectedItem: SelectedTask?
    @State private var isCreatePresented = false

    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Layout.sectionVertical) {
                    filterChips

                    if filteredItems.isEmpty {
                        EmptyStateView(
                            title: emptyStateTitle,
                            message: emptyStateMessage
                        )
                        .frame(maxWidth: .infinity)
                    } else {
                        LazyVStack(spacing: Layout.sectionVertical) {
                            ForEach(filteredItems) { item in
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
                isCreatePresented = true
            } label: {
                Image(systemName: "plus")
                    .font(.title2.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(width: Layout.fabSize, height: Layout.fabSize)
                    .background(Color.accentPrimary)
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
        .sheet(isPresented: $isCreatePresented) {
            TaskCreateSheet { newItem in
                items.insert(newItem, at: 0)
            }
        }
    }

    // 選択中の条件を適用した一覧表示用の配列
    private var filteredItems: [TaskListItem] {
        items.filter { item in
            let matchesStatus = selectedStatus.map { item.status == $0 } ?? true
            let matchesCategory = selectedCategory.map { item.category == $0 } ?? true
            let matchesTag = selectedTag.map { item.tags.contains($0) } ?? true
            return matchesStatus && matchesCategory && matchesTag
        }
    }

    // 空状態タイトルを一覧全体の件数とフィルタ有無で切り替える
    private var emptyStateTitle: String {
        items.isEmpty ? "タスクがありません" : "条件に合うタスクがありません"
    }

    // 空状態メッセージを一覧全体の件数とフィルタ有無で切り替える
    private var emptyStateMessage: String {
        items.isEmpty ? "右下の + から作成しましょう" : "フィルタ条件を変更してみましょう"
    }

    // 状態/カテゴリ/タグのフィルタチップを並べる
    private var filterChips: some View {
        VStack(alignment: .leading, spacing: Layout.rowSpacing) {
            Text("フィルタ")
                .font(.captionEmphasis)
                .foregroundStyle(Color.textSecondary)

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
                            tint: Color.accentPrimary
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
