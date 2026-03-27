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
        .listStyle(.plain)
        .navigationTitle("設定")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isCategoryPresented) {
            NavigationStack {
                CategoryManagementView()
            }
        }
        .sheet(isPresented: $isTagPresented) {
            NavigationStack {
                TagManagementView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
}
