---
name: sort-inbox
description: >
  Sort files from a Google Drive inbox folder into organized destinations based on a rules file.
  Use this skill whenever the user asks to sort, organize, or file away items in their inbox,
  mentions "-Inbox", says "sort my inbox", "file these", "organize my downloads",
  or references their Google Drive Reorg Rules. Also trigger when the user drops files into
  their inbox and asks Claude to handle them, even if they don't use the word "sort" explicitly.
allowed-tools: Edit(-Inbox/sort-log.csv)
---

# Google Drive Inbox Sorter

Sort files from `-Inbox/` into the correct Google Drive folders based on the user's rules file.

## Overview

The user maintains a `-Inbox/` folder in Google Drive as a drop zone. Files land there (usually downloaded from Gmail) and periodically need to be sorted into the correct permanent locations. The rules for where things go live in a file called `Google Drive Reorg Rules.md` at the root of the Drive.

This is a workflow that requires careful reading of each file before deciding where it goes — filenames are often misleading (e.g., a file called "Invoice" might be a vet record, or a generic "Document.pdf" might be a tax transcript). The skill encodes the sorting workflow and the lessons learned from doing it repeatedly.

## Workflow

### Step 1: Read the rules

Read `Google Drive Reorg Rules.md` from the root of the mounted Google Drive. This file contains the canonical sorting rules — folder destinations, naming conventions, and special cases. The rules may evolve over time, so always read the current version rather than relying on cached knowledge.

The Drive is typically mounted at a path like `/sessions/*/mnt/My Drive/`. Find it by checking the workspace.

### Step 2: Inventory the inbox

List everything in `-Inbox/`. Note: because the folder name starts with a dash, standard commands need special handling:

```bash
ls -- "-Inbox/"        # use -- to signal end of options
ls "./-Inbox/"         # or prefix with ./
```

Get a count of files so you can track progress and report it to the user.

Also scan the existing folder structure (especially `Household/2030Shenandoah/Repairs/`, `Household/Pets/`, and `Finances/Taxes/`) to understand what's already filed. This helps with duplicate detection and ensures you use existing incident folders rather than creating redundant ones.

### Step 3: Read every file before sorting

This is the most important rule. Never sort by filename alone. For each file:

- **PDFs**: Extract text using `pypdf`. If text extraction yields nothing (scanned document), visually inspect the PDF by reading it as an image.
- **Images** (JPG, PNG, HEIC): View them to understand what they depict. HEIC files may need conversion (`magick` or `convert` from ImageMagick) before viewing.
- **ZIPs**: List contents, extract if needed to understand what's inside.
- **Other formats**: Use appropriate tools to read the content.

Process files in batches to be efficient, but make sure you actually understand each file's content before deciding where it goes.

### Step 4: Categorize and identify ambiguities

Group files by destination category. As you go, keep track of:

- **Clear sorts**: Files where the destination is obvious from content.
- **Ambiguous files**: Files where you're not sure of the destination, or that could belong in multiple places. Collect these to ask the user about in a batch.
- **Potential duplicates**: Files that may already exist in the destination. Check by comparing file sizes (byte-exact comparison) with existing files in the target folder.
- **Trash candidates**: Files that appear irrelevant, belong to someone else, are blank templates, or are outdated/superseded. Flag these for the user.

Present ambiguous files and trash candidates to the user in one batch rather than interrupting with individual questions. Group related questions together (e.g., "These 3 files all seem related to drainage work — should they go in Repairs or Home Improvements?").

### Step 5: Sort the files

Once you have answers to your questions, sort everything. For each file:

1. **Rename** according to the naming convention: `YYYY-MM-DD description.pdf` (lowercase, dashes, ISO date). Derive the date from the document content, not the filename or file modification date.

2. **Move** (not copy) directly to the correct destination folder with the new name in a single `mv` command. Do not copy-then-trash — just move. Before creating a new folder, check if an existing folder already covers the same incident. For example, if there's already a `Repairs/2026-01 pipe-leak/` folder and you're sorting a claim payment for a pipe leak, use the existing folder rather than creating `Repairs/2026-02 water-damage/`. The date in the folder name is when the incident happened, not when each document was created.

