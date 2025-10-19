#!/bin/bash

set -e

echo "🚀 Voice Note CLI Installer"
echo ""

if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew required"
    echo "Install from: https://brew.sh"
    exit 1
fi

echo "✅ Homebrew found"

if ! command -v sox &> /dev/null; then
    echo "📦 Installing SoX..."
    brew install sox
else
    echo "✅ SoX already installed"
fi

python_version=$(python3 --version 2>&1 | awk '{print $2}')
required_version="3.9"

if [ "$(printf '%s\n' "$required_version" "$python_version" | sort -V | head -n1)" != "$required_version" ]; then
    echo "❌ Python 3.9+ required (found $python_version)"
    exit 1
fi

echo "✅ Python $python_version found"

VENV_PATH="$HOME/.vn/venv"

if [ -d "$VENV_PATH" ]; then
    echo "⚠️  Existing installation found at $VENV_PATH"
    read -p "Reinstall? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$HOME/.vn"
    else
        echo "Installation cancelled"
        exit 0
    fi
fi

echo "🐍 Creating Python virtual environment..."
mkdir -p "$HOME/.vn"
python3 -m venv "$VENV_PATH"

source "$VENV_PATH/bin/activate"

echo "📥 Installing mlx-whisper (this may take 1-2 minutes)..."
pip install -q --upgrade pip
pip install -q mlx-whisper

echo "⬇️  Downloading Whisper small model (244MB, one-time download)..."
python3 << 'EOF'
import mlx_whisper
from huggingface_hub import snapshot_download
print("Downloading model...")
snapshot_download(repo_id="mlx-community/whisper-small-mlx")
print("Model cached successfully")
EOF

echo "📝 Installing vn commands..."
mkdir -p "$HOME/.local/bin"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -sf "$SCRIPT_DIR/vn" "$HOME/.local/bin/vn"
ln -sf "$SCRIPT_DIR/vn-stop" "$HOME/.local/bin/vn-stop"
ln -sf "$SCRIPT_DIR/vn-transcribe.py" "$HOME/.local/bin/vn-transcribe.py"

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    if [ -f "$HOME/.zshrc" ]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
        echo "✅ Added ~/.local/bin to PATH in ~/.zshrc"
        NEED_SOURCE=true
    elif [ -f "$HOME/.bashrc" ]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        echo "✅ Added ~/.local/bin to PATH in ~/.bashrc"
        NEED_SOURCE=true
    fi
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Installation complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Scripts installed from: $SCRIPT_DIR"
echo "Commands available globally: vn, vn-stop"
echo ""
echo "Usage:"
echo "  vn                    # Start recording (clipboard)"
echo "  vn /path/to/file.md   # Start recording (save to file)"
echo "  vn stop               # Stop and transcribe"
echo ""

if [ "$NEED_SOURCE" = true ]; then
    echo "⚠️  Run this command to update your PATH:"
    if [ -f "$HOME/.zshrc" ]; then
        echo "  source ~/.zshrc"
    else
        echo "  source ~/.bashrc"
    fi
    echo ""
fi

echo "Test it now:"
echo "  vn"
echo "  (speak for a few seconds)"
echo "  vn stop"
echo ""
