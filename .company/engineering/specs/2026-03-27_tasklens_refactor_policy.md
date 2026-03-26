# 技術仕様: 画面/コンポーネント分割リファクタ方針
日付: 2026-03-27

## 概要
ContentView.swift に集約された実装を、画面・コンポーネント・モデル・スタイルに分割し、見通しと再利用性を高める。

## 技術選定
- 言語/フレームワーク: Swift / SwiftUI
- 理由: 既存UI実装の責務分離とファイル単位の保守性を向上させるため。

## 設計
- Views: 画面単位のView（例: TaskListView, TaskDetailSheet, Placeholder群）
- Components: 再利用可能なUI部品（例: TaskCardView, FilterChip）
- Models: 画面で使うデータ構造・列挙体（例: TaskListItem, TaskStatus）
- Styles: 画面共通のレイアウト定数（Layout）
- ContentView: タブ/ナビゲーションと画面切替のみを担当

## 実装メモ
- 既存のUIロジックは最小変更でファイル分割に移行
- Preview は各ファイルに最低1つ配置

## 動作確認方法
- Xcode Preview で各 View の表示を確認
- 実機/シミュレータでタブ切替とタスク詳細シートが動作することを確認
