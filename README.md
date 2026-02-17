# ポータブル Python 実行環境（Windows）

Git やシステムの Python をインストールしていない、ごく普通の Windows 環境でも、フォルダ一式を置くだけで Python を動かせるセットアップ用スクリプトです。  
pyenv-win を ZIP で取得して展開し、**PATH を変更せず**そのフォルダ内だけで完結するポータブルな Python 環境を構築します。

## やりたいこと

- **ポータブルな pyenv 環境** … 配布フォルダ内に pyenv-win と Python を展開し、システムの PATH や既存の Python に依存しない
- **Git 不要** … pyenv-win は GitHub の ZIP を PowerShell でダウンロード・展開するだけ
- **ノーマルな Windows でも動作** … 特別なツールは使わず、標準のコマンドプロンプトと PowerShell のみでセットアップ・実行可能

## 必要な環境

- **Windows**（コマンドプロンプト・PowerShell が使えること）
- **インターネット接続**（初回セットアップ時に pyenv-win と Python のダウンロード用）
- Git や既存の Python のインストールは**不要**

## フォルダ構成（セットアップ後）

```
（このフォルダ）/
├── setup_pyenv_portable.bat   … 初回セットアップ用
├── run_script.bat             … Python スクリプト実行用
├── requirements.txt           … 任意。仮想環境に pip インストールするパッケージ一覧
└── test.py                    … 実行対象スクリプト（run_script.bat の既定）
```

## 使い方

### 1. 初回セットアップ

1. このフォルダを任意の場所に置く（USB や共有フォルダでも可）。
2. **`setup_pyenv_portable.bat`** をダブルクリックして実行する。
3. 処理内容:
   - 未導入なら pyenv-win を ZIP でダウンロード・展開
   - 指定バージョンの Python を pyenv でインストール（既定: 3.12.2）
   - `.python-version` を書き、そのバージョンをローカルに設定
   - 仮想環境 `envTest` を作成
   - 同フォルダに `requirements.txt` があれば、**仮想環境内**に `pip install -r requirements.txt` を実行

### 2. Python スクリプトの実行

1. **`run_script.bat`** をダブルクリックして実行する。
2. 処理内容:
   - `pyenv` と `.python-version` を確認
   - `envTest\Scripts\python.exe` があればその仮想環境を有効化して `python` を実行
   - 仮想環境がなければ `pyenv exec python` で実行
   - 既定では `test.py` を実行（先頭の `SCRIPT=test.py` で変更可能）

### カスタマイズ

- **Python バージョン**  
  `setup_pyenv_portable.bat` 内の `set PY_VERSION=3.12.2` を変更してからセットアップし直す。  
  既に `.python-version` がある場合は、`run_script.bat` はそのファイルを参照する。
- **実行するスクリプト**  
  `run_script.bat` の先頭で `set SCRIPT=test.py` を別のファイル名に変更する（例: `myapp.py`）。
- **仮想環境名**  
  両バッチの `ENV_NAME` / `ENV_TARGET` を同じ名前にしてそろえる（既定は `envTest`）。
- **依存パッケージ**  
  フォルダ直下に `requirements.txt` を置き、`setup_pyenv_portable.bat` を実行すると、仮想環境にインストールされる。

## 注意事項

- セットアップ時は **必ず先に `setup_pyenv_portable.bat`** を実行してください。`run_script.bat` は pyenv と `.python-version`（および任意で仮想環境）が整っていることを前提にしています。
- 環境は **このフォルダ内に閉じています**。システムの PATH は書き換えません。
- フォルダごとコピーすれば、別の「ノーマルな Windows」マシンでも同じ手順（同じフォルダで `run_script.bat` を実行）で Python を動かせます。

## ライセンス

MIT License

Copyright SAKI ITO(c) 2025

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
