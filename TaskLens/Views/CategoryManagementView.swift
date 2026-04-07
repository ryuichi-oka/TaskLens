import SwiftUI
import SwiftData

// カテゴリ管理画面（追加/編集/削除/並び替え）
struct CategoryManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CategoryModel.sortOrder) private var categories: [CategoryModel]

    @State private var isEditPresented = false
    @State private var editingCategory: CategoryModel?
    @State private var draftName = ""
    @State private var draftColor = Color.categoryBlue

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
                            .font(.bodyRegular)
                            .foregroundStyle(Color.textPrimary)

                        Spacer()

                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(Color.textTertiary)
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
        .scrollContentBackground(.hidden)
        .background(Color.backgroundPrimary)
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
        draftColor = Color.categoryBlue
        isEditPresented = true
    }

    // 既存カテゴリの編集を開始する
    private func beginEdit(_ category: CategoryModel) {
        editingCategory = category
        draftName = category.title
        draftColor = category.color
        isEditPresented = true
    }

    // カテゴリを保存する（新規作成または編集）
    private func saveCategory() {
        let trimmed = draftName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if let editingCategory {
            editingCategory.title = trimmed
            editingCategory.colorHex = draftColor.toHexString()
        } else {
            let nextOrder = (categories.map { $0.sortOrder }.max() ?? -1) + 1
            let category = CategoryModel(title: trimmed, colorHex: draftColor.toHexString(), sortOrder: nextOrder)
            modelContext.insert(category)
        }

        isEditPresented = false
    }

    // カテゴリを削除する
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(categories[index])
        }
    }

    // カテゴリの並び順を更新する
    private func move(from source: IndexSet, to destination: Int) {
        var updated = categories
        updated.move(fromOffsets: source, toOffset: destination)
        for (index, category) in updated.enumerated() {
            category.sortOrder = index
        }
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
