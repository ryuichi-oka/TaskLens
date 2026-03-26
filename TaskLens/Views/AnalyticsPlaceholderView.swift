import SwiftUI

// 分析画面のプレースホルダー
struct AnalyticsPlaceholderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("分析画面")
                .font(.headline)
            Text("T-005で実装します")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.thinMaterial)
    }
}

#Preview {
    AnalyticsPlaceholderView()
}
