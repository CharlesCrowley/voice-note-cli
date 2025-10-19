# Voice Note CLI - Quick Reference

## Installation (One-Time)

```bash
git clone https://github.com/CharlesCrowley/voice-note-cli.git ~/bin/voice-note-cli
cd ~/bin/voice-note-cli
./install-vn.sh
source ~/.zshrc
```

**Time**: ~2-3 minutes

---

## Daily Usage

### Record a Voice Note (Clipboard)

```bash
vn                    # Start recording
# ... speak ...
vn stop              # Stop and transcribe
# Text auto-copied to clipboard!
```

### Record and Save to File

```bash
vn /path/to/file.md  # Start recording
# ... speak ...
vn stop              # Prepends to file + clipboard

# OR

vn                   # Start recording
vn stop ~/notes.md   # Specify file at stop time
```

### Cancel Recording

```bash
vn                    # Start
# Press Ctrl+C to cancel
```

---

## What Gets Installed

```
~/.local/bin/vn              # Start command
~/.local/bin/vn-stop         # Stop command
~/.vn/venv/                  # Python environment
~/.cache/huggingface/        # Whisper model (244MB)
```

---

## Limits

- **Max Duration**: 1 hour (auto-stops)
- **Language**: English only (configurable)
- **Privacy**: 100% local, no cloud API
- **Format**: 16kHz mono WAV

---

## Performance

| Audio Length | Transcription Time |
|--------------|-------------------|
| 10 seconds   | ~1-2s             |
| 1 minute     | ~3-6s             |
| 5 minutes    | ~15-20s           |
| 30 minutes   | ~90-120s          |

---

## Common Issues

### "sox not installed"
```bash
brew install sox
```

### "No active recording"
Run `vn` first before `vn stop`

### "Recording already in progress"
Finish current recording with `vn stop`

---

## Uninstall

```bash
rm -rf ~/.vn ~/.local/bin/vn ~/.local/bin/vn-stop ~/.local/bin/vn-transcribe.py
brew uninstall sox
```

---

## Tips

1. **Speak clearly** - Better accuracy
2. **Quiet environment** - Less noise
3. **Paste immediately** - Clipboard overwritten on next copy
4. **Multiple ideas** - Run multiple sessions
5. **Brainstorming** - Great for quick thoughts

---

## File Locations

**Temp files** (auto-deleted):
```
/tmp/vn_state/vn_TIMESTAMP.wav
```

**Permanent install**:
```
~/.local/bin/                # Commands
~/.vn/venv/                  # Python env
~/.cache/huggingface/        # AI model
```

---

## Architecture

```
vn → SoX → WAV file → vn stop → mlx-whisper → Text → Clipboard
```

**All processing local on your Mac!**
