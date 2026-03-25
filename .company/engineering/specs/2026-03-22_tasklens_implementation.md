# 技術仕様: TaskLens MVP 実装仕様
日付: 2026-03-22

## 概要
タスク管理MVPのデータモデル、画面状態、主要フローを定義する。
ローカル保存でCRUD・予定/実績・スケジュール・分析（グラフ）を実装する。

## 技術選定
- 言語/フレームワーク: Swift / SwiftUI
- データ保存: SwiftData（ローカル）
- グラフ表示: Charts フレームワーク
- 理由:
- iOSネイティブで保守性が高い
- ローカル保存要件に適合
- グラフ表示を標準APIで実装可能

## データモデル

### Task
- id: UUID
- title: String
- notes: String?
- status: TaskStatus（todo/doing/done）
- category: Category?
- tags: [Tag]
- plannedMinutes: Int?
- actualMinutes: Int?
- plannedStartAt: Date?
- plannedEndAt: Date?
- dueAt: Date?
- priority: Int?（1-3）
- createdAt: Date
- updatedAt: Date

### Category
- id: UUID
- name: String
- colorHex: String?
- sortOrder: Int
- createdAt: Date
- updatedAt: Date

### Tag
- id: UUID
- name: String
- colorHex: String?
- createdAt: Date
- updatedAt: Date

## 画面構成と状態

### タブ: タスク一覧
- 表示: タスクのリスト（状態・カテゴリ・期限・予定/実績）
- 操作: フローティングボタンで新規作成
- タップ: 詳細モーダル（閲覧/編集/削除）

### タブ: タイムスケジュール
- 表示: 日別の予定枠を縦軸時間で表示
- 操作: フローティングボタンで新規作成
- タップ: 詳細モーダル（閲覧/編集）
- ドラッグ&ドロップ: 15分スナップ、重複は許可

### タブ: 分析
- 予実差分: 棒グラフ（予定/実績）+ 差分ラベル
- カテゴリ別時間: 横棒 or 円グラフ
- 週次サマリ: 折れ線（1週間の日別合計）

### サブ画面: 設定
- カテゴリ管理（追加/編集/削除）
- タグ管理（追加/編集/削除）

## 実装メモ
- スケジュール表示は plannedStartAt / plannedEndAt を基準に集計
- 週次サマリは plannedStartAt の日付で集計
- 予定/実績差分は null セーフに扱う
- 15分スナップはドラッグ終了時に丸める
- 将来的に重複挙動設定を追加できる設計にする

## 動作確認方法
- タスクCRUDが正常に動作すること
- 予定/実績入力が保存され、一覧/分析に反映されること
- スケジュールのドラッグ&ドロップで15分スナップが効くこと
- 分析タブの3種グラフが表示されること
