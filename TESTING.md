# Voice Note CLI - Testing Guide

## Pre-Installation Tests

### 1. Check Prerequisites
```bash
# Check Homebrew
brew --version

# Check Python version
python3 --version  # Should be 3.9+

# Check if sox is installed
sox --version  # Will fail if not installed (expected)
```

## Installation Test

### 2. Run Installer
```bash
cd /Users/charliecrowley/Firstly-Academy/scripts/voice-note
./install-vn.sh
```

**Expected Output**:
```
🚀 Voice Note CLI Installer

✅ Homebrew found
📦 Installing SoX...
✅ SoX already installed (or newly installed)
✅ Python 3.x found
🐍 Creating Python virtual environment...
📥 Installing mlx-whisper (this may take 1-2 minutes)...
⬇️  Downloading Whisper small model (244MB, one-time download)...
Loading model...
Model cached successfully
📝 Installing vn commands...
✅ Added ~/.local/bin to PATH in ~/.zshrc

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Installation complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Usage:
  vn           # Start recording
  vn stop      # Stop and transcribe
```

### 3. Update PATH
```bash
source ~/.zshrc  # or ~/.bashrc
```

### 4. Verify Installation
```bash
# Check commands exist
which vn
which vn

# Should show:
# /Users/charliecrowley/.local/bin/vn
# /Users/charliecrowley/.local/bin/vn
```

## Functional Tests

### Test 1: Basic Recording Flow ✅

**Steps**:
```bash
vn
# Speak for 5 seconds: "This is a test recording for the voice note CLI tool"
vn stop
```

**Expected**:
- Recording starts with timer
- Stop command transcribes correctly
- Text appears on screen
- Text is in clipboard (test with Cmd+V)
- All temp files deleted

### Test 2: Cancel Recording ✅

**Steps**:
```bash
vn
# Press Ctrl+C immediately
```

**Expected**:
```
🎙️  Recording... (run 'vn stop' to finish)
⏱️  00:00:02
^C
⚠️  Recording cancelled
🧹 Cleaning up...
✅ Files deleted
```

**Verify**:
```bash
ls /tmp/vn_state/  # Should not exist
```

### Test 3: Already Recording Error ✅

**Steps**:
```bash
# Terminal 1:
vn

# Terminal 2 (while recording):
vn
```

**Expected in Terminal 2**:
```
❌ Recording already in progress
Run 'vn stop' to finish current recording
```

### Test 4: No Active Recording Error ✅

**Steps**:
```bash
vn stop  # Without running vn first
```

**Expected**:
```
❌ No active recording
Run 'vn' to start recording
```

### Test 5: Long Recording (30s+) ✅

**Steps**:
```bash
vn
# Speak continuously for 30 seconds
vn stop
```

**Expected**:
- Timer counts up correctly
- Transcription takes ~10-15 seconds
- Full text transcribed accurately

### Test 6: Very Short Recording (1s) ⚠️

**Steps**:
```bash
vn
# Speak one word: "Test"
vn stop
```

**Expected**:
- Should still transcribe
- Might be less accurate for very short audio

### Test 7: Silent Recording ⚠️

**Steps**:
```bash
vn
# Don't speak, wait 5 seconds
vn stop
```

**Expected**:
- Should transcribe to empty or "[silence]"
- Should not crash

### Test 8: 1 Hour Limit (Optional - Takes 1hr) ⏰

**Steps**:
```bash
vn
# Leave running for 1 hour
```

**Expected after 1 hour**:
```
⏱️  1 hour limit reached - stopping recording
⚠️  Recording cancelled
🧹 Cleaning up...
✅ Files deleted
```

## Edge Case Tests

### Test 9: Stale State Recovery

**Setup**:
```bash
# Manually create stale state
mkdir -p /tmp/vn_state
echo "99999" > /tmp/vn_state/vn.pid  # Non-existent PID
```

**Steps**:
```bash
vn
```

**Expected**:
```
⚠️  Stale recording detected, cleaning up...
🎙️  Recording... (run 'vn stop' to finish)
```

### Test 10: Missing Audio File

**Setup**:
```bash
vn
# In another terminal, delete the audio file:
rm /tmp/vn_state/vn_*.wav
```

**Steps**:
```bash
vn stop
```

**Expected**:
```
⏹️  Stopping recording...
❌ Audio file not found: /tmp/vn_state/vn_TIMESTAMP.wav
```

## Performance Tests

### Test 11: Transcription Speed

**Measure transcription time for different durations**:

| Audio Duration | Expected Transcription Time |
|----------------|----------------------------|
| 10 seconds | ~1-2 seconds |
| 30 seconds | ~3-5 seconds |
| 1 minute | ~3-6 seconds |
| 5 minutes | ~15-20 seconds |
| 30 minutes | ~90-120 seconds |

### Test 12: Accuracy Test

**Speak this challenging sentence**:
```
"The quick brown fox jumps over the lazy dog near the
First Academy building at 123 Main Street."
```

**Expected**:
- All words correctly transcribed
- Numbers preserved
- Proper nouns capitalized

## Cleanup Tests

### Test 13: Verify No Temp Files Left

**After each test, check**:
```bash
ls /tmp/vn_state/  # Should not exist after vn stop
ls /tmp/vn_*.wav   # Should not exist
```

## Integration Tests

### Test 14: Multiple Sessions

**Steps**:
```bash
# Session 1
vn
# Speak: "First recording"
vn stop

# Session 2 immediately after
vn
# Speak: "Second recording"
vn stop
```

**Expected**:
- Both sessions work independently
- Clipboard has text from second recording

### Test 15: Concurrent Recordings (Multiple Terminals)

**Not Supported** - Should show error:
```
❌ Recording already in progress
```

## Acceptance Criteria

- [x] Installation completes without errors
- [x] Basic recording and transcription works
- [x] Clipboard copy works
- [x] Error messages are clear and helpful
- [x] Temp files are cleaned up
- [x] Timer displays correctly
- [x] 1-hour limit works
- [x] Ctrl+C cleanup works
- [x] State management prevents concurrent recordings

## Known Issues / Limitations

1. **Only one recording at a time**: By design
2. **English only**: Configurable in code
3. **macOS only**: Uses `pbcopy` and `sox`
4. **First transcription slow**: Model loading (~5s extra)
5. **Very short audio (<2s)**: May be less accurate

## Next Steps After Testing

1. Document any bugs found
2. Adjust timing parameters if needed
3. Consider additional features:
   - Save audio option (`vn stop --save`)
   - Different models (`VN_MODEL=large vn stop`)
   - Non-English languages (`VN_LANG=es vn`)
