@echo off
setlocal enabledelayedexpansion

set SCRIPT=test.py
set ENV_TARGET=envTest

REM === 配布フォルダ ===
set BASE_DIR=%~dp0

REM === pyenv の場所 ===
set PYENV_ROOT=%BASE_DIR%pyenv
set PYENV_WIN=%PYENV_ROOT%\pyenv-win
set PYENV_BIN=%PYENV_WIN%\pyenv-win\bin
set PYENV_CMD="%PYENV_BIN%\pyenv"

REM === pyenv-win が要求する環境変数（バッチ内だけで有効） ===
set PYENV=%PYENV_WIN%
set PYENV_HOME=%PYENV_WIN%
set PYENV_ROOT=%PYENV_WIN%

echo === ポータブル Python 実行環境 ===
echo BASE_DIR=%BASE_DIR%
echo.

REM --- pyenv が存在するかチェック ---
if not exist %PYENV_CMD% (
    echo pyenv が見つかりません。
    echo 先に setup_pyenv_portable.bat を実行してください。
    pause
    exit /b 1
)

REM --- .python-version を読み取る ---
set PY_VERSION=
if exist "%BASE_DIR%.python-version" (
    for /f "usebackq tokens=1" %%a in ("%BASE_DIR%.python-version") do (
        set PY_VERSION=%%a
    )
)

if "%PY_VERSION%"=="" (
    echo .python-version が見つからないか、バージョンが空です。
    pause
    exit /b 1
)

echo 使用する Python バージョン: %PY_VERSION%
echo.

REM --- venv が存在するかチェック ---
set VENV_DIR=%BASE_DIR%%ENV_TARGET%
set PYTHON_CMD= 

if exist "%VENV_DIR%\Scripts\python.exe" (
    echo 仮想環境を使用します: %VENV_DIR%

    call .\%ENV_TARGET%\Scripts\activate
    set PYTHON_CMD=%VENV_DIR%\Scripts\python.exe
) else (
    echo 仮想環境が見つかりません。pyenv exec を使用します。
    set PYTHON_CMD=call %PYENV_CMD% exec python
)

echo.

REM --- 実行する Python スクリプト ---

if not exist "%BASE_DIR%%SCRIPT%" (
    echo 実行対象のスクリプト "%SCRIPT%" が見つかりません。
    pause
    exit /b 1
)

echo === test.py を実行します ===
echo python "%BASE_DIR%%SCRIPT%"
echo.

call python "%BASE_DIR%%SCRIPT%"

echo.
echo === 実行完了 ===
pause
