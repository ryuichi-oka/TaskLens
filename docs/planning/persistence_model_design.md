# 永続化モデル設計（SwiftData）
日付: 2026-03-27

## 目的
- タスク/カテゴリ/タグの永続化を実現し、アプリ再起動後もデータを保持する。
- 画面間で同じデータソースを参照できる状態にする。

## 採用技術
- SwiftData（@Model / ModelContainer / ModelContext）

## モデル設計
### TaskModel
- id: UUID
- title: String（必須）
- memo: String
- status: TaskStatus（enum）
- priority: TaskPriority（enum）
- dueDate: Date
- plannedStart: Date
- plannedEnd: Date
- plannedHours: Double
- actualHours: Double
- category: CategoryModel?（1:N）
- tags: [TagModel]（M:N）

### CategoryModel
- id: UUID
- title: String（必須）
- colorHex: String
- sortOrder: Int

### TagModel
- id: UUID
- title: String（必須）
- sortOrder: Int

## 関連
- TaskModel → CategoryModel: 1対多
- TaskModel ↔ TagModel: 多対多

## 画面側の参照方針
- 一覧・詳細・作成・カテゴリ管理・タグ管理は SwiftData の Query を直接利用。
- 既存の表示用モデル（TaskListItem / TaskCategory / TaskTag）は段階的に置換。

## 初期データ
- 初回起動時のみサンプルデータを投入するかは実装時に判断。

## 実装順序（案）
1. モデル定義（@Model）を追加
2. ModelContainer を TaskLensApp に注入
3. タスク一覧/詳細/作成の CRUD を ModelContext 経由に置換
4. カテゴリ/タグ管理の CRUD を ModelContext 経由に置換
5. 画面間の参照を統一

## 検証観点
- 再起動後もタスク/カテゴリ/タグが保持される
- タスク作成時にカテゴリ/タグが正しく紐づく
- カテゴリ/タグの並び順が意図通り反映される
