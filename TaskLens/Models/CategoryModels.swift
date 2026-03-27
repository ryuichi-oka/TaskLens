import SwiftUI

// カテゴリの表示モデル
struct TaskCategory: Identifiable, Equatable, Hashable {
    let id: UUID
    let title: String
    let color: Color

    // 開発・プレビュー用のサンプルカテゴリ
    static let sampleCategories: [TaskCategory] = [
        TaskCategory(id: UUID(), title: "開発", color: .categoryBlue),
        TaskCategory(id: UUID(), title: "企画", color: .categoryGreen),
        TaskCategory(id: UUID(), title: "レビュー", color: .categoryOrange),
        TaskCategory(id: UUID(), title: "調査", color: .categoryPurple),
        TaskCategory(id: UUID(), title: "運用", color: .categoryPink)
    ]
}
