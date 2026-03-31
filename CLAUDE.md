# flatcare-config

flatcare.jp（車椅子ユーザー向けバリアフリー旅行サービス）の Claude Code 共有設定リポジトリ。

## Language

日本語で応答すること。コード内のコメントや変数名は英語でOK。

## このリポジトリの目的

- `/q` スキル（見積り計算・見積書作成）の共有管理
- フラットちゃんの動作ルールを全メンバーで統一

## 使い方

1. このリポジトリを clone する
2. `flatcare-config/` ディレクトリで Claude Code を起動する
3. `/q calc` 等のコマンドが使える

## Browser Automation

ブラウザ操作が必要な場合は **browser-use** を使うこと。Chrome MCP・Playwright MCP は使用禁止。

| サーバー名 | モード | 用途 |
|---|---|---|
| `browser-use` | ヘッドレス | デフォルト |
| `browser-use-real` | リアルブラウザ | フォールバック用 |

ヘッドレスでブロックされた場合、ユーザーの許可なく `browser-use-real` に切り替えてリトライしてよい。
