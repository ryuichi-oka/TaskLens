# DB設計: TaskLens（仮）
日付: 2026-03-22

## 目的
- タスクのCRUD、予定/実績、タイムスケジュール表示、分析レポートに必要なデータ構造を定義する
- MVPに必要な範囲に絞り、将来的な拡張（同期・重複挙動選択）に備える

## 前提
- 初期はローカル保存
- 予定/実績は手入力が基本（自動計測は将来）
- タイムスケジュールはタスクに紐づく単一の予定枠を扱う（MVP）

## テーブル定義

### tasks
| カラム | 型 | 制約 | 説明 |
|---|---|---|---|
| id | UUID | PK | タスクID |
| title | String | NOT NULL | タイトル |
| notes | String | NULL | メモ |
| status | Enum | NOT NULL | todo/doing/done |
| category_id | UUID | NULL | categories.id |
| planned_minutes | Int | NULL | 予定時間（分） |
| actual_minutes | Int | NULL | 実績時間（分） |
| planned_start_at | DateTime | NULL | 予定開始（スケジュール用） |
| planned_end_at | DateTime | NULL | 予定終了（スケジュール用） |
| due_at | DateTime | NULL | 期限 |
| priority | Int | NULL | 優先度（例: 1-3） |
| created_at | DateTime | NOT NULL | 作成日時 |
| updated_at | DateTime | NOT NULL | 更新日時 |

### categories
| カラム | 型 | 制約 | 説明 |
|---|---|---|---|
| id | UUID | PK | カテゴリID |
| name | String | NOT NULL | 表示名 |
| color_hex | String | NULL | 表示色 |
| sort_order | Int | NOT NULL | 並び順 |
| created_at | DateTime | NOT NULL | 作成日時 |
| updated_at | DateTime | NOT NULL | 更新日時 |

### tags
| カラム | 型 | 制約 | 説明 |
|---|---|---|---|
| id | UUID | PK | タグID |
| name | String | NOT NULL | 表示名 |
| color_hex | String | NULL | 表示色 |
| created_at | DateTime | NOT NULL | 作成日時 |
| updated_at | DateTime | NOT NULL | 更新日時 |

### task_tags
| カラム | 型 | 制約 | 説明 |
|---|---|---|---|
| task_id | UUID | PK | tasks.id |
| tag_id | UUID | PK | tags.id |

## リレーション
- tasks 1 - 0..1 categories
- tasks N - N tags（task_tagsで中間）

## 主要ユースケースへの対応
- CRUD: tasks
- 予定/実績入力: tasks.planned_minutes / tasks.actual_minutes
- タイムスケジュール表示: tasks.planned_start_at / planned_end_at
- 期限と優先度: tasks.due_at / tasks.priority
- 分析
- 予実差分: planned_minutes - actual_minutes
- カテゴリ別時間: categories + tasks
- 週次サマリ: tasksの planned/actual を日付単位で集計（planned_start_at基準）

## ルール/制約
- planned_start_at と planned_end_at は15分単位で入力
- 重複はMVPで許可（将来設定で制御）

## 将来的な拡張案
- 実績計測の詳細化: actual_time_entries（開始/終了のログ）
- 複数スケジュール枠: task_schedule_entries
- 同期: iCloud/CloudKit 対応
