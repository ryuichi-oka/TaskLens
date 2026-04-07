import SwiftUI
import SwiftData

// タグ管理画面（追加/編集/削除）
struct TagManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TagModel.sortOrder) private var tags: [TagModel]

    @State private var isEditPresented = false
    @State private var editingTag: TagModel?
    @State private var draftName = ""

    var body: some View {
        List {
            if tags.isEmpty {
                EmptyStateView(title: "タグがありません", message: "+ から追加")
                    .listRowSeparator(.hidden)
            } else {
                ForEach(tags) { tag in
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.borderPrimary)
                            .frame(width: 10, height: 10)

                        Text(tag.title)
                            .font(.bodyRegular)
                            .foregroundStyle(Color.textPrimary)

                        Spacer()
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        beginEdit(tag)
                    }
                }
                .onDelete(perform: delete)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundPrimary)
        .navigationTitle("タグ管理")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    beginCreate()
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isEditPresented) {
            tagEditSheet
        }
    }

    // 新規作成の初期値をセットする
    private func beginCreate() {
        editingTag = nil
        draftName = ""
        isEditPresented = true
    }

    // 既存タグの編集を開始する
    private func beginEdit(_ tag: TagModel) {
        editingTag = tag
        draftName = tag.title
        isEditPresented = true
    }

    // タグを保存する（新規作成または編集）
    private func saveTag() {
        let trimmed = draftName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        if let editingTag {
            editingTag.title = trimmed
        } else {
            let nextOrder = (tags.map { $0.sortOrder }.max() ?? -1) + 1
            let tag = TagModel(title: trimmed, sortOrder: nextOrder)
            modelContext.insert(tag)
        }

        isEditPresented = false
    }

    // タグを削除する
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(tags[index])
        }
    }

    private var tagEditSheet: some View {
        NavigationStack {
            Form {
                Section("タグ") {
                    TextField("名前", text: $draftName)
                }
            }
            .navigationTitle(editingTag == nil ? "タグ追加" : "タグ編集")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        isEditPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveTag()
                    }
                    .disabled(draftName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        TagManagementView()
    }
}
