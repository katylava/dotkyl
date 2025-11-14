#!/usr/bin/env python
"""
Read-only command-line tool for querying Roam Research data.

Requires env variables:
- ROAM_API_TOKEN
- ROAM_GRAPH_NAME

These can be set from 1password in a roam.env file like this:
ROAM_API_TOKEN="op://Personal/Roamresearch.com API/credential"
ROAM_GRAPH_NAME="op://Personal/Roamresearch.com API/graph"
"""

import sys
import json
import os
import requests
from datetime import datetime, timedelta
from typing import List, Optional, Dict, Any

USAGE = """
Usage: op run --account=my --env-file=roam.env -- query_roam.py <command> [args...]

Commands:
  search-blocks <term>...         - Search blocks that contain all terms
                                    (intersection within same block)

  search-pages <term>...          - Search pages that contain all terms
                                    (intersection across all blocks on page)

  search-tags <tag>               - Get pages tagged with a specific tag

  daily-notes <number> <unit>     - Get daily notes for time period
                                    (units: days, weeks)

  daily-notes since <YYYY-MM-DD>  - Get daily notes since specific date

  page-content <title>            - Get full content of a specific page

  query <datalog>                 - Execute raw Datalog queries

**LLM guidance**
If you encounter issues, you can run curl commands instead of using this script:
`op run --account=my --env-file=roam.env -- bash -c 'curl...'`
"""

# Get credentials from environment
TOKEN = os.environ.get('ROAM_API_TOKEN')
GRAPH = os.environ.get('ROAM_GRAPH_NAME')


def make_request(path: str, body: Dict[str, Any]) -> Dict[str, Any]:
    """Make a request to the Roam API"""
    url = f"https://api.roamresearch.com/api/graph/{GRAPH}{path}"
    headers = {
        "accept": "application/json",
        "X-Authorization": f"Bearer {TOKEN}",
        "Content-Type": "application/json"
    }
    response = requests.post(url, headers=headers, json=body, allow_redirects=True)
    response.raise_for_status()
    return response.json()

def query(query_string: str, args: Optional[List[str]] = None) -> List[List[Any]]:
    """Execute a Datalog query"""
    body = {"query": query_string}
    if args:
        body["args"] = args
    result = make_request("/q", body)
    return result["result"]

def pull_page(eid: str, selector: str) -> Dict[str, Any]:
    """Pull structured data for a specific page/entity"""
    body = {"eid": eid, "selector": selector}
    result = make_request("/pull", body)
    return result["result"]

def calculate_start_timestamp(number: int, unit: str) -> int:
    """Calculate start timestamp from relative specification (number + unit)"""
    unit = unit.lower()
    end_date = datetime.now()

    if unit in ['day', 'days']:
        start_date = end_date - timedelta(days=number)
    elif unit in ['week', 'weeks']:
        start_date = end_date - timedelta(weeks=number)
    else:
        raise ValueError(f"Unknown unit: {unit}. Use 'days' or 'weeks'")

    # Return midnight of the start date in local timezone
    return int(datetime.combine(start_date.date(), datetime.min.time()).timestamp() * 1000)

def cmd_search_blocks(terms: List[str]) -> None:
    """Search blocks that contain all terms (intersection within same block)"""
    if not terms:
        print(json.dumps([]))
        return

    # Get all blocks that contain the first term
    query_str = '[:find ?uid ?string :in $ ?search-term :where [?e :block/uid ?uid] [?e :block/string ?string] [(clojure.string/includes? ?string ?search-term)]]'
    results = query(query_str, [terms[0]])

    # Filter results to only include blocks that contain ALL terms
    matching_blocks = []
    for result in results:
        uid, content = result
        content_lower = content.lower()

        # Check if this block contains ALL terms
        if all(term.lower() in content_lower for term in terms):
            matching_blocks.append({
                'terms': terms,
                'uid': uid,
                'content': content,
                'page_title': 'Unknown'  # We'll need to get this separately if needed
            })

    print(json.dumps(matching_blocks, indent=2))

def cmd_search_pages(terms: List[str]) -> None:
    """Search pages that contain all terms (intersection across all blocks on page)"""
    if not terms:
        print(json.dumps([]))
        return

    # Get all unique pages that contain the first term
    query_str = '[:find ?title :in $ ?search-term :where [?e :block/uid ?uid] [?e :block/string ?string] [(clojure.string/includes? ?string ?search-term)] [?e :block/page ?page] [?page :node/title ?title]]'
    results = query(query_str, [terms[0]])

    # Get unique page titles
    pages_with_first_term = set([result[0] for result in results])

    # For each page, check if it contains ALL terms
    matching_pages = []
    for page_title in pages_with_first_term:
        # Get all blocks for this page using the correct relationship
        page_query = '[:find ?uid ?string :where [?page :node/title "{}"] [?e :block/page ?page] [?e :block/uid ?uid] [?e :block/string ?string]]'.format(page_title)
        page_blocks = query(page_query)

        # Check if this page contains ALL terms
        all_content = ' '.join([block[1] for block in page_blocks]).lower()
        if all(term.lower() in all_content for term in terms):
            matching_pages.append({
                'terms': terms,
                'page_title': page_title,
                'block_count': len(page_blocks)
            })

    print(json.dumps(matching_pages, indent=2))

