#!/usr/bin/env python3

import sys
import os
from pathlib import Path

def transcribe(audio_path: str) -> str:
    try:
        import mlx_whisper
    except ImportError:
        raise ImportError(
            "mlx-whisper not installed. "
            "Run: pip install mlx-whisper"
        )

    audio_file = Path(audio_path)
    if not audio_file.exists():
        raise FileNotFoundError(f"Audio file not found: {audio_path}")

    if audio_file.stat().st_size == 0:
        raise ValueError("Audio file is empty")

    # Suppress progress bars and other output from mlx_whisper
    # Redirect stderr to devnull during transcription
    old_stderr = sys.stderr
    try:
        sys.stderr = open(os.devnull, 'w')
        result = mlx_whisper.transcribe(
            str(audio_file),
            path_or_hf_repo="mlx-community/whisper-small-mlx",
            language="en",
            fp16=True,
            verbose=False
        )
    finally:
        sys.stderr.close()
        sys.stderr = old_stderr

    text = result["text"].strip()

    if not text:
        raise ValueError("Transcription produced empty text")

    return text

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: vn-transcribe.py <audio_file>", file=sys.stderr)
        sys.exit(1)

    try:
        text = transcribe(sys.argv[1])
        print(text)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)
