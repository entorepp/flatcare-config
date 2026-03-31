# flatcare-config

フラットちゃん（Claude Code）の共有設定リポジトリ。

## セットアップ

```bash
# 1. このリポジトリを clone
gh repo clone entorepp/flatcare-config

# 2. このディレクトリで Claude Code を起動
cd flatcare-config
claude
```

## 使い方

### 見積り計算

```
/q calc [指示]    # ホテル見積もりから仕入原価・販売価格を計算
/q check          # 既存の見積もりデータの整合性チェック
/q template       # 新規見積もり計算用のテンプレートを出力
```

## 設定を更新したら

```bash
git add -A && git commit -m "update skill" && git push
```

他のメンバーは `git pull` で最新の設定を取得できます。
