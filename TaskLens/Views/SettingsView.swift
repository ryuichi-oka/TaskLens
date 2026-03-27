import SwiftUI

// 設定画面（カテゴリ管理/タグ管理への導線）
struct SettingsView: View {
    @State private var isCategoryPresented = false
    @State private var isTagPresented = false

    var body: some View {
        List {
            Section {
                Button {
                    isCategoryPresented = true
                } label: {
                    Label("カテゴリ管理", systemImage: "square.grid.2x2")
                }

                Button {
                    isTagPresented = true
                } label: {
                    Label("タグ管理", systemImage: "tag")
                }
            }
        }
        .navigationTitle("設定")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isCategoryPresented) {
            NavigationStack {
                CategoryPlaceholderView()
            }
        }
        .sheet(isPresented: $isTagPresented) {
            NavigationStack {
                TagPlaceholderView()
            }
        }
    }
}

// カテゴリ管理画面のプレースホルダー
private struct CategoryPlaceholderView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("カテゴリ管理")
                .font(.headline)
            Text("T-007で実装します")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("カテゴリ管理")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// タグ管理画面のプレースホルダー
private struct TagPlaceholderView: View {
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
        SettingsView()
    }
}
