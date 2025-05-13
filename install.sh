#!/bin/bash

# sp2dashのインストールスクリプト

# デフォルトのインストール先
DEFAULT_INSTALL_DIR="/usr/local/bin"

# インストール先の指定（環境変数INSTALLDIRがあればそれを使用）
INSTALL_DIR="${INSTALLDIR:-$DEFAULT_INSTALL_DIR}"

# 現在のディレクトリ
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# ヘルプメッセージ
show_help() {
  cat << EOF
sp2dash インストールスクリプト

使用方法:
  ./install.sh [オプション]

オプション:
  -h, --help    このヘルプメッセージを表示
  -d, --dir DIR インストール先ディレクトリを指定（デフォルト: $DEFAULT_INSTALL_DIR）

例:
  ./install.sh
  ./install.sh -d ~/bin
EOF
  exit 0
}

# 引数の処理
while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)
      show_help
      ;;
    -d|--dir)
      if [[ -n "$2" ]]; then
        INSTALL_DIR="$2"
        shift 2
      else
        echo "エラー: --dir オプションには引数が必要です" >&2
        exit 1
      fi
      ;;
    *)
      echo "不明なオプション: $1" >&2
      show_help
      ;;
  esac
done

# インストール処理
install_sp2dash() {
  # インストールディレクトリの存在確認
  if [[ ! -d "$INSTALL_DIR" ]]; then
    echo "ディレクトリ $INSTALL_DIR が存在しません。作成しますか？ [y/N]"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      mkdir -p "$INSTALL_DIR" || { echo "ディレクトリの作成に失敗しました"; exit 1; }
    else
      echo "インストールを中止します"
      exit 1
    fi
  fi

  # インストール先に書き込み権限があるか確認
  if [[ ! -w "$INSTALL_DIR" ]]; then
    echo "警告: $INSTALL_DIR に書き込み権限がありません。sudo を使用してインストールしますか？ [y/N]"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      sudo cp "$SCRIPT_DIR/sp2dash" "$INSTALL_DIR/" || { echo "インストールに失敗しました"; exit 1; }
      sudo chmod +x "$INSTALL_DIR/sp2dash" || { echo "実行権限の設定に失敗しました"; exit 1; }
    else
      echo "インストールを中止します"
      exit 1
    fi
  else
    cp "$SCRIPT_DIR/sp2dash" "$INSTALL_DIR/" || { echo "インストールに失敗しました"; exit 1; }
    chmod +x "$INSTALL_DIR/sp2dash" || { echo "実行権限の設定に失敗しました"; exit 1; }
  fi

  echo "sp2dash を $INSTALL_DIR にインストールしました"
  
  # PATHに追加の確認（必要な場合）
  if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo "注意: $INSTALL_DIR はPATHに含まれていません"
    echo "以下を .bashrc または .zshrc に追加することを検討してください:"
    echo "  export PATH=\"\$PATH:$INSTALL_DIR\""
  fi
}

# インストール実行
install_sp2dash