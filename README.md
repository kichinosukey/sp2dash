# sp2dash

`sp2dash` は、ブログのタイトルや論文の見出しなどを、ファイル名やURLとして扱いやすい「スラグ形式」に変換するコマンドラインツールです。

## 🔧 概要

自然文のスペースや記号を、ハイフン（`-`）やアンダースコア（`_`）に自動変換し、構造化された文字列を出力します。  
ファイル名・URL・Markdownのアンカー・識別子生成など、様々な用途に利用できます。

## 📦 使用例

```bash
sp2dash "Your Title Here"
# => Your-Title-Here

sp2dash "Your Title: Here"
# => Your-Title_Here
