import SwiftUI

// 設定画面のプレースホルダー
struct SettingsPlaceholderView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("設定")
                    .font(.headline)
                Text("T-006で実装します")
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("設定")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingsPlaceholderView()
}
