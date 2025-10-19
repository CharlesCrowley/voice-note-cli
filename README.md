# Voice Note CLI

Ultra-simple terminal-based voice transcription tool using local AI (no API keys needed).

## Features

- **Dead Simple**: Just two commands (`vn` and `vn stop`)
- **Save to File**: Optionally save transcriptions directly to markdown files (prepends to existing content)
- **100% Local**: Uses mlx-whisper on Apple Silicon (no cloud API)
- **Fast**: ~3 seconds to transcribe 1 minute of audio
- **Private**: Audio never leaves your machine
- **Auto-Copy**: Transcription automatically copied to clipboard
- **No UI**: Pure terminal, perfect for quick notes

## Installation

```bash
# Clone the repository
git clone https://github.com/CharlesCrowley/voice-note-cli.git ~/bin/voice-note-cli

# Run installer
cd ~/bin/voice-note-cli
./install-vn.sh

# Activate in current shell
source ~/.zshrc
```

This will:
1. Install SoX (audio recording)
2. Create Python virtual environment
3. Install mlx-whisper
4. Download Whisper small model (244MB, one-time)
5. Add `vn` commands to your PATH

**First-time setup**: ~2-3 minutes

## Usage

### Basic Usage (Clipboard Only)

```bash
vn              # Start recording
# ... speak your thoughts ...
vn stop         # Stop, transcribe, and copy to clipboard
```

### Save to File

```bash
# Option 1: Specify file when starting
vn /path/to/file.md     # Start recording, will save to this file
vn stop                  # Transcription prepended to file + clipboard

# Option 2: Specify file when stopping
vn                       # Start recording
vn stop /path/to/file.md # Transcription prepended to file + clipboard

# Option 3: Override saved path
vn /path/to/file-a.md    # Start recording
vn stop /path/to/file-b.md  # Override with different file
```

**File Behavior**:
- If file exists: Transcription is **prepended** to the top with `---` separator
- If file doesn't exist: New file is created
- Parent directories are created automatically
- Always copies to clipboard too

### Example Session (Clipboard Only)

```bash
$ vn
🎙️  Recording... (run 'vn stop' to finish)
⏱️  00:00:45

$ vn stop
⏹️  Stopped recording (duration: 45s)
📝 Transcribing... (may take ~3s)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Here is my idea for a new feature that allows
users to collaborate in real-time on shared
documents with voice annotations.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Copied to clipboard!
✅ Done
```

### Example Session (Save to File)

```bash
$ vn docs/features/new-feature.md
🎙️  Recording... (will save to: /Users/username/projects/my-app/docs/features/new-feature.md)
⏱️  00:00:30

$ vn stop
⏹️  Stopped recording (duration: 30s)
📝 Transcribing... (may take ~3s)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Here is my idea for a new feature that helps
users track their daily progress...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
💾 Saved to: /Users/username/projects/my-app/docs/features/new-feature.md
📋 Copied to clipboard!
✅ Done
```

**File content** (prepended to top):
```markdown
Here is my idea for a new feature that helps
users track their daily progress...

---

# Existing Content

Old content that was already in the file...
```

## Limits

- **Max Duration**: 1 hour (auto-stops)
- **Format**: 16kHz mono WAV (optimized for speech)
- **Language**: English (configurable in code)
- **Model**: Whisper Small (244MB, good accuracy)

## Requirements

- **macOS** with Apple Silicon (M1/M2/M3)
- **Python 3.9+**
- **Homebrew**
- **~500MB disk space** (for model + dependencies)

## How It Works

1. **vn**: Starts SoX recording to `/tmp/vn_state/`
2. **vn stop**:
   - Stops SoX process
   - Runs mlx-whisper transcription
   - Copies text to clipboard
   - Deletes audio file

## Troubleshooting

### "No active recording"
```bash
$ vn stop
❌ No active recording
Run 'vn' to start recording
```
**Solution**: Run `vn` first to start recording.

### "Recording already in progress"
```bash
$ vn
❌ Recording already in progress
Run 'vn stop' to finish current recording
```
**Solution**: Finish the current recording with `vn stop` first.

### "sox not installed"
```bash
❌ Error: sox not installed
Install with: brew install sox
```
**Solution**: Run `brew install sox`

### "Python environment not found"
**Solution**: Run `./install-vn.sh` again

### Transcription fails
Audio is automatically saved to `/tmp/vn_backup_TIMESTAMP.wav` for manual recovery.

## Performance

**Transcription Speed** (Apple Silicon M1/M2/M3):
- 1 minute audio: ~3 seconds
- 5 minutes: ~15 seconds
- 30 minutes: ~90 seconds
- 60 minutes: ~180 seconds

**Recording Overhead**:
- CPU: <5%
- Memory: ~50MB
- Disk: ~10MB per minute

## Privacy

- ✅ 100% local processing
- ✅ No API keys required
- ✅ No internet connection needed
- ✅ Audio auto-deleted after transcription
- ✅ No logs or history stored

## Files

```
~/.local/bin/
├── vn                  # Start recording
├── vn-stop             # Stop & transcribe
└── vn-transcribe.py    # Python helper

~/.vn/
└── venv/               # Python environment

/tmp/vn_state/          # Temporary (auto-cleaned)
├── vn.pid
├── vn_audio_path.txt
└── vn_TIMESTAMP.wav
```

## Uninstall

```bash
rm -rf ~/.vn
rm ~/.local/bin/vn ~/.local/bin/vn-stop ~/.local/bin/vn-transcribe.py
brew uninstall sox  # Optional
```

## Advanced

### Change Model

Edit `vn-transcribe.py` and change:
```python
path_or_hf_repo="mlx-community/whisper-small"
```

Options:
- `whisper-tiny` (39MB, fastest, less accurate)
- `whisper-small` (244MB, recommended)
- `whisper-medium` (769MB, more accurate)
- `whisper-large-v3-turbo` (1.5GB, best accuracy)

### Force Different Language

Edit `vn-transcribe.py`:
```python
language="es"  # Spanish
language="fr"  # French
language=None  # Auto-detect
```

### Keep Audio Files

Modify `vn-stop` to comment out:
```bash
# rm -f "$AUDIO_PATH"
```

Audio will remain in `/tmp/vn_state/`

## Tips

1. **Speak clearly** and avoid background noise
2. **Use for brainstorming**: Great for capturing quick ideas
3. **Paste immediately**: Clipboard is overwritten by next copy
4. **Multiple terminals**: Each gets its own recording session
5. **Cancel recording**: Press Ctrl+C during `vn` to cancel

## Credits

- **mlx-whisper**: https://github.com/ml-explore/mlx-examples
- **OpenAI Whisper**: https://github.com/openai/whisper
- **SoX**: http://sox.sourceforge.net/

## License

MIT
