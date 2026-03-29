import SwiftUI

// 既存タスクの閲覧・編集を行う詳細モーダル
struct TaskDetailSheet: View {
    @Binding var item: TaskListItem
    let onDelete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var draft: TaskDetailDraft
    @State private var validationMessage: String?

    // 外部から渡されたタスクを編集用ドラフトに変換する
    init(item: Binding<TaskListItem>, onDelete: @escaping () -> Void) {
        _item = item
        self.onDelete = onDelete
        _draft = State(initialValue: TaskDetailDraft(item: item.wrappedValue))
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
                        ForEach(TaskCategory.sampleCategories) { category in
                            Text(category.title).tag(category)
                        }
                    }

                    ForEach(TaskTag.sampleTags) { tag in
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
        item.title = trimmedTitle
        item.memo = draft.memo
        item.status = draft.status
        item.priority = draft.priority
        item.dueDate = draft.dueDate
        item.plannedStart = draft.plannedStart
        item.plannedEnd = draft.plannedEnd
        item.plannedHours = draft.plannedHours
        item.actualHours = draft.actualHours
        item.category = draft.category
        item.tags = TaskTag.sampleTags.filter { draft.selectedTagIDs.contains($0.id) }
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
    TaskDetailSheet(item: .constant(TaskListItem.sampleItems[0]), onDelete: {})
}
