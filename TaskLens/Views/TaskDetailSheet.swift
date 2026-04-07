import SwiftUI
import SwiftData

// 既存タスクの閲覧・編集を行う詳細モーダル
struct TaskDetailSheet: View {
    @Bindable var task: TaskModel
    let onDelete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @Query(sort: \CategoryModel.sortOrder) private var categories: [CategoryModel]
    @Query(sort: \TagModel.sortOrder) private var tags: [TagModel]
    @State private var draft: TaskDetailDraft
    @State private var validationMessage: String?

    // 外部から渡されたタスクを編集用ドラフトに変換する
    init(task: TaskModel, onDelete: @escaping () -> Void) {
        self.task = task
        self.onDelete = onDelete
        _draft = State(initialValue: TaskDetailDraft(task: task))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("基本情報") {
                    VStack(alignment: .leading, spacing: 6) {
                        TextField("タイトル", text: $draft.title)
                            .textInputAutocapitalization(.sentences)
                            .disableAutocorrection(true)
                            .onChange(of: draft.title) {
                                validationMessage = nil
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(isTitleInvalid ? Color.accentDanger : Color.clear, lineWidth: 1)
                            )

                        if let validationMessage {
                            Text(validationMessage)
                                .font(.captionRegular)
                                .foregroundStyle(Color.accentDanger)
                        }
                    }

                    TextEditor(text: $draft.memo)
                        .frame(minHeight: 80)

                    Picker("状態", selection: $draft.status) {
                        ForEach(TaskStatus.allCases) { status in
                            Text(status.title).tag(status)
                        }
                    }

                    Picker("優先度", selection: $draft.priority) {
                        ForEach(TaskPriority.allCases, id: \.self) { priority in
                            Text(priority.title).tag(priority)
                        }
                    }

                    DatePicker("期限", selection: $draft.dueDate, displayedComponents: .date)
                }

                Section("予定 / 実績") {
                    DatePicker("開始", selection: $draft.plannedStart, displayedComponents: [.date, .hourAndMinute])
                    DatePicker("終了", selection: $draft.plannedEnd, displayedComponents: [.date, .hourAndMinute])

                    TextField("予定時間（h）", text: $draft.plannedHoursText)
                        .keyboardType(.decimalPad)

                    TextField("実績時間（h）", text: $draft.actualHoursText)
                        .keyboardType(.decimalPad)
                }

                Section("カテゴリ / タグ") {
                    Picker("カテゴリ", selection: $draft.category) {
                        Text("未選択").tag(CategoryModel?.none)
                        ForEach(categories) { category in
                            Text(category.title).tag(Optional(category))
                        }
                    }

                    ForEach(tags) { tag in
                        Toggle(tag.title, isOn: bindingForTag(tag))
                    }
                }

                Section {
                    Button(role: .destructive) {
                        onDelete()
                        dismiss()
                    } label: {
                        Text("削除")
                    }
                }
            }
            .navigationTitle("タスク詳細")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                    .foregroundStyle(Color.textSecondary)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        save()
                    }
                }
            }
            .onAppear {
                if draft.category == nil {
                    draft.category = categories.first
                }
            }
        }
    }

    // バリデーションエラーの表示有無を判定する
    private var isTitleInvalid: Bool {
        validationMessage != nil
    }

    // 入力を検証し、問題なければ編集内容を保存する
    private func save() {
        let trimmedTitle = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmedTitle.isEmpty {
            validationMessage = "タイトルは必須です"
            return
        }
        if trimmedTitle.count > 50 {
            validationMessage = "タイトルは50文字以内にしてください"
            return
        }

        validationMessage = nil
        task.title = trimmedTitle
        task.memo = draft.memo
        task.status = draft.status
        task.priority = draft.priority
        task.dueDate = draft.dueDate
        task.plannedStart = draft.plannedStart
        task.plannedEnd = draft.plannedEnd
        task.plannedHours = draft.plannedHours
        task.actualHours = draft.actualHours
        task.category = draft.category
        task.tags = tags.filter { draft.selectedTagIDs.contains($0.id) }
        dismiss()
    }

    // タグの選択状態をToggleにバインドする
    private func bindingForTag(_ tag: TagModel) -> Binding<Bool> {
        Binding(
            get: { draft.selectedTagIDs.contains(tag.id) },
            set: { isOn in
                if isOn {
                    draft.selectedTagIDs.insert(tag.id)
                } else {
                    draft.selectedTagIDs.remove(tag.id)
                }
            }
        )
    }
}

#Preview {
    TaskDetailSheet(task: TaskModel(title: "サンプル"), onDelete: {})
        .modelContainer(for: [TaskModel.self, CategoryModel.self, TagModel.self], inMemory: true)
}
