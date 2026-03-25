# Style定義のコード化方針
日付: 2026-03-25

## 目的
色・タイポ・余白のデザインルールをSwiftUIで再利用できる形に落とし込み、画面間の一貫性を保つ。

## 方針（MVP）
- `DesignSystem` として Swift ファイルに集約
- Color / Typography / Spacing を分割管理
- 画面・コンポーネントは `DesignSystem` を参照のみ
- 直接数値を書く場合は例外理由をコメントで残す

## 想定構成
- `TaskLens/DesignSystem/Colors.swift`
- `TaskLens/DesignSystem/Typography.swift`
- `TaskLens/DesignSystem/Spacing.swift`
- `TaskLens/DesignSystem/Components.swift`（共通スタイル）

## カラーの管理
- `Color.tokenName` 形式で定義
- 例: `Color.backgroundPrimary`, `Color.textSecondary`
- カテゴリ色は配列 or enum で定義

## タイポグラフィの管理
- `Font.tokenName` 形式
- 例: `Font.titleLarge`, `Font.body`, `Font.caption`
- フォントサイズ/ウェイトは Design System と一致させる

## 余白の管理
- `CGFloat.tokenName`
- 例: `Spacing.screenHorizontal = 16`

## コンポーネントの共通スタイル
- `RoundedCardStyle`
- `PrimaryButtonStyle`
- `StatusBadgeStyle`

## 運用ルール
- 新しい色/サイズを追加する場合は Design System に追加
- 例外が増えたらデザイン側に差分確認
- 命名は英語で統一
