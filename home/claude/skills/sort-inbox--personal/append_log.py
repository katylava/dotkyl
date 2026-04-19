#!/usr/bin/env python
'''Append rows to -Inbox/sort-log.csv with the skill's quirky quoting.

The skill requires original_filename, new_filename, and destination to contain
literal quote characters (so they display with visible quotes in a spreadsheet).
The csv module will then double-quote those into triple-quoted fields in the
raw CSV output (e.g. """file.pdf""").

Usage:
    append_log.py <log_path> <json_rows>

where json_rows is a JSON array of objects with keys:
    date, original_filename, new_filename, destination, description, reason

If the log file does not exist yet, the header row is written first.

The log path is ./-Inbox/sort-log.csv relative to the Drive root.
'''
from __future__ import annotations

import csv
import json
import sys
from pathlib import Path

HEADER = ["date", "original_filename", "new_filename", "destination", "description", "reason"]
QUOTED_FIELDS = {"original_filename", "new_filename", "destination"}


def main() -> int:
    if len(sys.argv) != 3:
        print(__doc__, file=sys.stderr)
        return 2
    log_path = Path(sys.argv[1])
    # Guard: if the log path is relative, make sure cwd is the Drive root
    # (marker file present). This catches accidental cwd drift into -Inbox/.
    if not log_path.is_absolute() and not Path("Google Drive Reorg Rules.md").is_file():
        print(
            "ERROR: cwd is not the Drive root (marker 'Google Drive Reorg "
            "Rules.md' not found). Run from the Drive root, or pass an "
            "absolute log path.",
            file=sys.stderr,
        )
        return 1
    rows = json.loads(sys.argv[2])
    if not isinstance(rows, list) or not all(isinstance(r, dict) for r in rows):
        print("ERROR: second arg must be a JSON array of objects", file=sys.stderr)
        return 2

    write_header = not log_path.exists()
    with log_path.open("a", newline="") as f:
        w = csv.writer(f)
        if write_header:
            w.writerow(HEADER)
        for r in rows:
            out = []
            for col in HEADER:
                v = r.get(col, "")
                if col in QUOTED_FIELDS:
                    v = f'"{v}"'
                out.append(v)
            w.writerow(out)
    print(f"Appended {len(rows)} row(s) to {log_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
