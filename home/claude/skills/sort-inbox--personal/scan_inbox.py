#!/usr/bin/env python
"""Scan -Inbox/ and print contents of each file so Claude can categorize them.

Usage:
    scan_inbox.py [inbox_path]

Defaults to ./-Inbox/. Skips sort-log.csv and the trash/ subfolder.

For each file, prints a header line, then:
- PDFs: extracted text (via pypdf). If extraction is empty, flags as NEEDS_IMAGE_VIEW.
- Archives (.tgz, .tar.gz, .zip): lists contents.
- Images (.jpg, .jpeg, .png, .heic, .gif): flags as NEEDS_IMAGE_VIEW.
- Text-like (.txt, .md, .csv, .json, .html): prints content.
- Other: prints size and type; flags as UNKNOWN.

Truncates each file's output to ~6000 chars so the report stays manageable.
"""
from __future__ import annotations

import os
import sys
import tarfile
import zipfile
from pathlib import Path

MAX_TEXT = 6000
SKIP_NAMES = {"sort-log.csv"}
SKIP_DIRS = {"trash"}

TEXT_EXTS = {".txt", ".md", ".csv", ".json", ".html", ".htm", ".xml", ".yaml", ".yml"}
IMAGE_EXTS = {".jpg", ".jpeg", ".png", ".heic", ".gif", ".webp", ".tiff", ".bmp"}
ARCHIVE_EXTS = {".zip", ".tgz", ".tar", ".gz"}


def banner(path: Path, size: int) -> None:
    print(f"\n===== {path.name}  ({size:,} bytes) =====")


def truncate(s: str) -> str:
    if len(s) <= MAX_TEXT:
        return s
    return s[:MAX_TEXT] + f"\n... [truncated, total {len(s)} chars]"


def scan_pdf(path: Path) -> None:
    try:
        from pypdf import PdfReader
    except ImportError:
        print("PYPDF_NOT_INSTALLED — run: pip install pypdf")
        return
    try:
        reader = PdfReader(str(path))
    except Exception as e:
        print(f"PDF_READ_ERROR: {e}")
        return
    print(f"pages: {len(reader.pages)}")
    all_text = []
    for i, page in enumerate(reader.pages):
        try:
            t = page.extract_text() or ""
        except Exception as e:
            t = f"[extract error: {e}]"
        all_text.append(f"--- page {i+1} ---\n{t}")
    combined = "\n".join(all_text).strip()
    if not combined or not any(c.isalnum() for c in combined):
        print("NEEDS_IMAGE_VIEW — no extractable text (scanned/image-only PDF)")
        return
    print(truncate(combined))


def scan_archive(path: Path) -> None:
    name = path.name.lower()
    try:
        if name.endswith(".zip"):
            with zipfile.ZipFile(path) as z:
                names = z.namelist()
        elif name.endswith((".tgz", ".tar.gz", ".tar")):
            with tarfile.open(path) as t:
                names = t.getnames()
        else:
            print(f"UNKNOWN_ARCHIVE_TYPE: {name}")
            return
    except Exception as e:
        print(f"ARCHIVE_READ_ERROR: {e}")
        return
    print(f"entries: {len(names)}")
    for n in names[:100]:
        print(f"  {n}")
    if len(names) > 100:
        print(f"  ... {len(names) - 100} more")


def scan_text(path: Path) -> None:
    try:
        content = path.read_text(errors="replace")
    except Exception as e:
        print(f"TEXT_READ_ERROR: {e}")
        return
    print(truncate(content))


def scan_file(path: Path) -> None:
    size = path.stat().st_size
    banner(path, size)
    ext = path.suffix.lower()
    # Handle double extensions like .tar.gz
    if path.name.lower().endswith(".tar.gz"):
        scan_archive(path)
        return
    if ext == ".pdf":
        scan_pdf(path)
    elif ext in ARCHIVE_EXTS:
        scan_archive(path)
    elif ext in IMAGE_EXTS:
        print(f"NEEDS_IMAGE_VIEW — {ext} image")
    elif ext in TEXT_EXTS:
        scan_text(path)
    else:
        print(f"UNKNOWN_TYPE — ext={ext!r} size={size}")


def main() -> int:
    if len(sys.argv) > 1:
        inbox = Path(sys.argv[1])
    else:
        if not Path("Google Drive Reorg Rules.md").is_file():
            print(
                "ERROR: cwd is not the Drive root (marker 'Google Drive Reorg "
                "Rules.md' not found). Run from the Drive root, or pass an "
                "explicit inbox path as an argument.",
                file=sys.stderr,
            )
            return 1
        inbox = Path("-Inbox")
    if not inbox.is_dir():
        print(f"ERROR: {inbox} is not a directory", file=sys.stderr)
        return 1

    entries = sorted(
        p for p in inbox.iterdir()
        if p.is_file() and p.name not in SKIP_NAMES and not p.name.startswith(".")
    )
    print(f"# Inbox scan: {inbox}")
    print(f"# {len(entries)} file(s) to sort")
    for p in entries:
        scan_file(p)
    # Also list any subfolders (other than trash/) for visibility.
    subdirs = [p for p in inbox.iterdir() if p.is_dir() and p.name not in SKIP_DIRS]
    if subdirs:
        print("\n# Subfolders (not scanned):")
        for d in subdirs:
            print(f"  {d.name}/")
    return 0


if __name__ == "__main__":
    sys.exit(main())
