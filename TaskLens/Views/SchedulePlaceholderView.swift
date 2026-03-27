import SwiftUI

// スケジュール画面のプレースホルダー
struct SchedulePlaceholderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("スケジュール画面")
                .font(.headline)
            Text("T-004で実装します")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial)
    }
}

#Preview {
    SchedulePlaceholderView()
}
