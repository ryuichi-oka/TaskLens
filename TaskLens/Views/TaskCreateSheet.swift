import SwiftUI

// 新規タスク作成を行うモーダル
struct TaskCreateSheet: View {
    let onCreate: (TaskListItem) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var draft = TaskDetailDraft()

    var body: some View {
        NavigationStack {
            Form {
                Section("基本情報") {
                    VStack(alignment: .leading, spacing: 6) {
                        TextField("タイトル", text: $draft.title)
                            .textInputAutocapitalization(.sentences)
                            .disableAutocorrection(true)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .stroke(isTitleInvalid ? Color.red : Color.clear, lineWidth: 1)
                            )

                        if let titleValidationMessage {
                            Text(titleValidationMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
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
                        ForEach(TaskCategory.sampleCategories) { category in
                            Text(category.title).tag(category)
                        }
                    }

                    ForEach(TaskTag.sampleTags) { tag in
                        Toggle(tag.title, isOn: bindingForTag(tag))
                    }
                }
            }
            .navigationTitle("新規作成")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("キャンセル") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("作成") {
                        create()
                    }
                    .disabled(!canSubmit)
                }
            }
        }
    }

    // タイトルのバリデーション結果を返す
    private var titleValidationMessage: String? {
        let trimmed = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return "タイトルは必須です"
        }
        if trimmed.count > 50 {
            return "タイトルは50文字以内にしてください"
        }
        return nil
    }

    // タイトルエラー表示の有無を判定する
    private var isTitleInvalid: Bool {
        titleValidationMessage != nil
    }

    // 作成ボタンを有効にできるか判定する
    private var canSubmit: Bool {
        titleValidationMessage == nil
    }

    // 入力内容から新規タスクを生成して一覧へ追加する
    private func create() {
        guard canSubmit else { return }
        let trimmedTitle = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let item = TaskListItem(
            id: UUID(),
            title: trimmedTitle,
            memo: draft.memo,
            status: draft.status,
            dueDate: draft.dueDate,
            priority: draft.priority,
            plannedStart: draft.plannedStart,
            plannedEnd: draft.plannedEnd,
            plannedHours: draft.plannedHours,
            actualHours: draft.actualHours,
            category: draft.category,
            tags: TaskTag.sampleTags.filter { draft.selectedTagIDs.contains($0.id) }
        )
        onCreate(item)
        dismiss()
    }

    // タグの選択状態をToggleにバインドする
    private func bindingForTag(_ tag: TaskTag) -> Binding<Bool> {
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
    TaskCreateSheet(onCreate: { _ in })
}
