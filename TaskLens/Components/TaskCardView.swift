import SwiftUI

// タスク一覧で使用するカードコンポーネント
struct TaskCardView: View {
    let item: TaskListItem

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.rowSpacing) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.title)
                    .font(.subheadline.weight(.semibold))

                Spacer(minLength: 8)

                StatusBadge(title: item.status.title, tint: item.status.tint)
            }

            HStack(spacing: 8) {
                Text("期限: \(item.dueDateText)")
                Text("優先度: \(item.priorityText)")
            }
            .font(.caption)
            .foregroundStyle(item.isOverdue ? Color.red : Color.secondary)

            HStack(spacing: 8) {
                Text("予定")
                    .foregroundStyle(.secondary)
                Text(item.plannedText)
                    .font(.subheadline.weight(.semibold))
                Text("/ 実績")
                    .foregroundStyle(.secondary)
                Text(item.actualText)
                    .font(.subheadline.weight(.semibold))

                Spacer()

                Circle()
                    .fill(item.category.color)
                    .frame(width: 8, height: 8)
            }
            .font(.caption)
        }
        .padding(Layout.cardInner)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    TaskCardView(item: TaskListItem.sampleItems[0])
        .padding()
}
