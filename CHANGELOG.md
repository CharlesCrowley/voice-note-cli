# Voice Note CLI - Changelog

## v1.1.0 - File Output Feature (2025-10-19)

### Added
- **Optional file path argument** to both `vn` and `vn stop` commands
- **Automatic prepending** of transcriptions to existing files with `---` separator
- **Parent directory creation** - automatically creates nested directories if needed
- **Flexible path resolution** - supports relative, absolute, and home directory paths
- **Override capability** - path specified in `vn stop` overrides path from `vn`

### Changed
- Updated `vn` script to accept optional file path argument
- Updated `vn-stop` script to handle file writing logic
- Enhanced user feedback messages to show save destination
- Documentation updated with new file output examples

### Technical Details
- New state file: `/tmp/vn_state/vn_output_path.txt`
- Path resolution handles: `/absolute`, `~/home`, `./relative`
- Error handling for permission errors and invalid paths
- Always copies to clipboard even when saving to file

### Usage Examples

**Clipboard only** (unchanged):
```bash
vn
vn stop
```

**Save to file when starting**:
```bash
vn /path/to/file.md
vn stop
```

**Save to file when stopping**:
```bash
vn
vn stop /path/to/file.md
```

**Override saved path**:
```bash
vn /path/a.md
vn stop /path/b.md  # Uses b.md instead
```

### File Behavior

**New file**:
```
Transcription text here
```

**Existing file with content**:
```
Transcription text here

---

Previous content that was already in the file
```

---

## v1.0.0 - Initial Release (2025-10-19)

### Features
- Local transcription using mlx-whisper on Apple Silicon
- Two-command interface: `vn` and `vn stop`
- Automatic clipboard copy
- 1-hour recording limit
- State management with PID files
- Graceful error handling
- Auto-cleanup of temp files
- Real-time elapsed time display
- Ctrl+C cancellation support

### Technical Stack
- **Recording**: SoX (16kHz mono WAV)
- **Transcription**: mlx-whisper with small model
- **State**: PID-based process management
- **Platform**: macOS with Apple Silicon

### Installation
- One-command setup: `./install-vn.sh`
- Downloads and caches Whisper model (244MB)
- Adds commands to `~/.local/bin`
