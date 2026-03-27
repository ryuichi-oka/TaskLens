import SwiftUI

// アプリのタブ構成と共通ヘッダーを管理するルート画面
struct ContentView: View {
    private enum Tab: Hashable {
        case tasks
        case schedule
        case analytics
    }

    @State private var selectedTab: Tab = .tasks
    @State private var isSettingsPresented = false

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                TaskListView()
                    .navigationTitle("一覧")
                    .toolbar { commonToolbar() }
            }
            .tabItem {
                Label("タスク", systemImage: "checklist")
            }
            .tag(Tab.tasks)

            NavigationStack {
                ScheduleView()
                    .navigationTitle("スケジュール")
                    .toolbar { commonToolbar() }
            }
            .tabItem {
                Label("スケジュール", systemImage: "calendar")
            }
            .tag(Tab.schedule)

            NavigationStack {
                AnalyticsView()
                    .navigationTitle("分析")
                    .toolbar { commonToolbar() }
            }
            .tabItem {
                Label("分析", systemImage: "chart.bar.xaxis")
            }
            .tag(Tab.analytics)
        }
        .sheet(isPresented: $isSettingsPresented) {
            SettingsPlaceholderView()
        }
    }

    // 画面共通のナビゲーションヘッダーを生成する
    @ToolbarContentBuilder
    private func commonToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                isSettingsPresented = true
            } label: {
                Image(systemName: "line.3.horizontal")
            }
            .accessibilityLabel("設定")
        }
    }
}

#Preview {
    ContentView()
}
