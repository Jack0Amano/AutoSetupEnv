@echo off
setlocal enabledelayedexpansion

set ENV_NAME=envTest
set PY_VERSION=3.12.2

REM === 配布フォルダ ===
set BASE_DIR=%~dp0

REM === pyenv の場所 ===
set PYENV_ROOT=%BASE_DIR%pyenv
set PYENV_WIN=%PYENV_ROOT%\pyenv-win
set PYENV_BIN=%PYENV_WIN%\pyenv-win\bin
set PYENV_CMD="%PYENV_BIN%\pyenv"
echo %PYENV_CMD%


echo === ポータブル pyenv セットアップ（PATH 不使用） ===
echo BASE_DIR=%BASE_DIR%
echo.

REM === ZIP ダウンロード URL ===
set PYENV_ZIP_URL=https://github.com/pyenv-win/pyenv-win/archive/refs/heads/master.zip
set ZIP_FILE=%BASE_DIR%pyenv-win.zip

REM --- 既に pyenv があればスキップ ---
if exist "%PYENV_WIN%" (
    echo 既に pyenv-win が存在します。展開をスキップします。
    goto :SETUP_ENV
)

echo pyenv-win を ZIP でダウンロード中...
powershell -Command "(New-Object Net.WebClient).DownloadFile('%PYENV_ZIP_URL%', '%ZIP_FILE%')"

echo ZIP を展開中...
powershell -Command "Expand-Archive -Path '%ZIP_FILE%' -DestinationPath '%PYENV_ROOT%' -Force"

REM 展開されたフォルダ名を pyenv-win にリネーム
for /d %%D in ("%PYENV_ROOT%\pyenv-win-*") do (
    ren "%%D" pyenv-win
)

del "%ZIP_FILE%"

:SETUP_ENV


REM === pyenv-win が要求する環境変数（バッチ内だけで有効） ===
set PYENV=%PYENV_WIN%
set PYENV_HOME=%PYENV_WIN%
set PYENV_ROOT=%PYENV_WIN%

echo PYENV=%PYENV%
echo PYENV_HOME=%PYENV_HOME%
echo PYENV_ROOT=%PYENV_ROOT%
echo.

echo.


REM --- pyenv バージョン確認 ---
call %PYENV_CMD% --version
echo.

REM --- Python バージョン指定 ---


echo Python %PY_VERSION% をインストールします...
call %PYENV_CMD% install %PY_VERSION%

echo.

echo pyenv local %PY_VERSION%
call %PYENV_CMD% local %PY_VERSION%

echo 仮想環境 %ENV_NAME% を作成します...
call %PYENV_CMD% exec python -m venv %ENV_NAME%

echo.
echo --- 仮想環境構築完了 ---

REM === requirements.txt があれば仮想環境にインストール ===
set VENV_PYTHON=%BASE_DIR%%ENV_NAME%\Scripts\python.exe
set VENV_PIP=%BASE_DIR%%ENV_NAME%\Scripts\pip.exe
if exist "%BASE_DIR%requirements.txt" (
    echo requirements.txt を検出しました。仮想環境 %ENV_NAME% にパッケージをインストールします...
    call "%VENV_PYTHON%" -m pip install --upgrade pip
    call "%VENV_PIP%" install -r "%BASE_DIR%requirements.txt"
) else (
    echo requirements.txt は見つかりませんでした。スキップします。
)

echo.

echo.
echo === セットアップ完了 ===