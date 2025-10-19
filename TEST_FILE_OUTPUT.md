# Test File Output Feature

## Manual Testing Checklist

### Test 1: Save to New File (Relative Path)
```bash
cd /Users/charliecrowley/Firstly-Academy
vn test-output.md
# Speak: "This is a test of the file output feature"
vn stop
# Expected: Creates test-output.md in current directory
cat test-output.md  # Should show transcription only
rm test-output.md   # Cleanup
```

### Test 2: Save to Existing File (Prepend)
```bash
echo "# Existing Content" > test-existing.md
echo "This was already here" >> test-existing.md
vn test-existing.md
# Speak: "This is new content from voice note"
vn stop
# Expected: New content prepended with --- separator
cat test-existing.md
# Should show:
# This is new content from voice note
#
# ---
#
# # Existing Content
# This was already here
rm test-existing.md  # Cleanup
```

### Test 3: Absolute Path
```bash
vn /Users/charliecrowley/Firstly-Academy/test-absolute.md
# Speak: "Testing absolute path"
vn stop
# Expected: Creates file at absolute path
cat /Users/charliecrowley/Firstly-Academy/test-absolute.md
rm /Users/charliecrowley/Firstly-Academy/test-absolute.md  # Cleanup
```

### Test 4: Home Directory Path
```bash
vn ~/test-home.md
# Speak: "Testing home directory path"
vn stop
# Expected: Creates file in home directory
cat ~/test-home.md
rm ~/test-home.md  # Cleanup
```

### Test 5: Create Parent Directories
```bash
vn /tmp/vn-test/nested/deep/file.md
# Speak: "Testing directory creation"
vn stop
# Expected: Creates all parent directories
cat /tmp/vn-test/nested/deep/file.md
rm -rf /tmp/vn-test  # Cleanup
```

### Test 6: Override Path at Stop
```bash
vn test-a.md
# Speak: "This should go to test-b"
vn stop test-b.md
# Expected: Saves to test-b.md (NOT test-a.md)
cat test-b.md  # Should exist
[ ! -f test-a.md ] && echo "✅ test-a.md not created (correct)"
rm test-b.md  # Cleanup
```

### Test 7: Clipboard Only (No File)
```bash
vn
# Speak: "Clipboard only test"
vn stop
# Expected: Clipboard has content, no file created
pbpaste  # Should show transcription
```

### Test 8: Real Use Case (Your Example)
```bash
cd /Users/charliecrowley/Firstly-Academy
vn docs/voice-chat/native-chat/features/referral-exclusive.md
# Speak your actual idea
vn stop
# Expected: Prepends to referral-exclusive.md
cat docs/voice-chat/native-chat/features/referral-exclusive.md
```

### Test 9: Error Handling (Invalid Path)
```bash
vn /invalid/path/that/cannot/be/created.md
# Expected: Error message and graceful handling
```

### Test 10: Empty File
```bash
touch test-empty.md
vn test-empty.md
# Speak: "Testing empty file"
vn stop
# Expected: Writes transcription only (no separator)
cat test-empty.md
rm test-empty.md  # Cleanup
```

## Automated Syntax Check

```bash
bash -n vn
bash -n vn-stop
python3 -m py_compile vn-transcribe.py
```

All should pass without errors.
