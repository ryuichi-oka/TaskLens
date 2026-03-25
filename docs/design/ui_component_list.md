# UIコンポーネント一覧（実装用）
日付: 2026-03-25

## 目的
実装フェーズで再利用するUI部品を明確化し、SwiftUIのコンポーネント設計に落とし込む。

## 基本コンポーネント
- AppHeader
  - 左: ハンバーガー
  - 中央: タイトル
  - 右: 予備枠
- FloatingActionButton
  - 右下固定の＋ボタン
- FilterChip
  - 状態/カテゴリ/タグのチップ
- StatusBadge
  - Todo/Doing/Done のバッジ
- EmptyStateView
  - アイコン + タイトル + サブ文
- ToastView
  - 画面中央下部の短時間通知

## タスク一覧系
- TaskCard
  - 1行目: タイトル / 状態バッジ
  - 2行目: 期限 / 優先度（期限超過は赤）
  - 3行目: 予定/実績 / カテゴリ色ドット

## スケジュール系
- DateSwitchBar
  - 前/次ボタン + 日付表示 + 今日ボタン
- TimeAxisView
  - 0:00-24:00の時間軸
- ScheduleBlock
  - 予定枠（カテゴリ色背景 + 左線 + タイトル/時間）

## 分析系
- PlannedActualBarChart
- CategoryTimeChart
- WeeklySummaryLineChart
- ChartSectionCard
  - グラフ共通カード

## モーダル/フォーム系
- TaskFormView
  - タスク詳細/新規作成の共通フォーム
- CategoryEditForm
- TagEditForm

## 設定/管理系
- CategoryRow
- TagRow

## ガイド
- 画面はコンポーネントの組み合わせで構成
- 共有スタイル（色/タイポ/余白）はStyle定義に集約
