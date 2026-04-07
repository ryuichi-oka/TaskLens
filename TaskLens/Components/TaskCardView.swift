import SwiftUI
import SwiftData

// タスク一覧で使用するカードコンポーネント
struct TaskCardView: View {
    let task: TaskModel

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.rowSpacing) {
            HStack(alignment: .firstTextBaseline) {
                Text(task.title)
                    .font(.bodyEmphasis)
                    .foregroundStyle(Color.textPrimary)

                Spacer(minLength: 8)

                Text(task.status.title)
                    .statusBadge(backgroundColor: task.status.tint.opacity(0.16), textColor: task.status.tint)
            }

            HStack(spacing: 8) {
                Text("期限: \(dueDateText)")
                Text("優先度: \(task.priority.title)")
            }
            .font(.captionRegular)
            .foregroundStyle(isOverdue ? Color.accentDanger : Color.textSecondary)

            HStack(spacing: 8) {
                Text("予定")
                    .foregroundStyle(Color.textTertiary)
                Text(plannedText)
                    .font(.bodyEmphasis)
                    .foregroundStyle(Color.textPrimary)
                Text("/ 実績")
                    .foregroundStyle(Color.textTertiary)
                Text(actualText)
                    .font(.bodyEmphasis)
                    .foregroundStyle(Color.textPrimary)

                Spacer()

                Circle()
                    .fill(task.category?.color ?? Color.borderPrimary)
                    .frame(width: 8, height: 8)
            }
            .font(.captionRegular)
        }
        .roundedCard()
    }

    private var dueDateText: String {
        DateFormatter.shortDate.string(from: task.dueDate)
    }

    private var plannedText: String {
        String(format: "%.1fh", task.plannedHours)
    }

    private var actualText: String {
        String(format: "%.1fh", task.actualHours)
    }

    private var isOverdue: Bool {
        task.dueDate < Calendar.current.startOfDay(for: Date())
    }
}

#Preview {
    TaskCardView(task: TaskModel(title: "サンプル"))
        .padding()
        .modelContainer(for: [TaskModel.self, CategoryModel.self, TagModel.self], inMemory: true)
}
