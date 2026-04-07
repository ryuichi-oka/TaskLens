import SwiftUI
import SwiftData

// タスク一覧の表示と詳細モーダルの起点となる画面
struct TaskListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TaskModel.dueDate) private var tasks: [TaskModel]
    @Query(sort: \CategoryModel.sortOrder) private var categories: [CategoryModel]
    @Query(sort: \TagModel.sortOrder) private var tags: [TagModel]

    @State private var selectedStatus: TaskStatus?
    @State private var selectedCategoryID: UUID?
    @State private var selectedTagID: UUID?
    @State private var selectedTask: TaskModel?
    @State private var isCreatePresented = false

    var body: some View {
        ZStack {
            Color.backgroundPrimary
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: Layout.sectionVertical) {
                    filterChips

                    if filteredTasks.isEmpty {
                        EmptyStateView(
                            title: emptyStateTitle,
                            message: emptyStateMessage
                        )
                        .frame(maxWidth: .infinity)
                    } else {
                        LazyVStack(spacing: Layout.sectionVertical) {
                            ForEach(filteredTasks) { task in
                                Button {
                                    selectedTask = task
                                } label: {
                                    TaskCardView(task: task)
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
        .sheet(item: $selectedTask) { task in
            TaskDetailSheet(task: task) {
                delete(task)
            }
        }
        .sheet(isPresented: $isCreatePresented) {
            TaskCreateSheet()
        }
        .onChange(of: categoryIDs) { newValue in
            guard let selectedCategoryID else { return }
            if !newValue.contains(selectedCategoryID) {
                self.selectedCategoryID = nil
            }
        }
        .onChange(of: tagIDs) { newValue in
            guard let selectedTagID else { return }
            if !newValue.contains(selectedTagID) {
                self.selectedTagID = nil
            }
        }
    }

    // 選択中の条件を適用した一覧表示用の配列
    private var filteredTasks: [TaskModel] {
        tasks.filter { task in
            let matchesStatus = selectedStatus.map { task.status == $0 } ?? true
            let matchesCategory = selectedCategoryID.map { task.category?.id == $0 } ?? true
            let matchesTag = selectedTagID.map { tagID in
                task.tags.contains { $0.id == tagID }
            } ?? true
            return matchesStatus && matchesCategory && matchesTag
        }
    }

    // 空状態タイトルを一覧全体の件数とフィルタ有無で切り替える
    private var emptyStateTitle: String {
        tasks.isEmpty ? "タスクがありません" : "条件に合うタスクがありません"
    }

    // 空状態メッセージを一覧全体の件数とフィルタ有無で切り替える
    private var emptyStateMessage: String {
        tasks.isEmpty ? "右下の + から作成しましょう" : "フィルタ条件を変更してみましょう"
    }

    private var categoryIDs: [UUID] {
        categories.map(\.id)
    }

    private var tagIDs: [UUID] {
        tags.map(\.id)
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

                    ForEach(categories) { category in
                        FilterChip(
                            title: category.title,
                            isSelected: selectedCategoryID == category.id,
                            tint: category.color
                        ) {
                            selectedCategoryID = selectedCategoryID == category.id ? nil : category.id
                        }
                    }

                    Divider()
                        .frame(height: 24)

                    ForEach(tags) { tag in
                        FilterChip(
                            title: tag.title,
                            isSelected: selectedTagID == tag.id,
                            tint: Color.accentPrimary
                        ) {
                            selectedTagID = selectedTagID == tag.id ? nil : tag.id
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    // 一覧から削除し、モーダルを閉じる
    private func delete(_ task: TaskModel) {
        modelContext.delete(task)
    }
}

#Preview {
    TaskListView()
        .modelContainer(for: [TaskModel.self, CategoryModel.self, TagModel.self], inMemory: true)
}
