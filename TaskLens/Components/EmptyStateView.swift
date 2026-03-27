import SwiftUI

// 空状態のメッセージ表示コンポーネント
struct EmptyStateView: View {
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.titleMedium)
                .foregroundStyle(Color.textPrimary)
            Text(message)
                .font(.bodyRegular)
                .foregroundStyle(Color.textSecondary)
        }
        .padding(Layout.sectionVertical)
        .frame(maxWidth: .infinity)
        .roundedCard()
    }
}

#Preview {
    EmptyStateView(title: "タスクがありません", message: "右下の + から作成しましょう")
        .padding()
}
