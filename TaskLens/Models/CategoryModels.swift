import SwiftUI

// カテゴリの表示モデル
struct TaskCategory: Identifiable, Equatable, Hashable {
    let id: UUID
    let title: String
    let color: Color

    // 開発・プレビュー用のサンプルカテゴリ
    static let sampleCategories: [TaskCategory] = [
        TaskCategory(id: UUID(), title: "開発", color: .blue),
        TaskCategory(id: UUID(), title: "企画", color: .green),
        TaskCategory(id: UUID(), title: "レビュー", color: .orange),
        TaskCategory(id: UUID(), title: "調査", color: .purple),
        TaskCategory(id: UUID(), title: "運用", color: .pink)
    ]
}