def cmd_search_tags(tag: str) -> None:
    """Get pages tagged with a specific tag"""
    # First, get the tag page's UID
    tag_query = '[:find ?uid :where [?e :node/title "{}"] [?e :block/uid ?uid]]'.format(tag)
    tag_results = query(tag_query)

    if not tag_results:
        print(json.dumps([]))
        return

    tag_uid = tag_results[0][0]

    # Get all pages that link to this tag (backlinks)
    backlinks_query = '[:find ?title ?uid :where [?e :node/title ?title] [?e :block/uid ?uid] [?e :block/refs ?tag-uid] [(= ?tag-uid "{}")]]'.format(tag_uid)
    backlink_results = query(backlinks_query)

    results = []
    for result in backlink_results:
        results.append({
            'page_title': result[0],
            'page_uid': result[1],
            'tag': tag
        })

    print(json.dumps(results, indent=2))

def cmd_daily_notes(start_timestamp: int) -> None:
    """Get blocks modified in time period"""

    # Query for blocks modified since the start timestamp
    query_str = r'''[:find ?uid ?string ?edit-time :where
        [?e :block/uid ?uid]
        [?e :block/string ?string]
        [?e :edit/time ?edit-time]
        [(>= ?edit-time {})]
    ] :order-by [[?edit-time :desc]]'''.format(start_timestamp)

    results = query(query_str)

    # Convert results to the expected format
    filtered_results = []
    for result in results:
        uid = result[0]
        content = result[1]
        edit_time = result[2]

        # Parse the edit time (it's in milliseconds since epoch)
        try:
            edit_datetime = datetime.fromtimestamp(edit_time / 1000)

            filtered_results.append({
                'uid': uid,
                'content': content,
                'edit_time': edit_datetime.strftime("%Y-%m-%d %H:%M:%S")
            })
        except (ValueError, TypeError):
            # Skip if we can't parse the time
            continue

    print(json.dumps(filtered_results, indent=2))

def cmd_page_content(title: str) -> None:
    """Get full content of a specific page"""
    # First, get the page's UID
    page_query = '[:find ?uid :where [?e :node/title "{}"] [?e :block/uid ?uid]]'.format(title)
    page_results = query(page_query)

    if not page_results:
        print(json.dumps([]))
        return

    page_uid = page_results[0][0]

    # Get all blocks for this page
    blocks_query = '[:find ?uid ?string ?order :where [?e :node/title "{}"] [?e :block/uid ?uid] [?e :block/string ?string] [?e :block/order ?order]] :order-by [[?order :asc]]'.format(title)
    blocks_results = query(blocks_query)

    # Also get any child blocks
    children_query = '[:find ?uid ?string ?order :where [?e :node/title "{}"] [?e :block/children ?child-uid] [?child-uid :block/uid ?uid] [?child-uid :block/string ?string] [?child-uid :block/order ?order]] :order-by [[?order :asc]]'.format(title)
    children_results = query(children_query)

    # Combine and sort all blocks
    all_blocks = blocks_results + children_results
    all_blocks.sort(key=lambda x: x[2])  # Sort by order

    results = {
        'page_title': title,
        'page_uid': page_uid,
        'blocks': []
    }

    for block in all_blocks:
        results['blocks'].append({
            'uid': block[0],
            'content': block[1],
            'order': block[2]
        })

    print(json.dumps(results, indent=2))

def cmd_query(query_string: str, args: Optional[List[str]]) -> None:
    """Execute raw Datalog queries"""
    result = query(query_string, args)
    print(json.dumps(result, indent=2))

def main() -> None:
    if len(sys.argv) < 2:
        print(USAGE)
        sys.exit(1)

    if not TOKEN or not GRAPH:
        print(USAGE)
        sys.exit(1)

    command = sys.argv[1]

    try:
        if command == "search-blocks":
            if len(sys.argv) < 3:
                print("Error: search-blocks requires at least one search term")
                sys.exit(1)
            cmd_search_blocks(sys.argv[2:])

        elif command == "search-pages":
            if len(sys.argv) < 3:
                print("Error: search-pages requires at least one search term")
                sys.exit(1)
            cmd_search_pages(sys.argv[2:])

        elif command == "search-tags":
            if len(sys.argv) < 3:
                print("Error: search-tags requires a tag name")
                sys.exit(1)
            cmd_search_tags(sys.argv[2])

        elif command == "daily-notes":
            if len(sys.argv) < 3:
                print("Error: daily-notes requires a date specification")
                sys.exit(1)

            date_spec = sys.argv[2:]
            try:
                if len(date_spec) == 2:
                    if date_spec[0] == "since":
                        # Specific date: since YYYY-MM-DD
                        date_str = date_spec[1]
                        start_date = datetime.strptime(date_str, "%Y-%m-%d").date()
                        start_timestamp = int(datetime.combine(start_date, datetime.min.time()).timestamp() * 1000)
                    else:
                        # Relative date: number + unit
                        number = int(date_spec[0])
                        unit = date_spec[1]
                        start_timestamp = calculate_start_timestamp(number, unit)
                else:
                    raise ValueError("Date specification must be: <number> <unit> or since YYYY-MM-DD")
            except ValueError as e:
                print(f"Error: {e}")
                sys.exit(1)

            cmd_daily_notes(start_timestamp)

        elif command == "page-content":
            if len(sys.argv) < 3:
                print("Error: page-content requires a page title")
                sys.exit(1)
            cmd_page_content(sys.argv[2])

        elif command == "query":
            if len(sys.argv) < 3:
                print("Error: query command requires a query string")
                sys.exit(1)
            query_string = sys.argv[2]
            args = sys.argv[3:] if len(sys.argv) > 3 else None
            cmd_query(query_string, args)

        else:
            print(f"Unknown command: {command}")
            sys.exit(1)

    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
