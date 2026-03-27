import SwiftUI

// タスク一覧で使用するカードコンポーネント
struct TaskCardView: View {
    let item: TaskListItem

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.rowSpacing) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.title)
                    .font(.bodyEmphasis)
                    .foregroundStyle(Color.textPrimary)

                Spacer(minLength: 8)

                Text(item.status.title)
                    .statusBadge(backgroundColor: item.status.tint.opacity(0.16), textColor: item.status.tint)
            }

            HStack(spacing: 8) {
                Text("期限: \(item.dueDateText)")
                Text("優先度: \(item.priorityText)")
            }
            .font(.captionRegular)
            .foregroundStyle(item.isOverdue ? Color.accentDanger : Color.textSecondary)

            HStack(spacing: 8) {
                Text("予定")
                    .foregroundStyle(Color.textTertiary)
                Text(item.plannedText)
                    .font(.bodyEmphasis)
                    .foregroundStyle(Color.textPrimary)
                Text("/ 実績")
                    .foregroundStyle(Color.textTertiary)
                Text(item.actualText)
                    .font(.bodyEmphasis)
                    .foregroundStyle(Color.textPrimary)

                Spacer()

                Circle()
                    .fill(item.category.color)
                    .frame(width: 8, height: 8)
            }
            .font(.captionRegular)
        }
        .roundedCard()
    }
}

#Preview {
    TaskCardView(item: TaskListItem.sampleItems[0])
        .padding()
}