3. **Special cases**:
   - Multi-pet vet records: Copy (not move) to each relevant pet's folder under `Household/Pets/{PetName}/`. This is the one case where copying is correct, because the file needs to exist in multiple places. The pet's name should NOT appear in the filename.
   - Claim-related insurance documents (payouts, adjuster reports, etc.): File with the incident in `Repairs/`, not in `Insurance/`.
   - Community/feral cat records: These go in a separate location from regular pet records (check the existing folder structure).

4. **Duplicates**: If a file is already filed (same content, confirmed by byte-size match), move the inbox copy to trash.

5. **Trash**: Only for duplicates and files the user confirms should be trashed. Move them to `-Inbox/trash/` rather than deleting them, because the mounted filesystem may not permit deletion. This lets the user review and permanently delete later. Do NOT move successfully sorted files to trash — they should already be gone from the inbox after the `mv`.

### Step 6: Log actions

Log every action to `-Inbox/sort-log.csv`. Append to the file if it already exists (previous sort sessions' logs should be preserved). If the file doesn't exist yet, write a header row first.

Columns: `date,original_filename,new_filename,destination,description,reason`

- `date`: ISO date of the sort session (YYYY-MM-DD)
- `original_filename`: the file's name as it appeared in `-Inbox/`
- `new_filename`: the renamed filename
- `destination`: destination folder relative to Drive root, or `TRASH` for trashed files
- `description`: brief description of the file's content
- `reason`: brief reason for the destination choice

The `original_filename`, `new_filename`, and `destination` values should have visible quotes around them — quotes that show up as actual characters when opened in a spreadsheet. This means the cell value itself contains quote characters, e.g. `"my-file.pdf"` not just `my-file.pdf`. In the raw CSV, this means double-quoting: `"""my-file.pdf"""`. Use Python's `csv` module and prepend/append literal `"` characters to these field values before writing.

For example, the raw CSV should look like:

```
date,original_filename,new_filename,destination,description,reason
2026-03-13,"""P2095BuildingatACVwithRecovDeprec (13).pdf""","""2026-02-11 travelers-initial-payment.pdf""","""Household/2030Shenandoah/Repairs/2026-01 pipe-leak/""",Travelers insurance payment of $3458.64,Claim payout for Jan 2026 pipe leak incident
```

Which displays in a spreadsheet as:

| date | original_filename | new_filename | destination | description | reason |
|---|---|---|---|---|---|
| 2026-03-13 | "P2095BuildingatACVwithRecovDeprec (13).pdf" | "2026-02-11 travelers-initial-payment.pdf" | "Household/2030Shenandoah/Repairs/2026-01 pipe-leak/" | Travelers insurance payment of $3458.64 | Claim payout for Jan 2026 pipe leak incident |

For copies (e.g., multi-pet vet records), log each copy as a separate row.

### Step 7: Report results

After sorting, give the user a summary:

- How many files were sorted and to where (grouped by destination)
- How many were trashed and why
- Any files that couldn't be processed (and why)

## Filesystem gotchas

These are practical issues that come up when working with mounted Google Drive files:

- **Offline availability**: Files may return "Resource deadlock avoided" errors if the Google Drive folder isn't marked for offline availability. If you hit this, tell the user they need to mark the folder as available offline in Google Drive settings, then try again.
- **Deletion permissions**: `os.remove()` and `rm` may fail with "Operation not permitted" on mounted Drive files. Use a trash subfolder instead.
- **Glob patterns with dash-prefix paths**: When using globs with paths containing `-Inbox`, make sure the glob is outside any quotes and the dash is handled properly (e.g., `"./-Inbox/"*` not `"./-Inbox/*"`).

## Tone and interaction style

- Be systematic but not robotic. Process files efficiently in batches.
- When asking about ambiguous files, provide enough context that the user can make a quick decision (what the file contains, when it's from, what your best guess is).
- Don't ask about things you can figure out yourself. Only ask when there's genuine ambiguity.
- If you recognize patterns across files (e.g., "these 5 files are all from the same vet visit"), group them and sort them together rather than treating each one individually.
