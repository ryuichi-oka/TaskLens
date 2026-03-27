import SwiftUI

// 空状態のメッセージ表示コンポーネント
struct EmptyStateView: View {
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(Layout.sectionVertical)
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

#Preview {
    EmptyStateView(title: "タスクがありません", message: "右下の + から作成しましょう")
        .padding()
}
