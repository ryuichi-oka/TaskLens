import SwiftUI

// カテゴリ管理画面（追加/編集/削除/並び替え）
struct CategoryManagementView: View {
    @State private var categories = TaskCategory.sampleCategories
    @State private var isEditPresented = false
    @State private var editingCategory: TaskCategory?
    @State private var draftName = ""
    @State private var draftColor = Color.blue

    var body: some View {
        List {
            if categories.isEmpty {
                EmptyStateView(title: "カテゴリがありません", message: "+ から追加")
                    .listRowSeparator(.hidden)
            } else {
                ForEach(categories) { category in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(category.color)
                            .frame(width: 10, height: 10)

                        Text(category.title)
                            .font(.body)

                        Spacer()

                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        beginEdit(category)
                    }
                }
                .onDelete(perform: delete)
                .onMove(perform: move)
            }
        }
        .listStyle(.plain)
        .navigationTitle("カテゴリ管理")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                EditButton()
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    beginCreate()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isEditPresented) {
            categoryEditSheet
        }
    }

    // 新規作成の初期値をセットする
    private func beginCreate() {
        editingCategory = nil
        draftName = ""
        draftColor = Color.blue
        isEditPresented = true
    }

    // 既存カテゴリの編集を開始する
    private func beginEdit(_ category: TaskCategory) {
        editingCategory = category
        draftName = category.title
        draftColor = category.color
        isEditPresented = true
    }

    // カテゴリを保存する（新規作成または編集）
    private func saveCategory() {
        let trimmed = draftName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if let editingCategory,
           let index = categories.firstIndex(where: { $0.id == editingCategory.id }) {
            categories[index] = TaskCategory(id: editingCategory.id, title: trimmed, color: draftColor)
        } else {
            categories.append(TaskCategory(id: UUID(), title: trimmed, color: draftColor))
        }

        isEditPresented = false
    }

    // カテゴリを削除する
    private func delete(at offsets: IndexSet) {
        categories.remove(atOffsets: offsets)
    }

    // カテゴリの並び順を更新する
    private func move(from source: IndexSet, to destination: Int) {
        categories.move(fromOffsets: source, toOffset: destination)
    }

    private var categoryEditSheet: some View {
        NavigationStack {
            Form {
                Section("カテゴリ") {
                    TextField("名前", text: $draftName)

                    ColorPicker("色", selection: $draftColor, supportsOpacity: false)
                }
            }
            .navigationTitle(editingCategory == nil ? "カテゴリ追加" : "カテゴリ編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        isEditPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveCategory()
                    }
                    .disabled(draftName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoryManagementView()
    }
}
