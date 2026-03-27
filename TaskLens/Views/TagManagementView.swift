import SwiftUI

// タグ管理画面のプレースホルダー
struct TagManagementView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("タグ管理")
                .font(.headline)
            Text("T-008で実装します")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("タグ管理")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        TagManagementView()
    }
}
