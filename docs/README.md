# TaskLens Docs

最終版の要件・設計・受け入れ基準などをフェーズ別にまとめたディレクトリ。
タスク管理は `.company/` に集約する。

## ディレクトリ構成
- requirements/
- design/
- planning/
- qa/

## 各ディレクトリの内容
### requirements/
- requirements.md
- mvp_scope.md

### design/
- design_spec_final.md
- screen_flow_mermaid.md
- ui_component_list.md
- style_coding_guidelines.md
- validation_messages.md
- empty_loading_error_messages.md
- input_constraints.md
- information_priority.md

### planning/
- implementation_roadmap.md
- implementation_tickets.md

### qa/
- acceptance_criteria_by_screen.md
- qa_test_plan.md

## 運用ルール（周知）
- 要件・設計変更があった場合は、通常通りログは残しつつ `docs/` 内の該当ドキュメントを更新すること
- 実装やテストをする際は、必ず `docs/` 内の最新版ドキュメントを参照すること

### design/
- ui_state_placement.md
- navigation_details.md
