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
                        .font(.bodyRegular)
                        .foregroundStyle(Color.textPrimary)
                }

                Button {
                    isTagPresented = true
                } label: {
                    Label("タグ管理", systemImage: "tag")
                        .font(.bodyRegular)
                        .foregroundStyle(Color.textPrimary)
                }
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(Color.backgroundPrimary)
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
