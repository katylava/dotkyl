#!/usr/bin/env python
"""Extract a full conversation log from a Claude Code session jsonl file.

Usage:
    extract-claude-session-text.py <path> [--date YYYY-MM-DD] [--tz ZONE]
                                          [--max-result-chars N]

Preserves the full agent trace: user/assistant text, thinking blocks, tool
calls (name + full input), and tool results. Tool results are truncated to
--max-result-chars (default 2000; pass 0 for no limit); tool-call inputs are
never truncated. Results that errored are flagged.

Timestamps in the jsonl are UTC; they are converted to --tz (default
America/Chicago) for display, the --date filter, and the duration header.
When --date is given, only messages from that local date are included (for
carryover sessions that span multiple days).
"""
import argparse
import json
from datetime import datetime
from zoneinfo import ZoneInfo

DEFAULT_MAX_RESULT_CHARS = 2000


def to_local(timestamp, tz):
    """Parse an ISO-8601 UTC timestamp and convert to tz.

    Returns a timezone-aware datetime, or None if unparseable/empty.
    """
    if not timestamp:
        return None
    try:
        dt = datetime.fromisoformat(timestamp)
    except ValueError:
        return None
    return dt.astimezone(tz)


def fmt_duration(start, end):
    """Format the span between two datetimes as e.g. '2h 35m' or '47m'."""
    total_min = int((end - start).total_seconds() // 60)
    hours, minutes = divmod(total_min, 60)
    if hours:
        return f"{hours}h {minutes}m"
    return f"{minutes}m"


def indent(text, prefix="    "):
    """Indent every line of text with prefix."""
    return "\n".join(prefix + line for line in text.splitlines())


def truncate(text, limit):
    """Truncate text to limit chars, appending a marker noting how much was cut."""
    if limit is None or len(text) <= limit:
        return text
    cut = len(text) - limit
    return text[:limit] + f"\n... [truncated {cut} chars]"


def result_to_text(content):
    """Flatten tool_result content (str or list of blocks) to plain text."""
    if isinstance(content, str):
        return content
    if isinstance(content, list):
        parts = []
        for block in content:
            if not isinstance(block, dict):
                continue
            btype = block.get("type")
            if btype == "text":
                parts.append(block.get("text", ""))
            elif btype == "image":
                parts.append("[image]")
            else:
                parts.append(f"[{btype}]")
        return "\n".join(parts)
    if content is None:
        return ""
    return str(content)


def render_tool_use(block):
    """Render a tool_use block: name plus each input field (inputs not truncated)."""
    name = block.get("name", "?")
    lines = [f"→ tool_use: {name}"]
    inp = block.get("input") or {}
    if isinstance(inp, dict):
        for key, value in inp.items():
            if isinstance(value, str):
                val_str = value
            else:
                val_str = json.dumps(value, ensure_ascii=False)
            if "\n" in val_str:
                lines.append(f"  {key}:")
                lines.append(indent(val_str, "    "))
            else:
                lines.append(f"  {key}: {val_str}")
    else:
        lines.append(indent(json.dumps(inp, ensure_ascii=False), "  "))
    return "\n".join(lines)


def render_tool_result(block, tool_names, max_result_chars):
    """Render a tool_result block: matched tool name, error flag, truncated content."""
    tuid = block.get("tool_use_id", "")
    name = tool_names.get(tuid, "?")
    flag = " (ERROR)" if block.get("is_error") else ""
    text = result_to_text(block.get("content"))
    text = truncate(text, max_result_chars)
    header = f"← tool_result: {name}{flag}"
    if text.strip():
        return header + "\n" + indent(text)
    return header + "\n    [no content]"


def render_blocks(content, tool_names, max_result_chars):
    """Render a message's content blocks in order.

    Returns a list of rendered block strings. A plain-string content is
    treated as a single text block. tool_names is updated in place as
    tool_use blocks are encountered so tool_results can be labeled.
    """
    if isinstance(content, str):
        text = content.strip()
        return [text] if text else []

    if not isinstance(content, list):
        return []

    rendered = []
    for block in content:
        if not isinstance(block, dict):
            continue
        btype = block.get("type")
        if btype == "text":
            text = block.get("text", "").strip()
            if text:
                rendered.append(text)
        elif btype == "thinking":
            text = block.get("thinking", "").strip()
            if text:
                rendered.append("[thinking]\n" + indent(text))
            else:
                # Encrypted/redacted thinking carries a signature but no plaintext.
                # Still worth showing that the model was thinking here.
                rendered.append("[thinking] (encrypted, no text)")
        elif btype == "tool_use":
            tool_names[block.get("id", "")] = block.get("name", "?")
            rendered.append(render_tool_use(block))
        elif btype == "tool_result":
            rendered.append(render_tool_result(block, tool_names, max_result_chars))
    return rendered


def main():
    parser = argparse.ArgumentParser(description="Extract full session trace for evaluation")
    parser.add_argument("path", help="Path to session .jsonl file")
    parser.add_argument("--date", help="Only include messages from this local date (YYYY-MM-DD)")
    parser.add_argument("--tz", default="America/Chicago", help="Timezone for display (default: America/Chicago)")
    parser.add_argument("--max-result-chars", type=int, default=DEFAULT_MAX_RESULT_CHARS,
                        help=f"Truncate tool_result content to this many chars (default: {DEFAULT_MAX_RESULT_CHARS}; 0 = no limit)")
    args = parser.parse_args()

    tz = ZoneInfo(args.tz)
    max_result_chars = None if args.max_result_chars == 0 else args.max_result_chars

    # Map tool_use id -> tool name, so tool_results can be labeled. Spans the
    # whole file (results may arrive in a later message than the call).
    tool_names = {}

    entries = []  # (local_dt, time_short, role, [rendered blocks])
    for line in open(args.path):
        line = line.strip()
        if not line:
            continue
        try:
            msg = json.loads(line)
        except json.JSONDecodeError:
            continue

        msg_type = msg.get("type")
        if msg_type not in ("user", "assistant"):
            continue

        local_dt = to_local(msg.get("timestamp", ""), tz)

        # Date filter for carryover sessions (compare against the local date)
        if args.date and (local_dt is None or local_dt.strftime("%Y-%m-%d") != args.date):
            continue

        # Skip CLI meta-messages (slash commands, local command output, etc.)
        if msg.get("isMeta"):
            continue

        content = msg.get("message", {}).get("content", "")
        blocks = render_blocks(content, tool_names, max_result_chars)

        # Skip system/command XML wrapper messages with no real content
        blocks = [b for b in blocks
                  if not (b.startswith("<local-command-") or b.startswith("<command-name>"))]
        if not blocks:
            continue

        time_short = local_dt.strftime("%H:%M") if local_dt else ""
        entries.append((local_dt, time_short, msg_type, blocks))

    # Header
    print(f"# Messages: {len(entries)}")
    if args.date:
        print(f"# Date filter: {args.date}")
    if max_result_chars is not None:
        print(f"# Tool results truncated to {max_result_chars} chars")
    stamped = [e[0] for e in entries if e[0] is not None]
    if stamped:
        start, end = stamped[0], stamped[-1]
        print(f"# Span ({args.tz}): {start.strftime('%Y-%m-%d %H:%M')} - {end.strftime('%H:%M')}")
        print(f"# Duration: {fmt_duration(start, end)}")
    print()

    for _, time_short, role, blocks in entries:
        print(f"[{time_short}] {role}:")
        for block in blocks:
            print(indent(block, "  "))
            print()


if __name__ == "__main__":
    main()
