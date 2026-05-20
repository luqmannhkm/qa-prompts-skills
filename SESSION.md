# QA Prompts Skills — Session Context

> Load this file at the start of a new session to restore full context.
> Trigger phrase: **"qa-prompt-skills"** or **"restore session"**

---

## Project Goal
Build and maintain a reusable QA skills repository for AI agents covering TestRail, Lark, and test case generation workflows.

## Repo
- **GitHub:** `https://github.com/luqmannhkm/qa-prompts-skills`
- **Local:** `/Users/luqmanul.hakim/Documents/GitHub/qa-prompts-skills`
- **CLI script:** `/Users/luqmanul.hakim/testrail-cli/testrail.sh` (also at `scripts/testrail.sh` in repo)

---

## Constraints & Preferences
- Output format: Lark Doc (`lark_docx_builtin_import`) or Lark Bitable — **not** Lark Sheets (no write-values MCP tool)
- TestRail instance: `https://traveloka.testrail.net`
- All test cases in English
- Standard columns: `Test Case Id, Title, Section, Automation Type, Estimate, Priority, Preconditions, Steps (Text), Expected Result, Type`
- Defaults: Automation Type = Manual, Estimate = 5 min, Test Case Id = TC-001 format

---

## Key Technical Findings

### Lark MCP
- `lark_docx_builtin_import` may return `Streamable HTTP error` even on success — treat as false negative, check Lark directly before retrying
- Available Sheets tools: query, find, replace, moveDimension, create — **no write-values tool**
- `lark_bitable_v1_appTableRecord_batchCreate` supports full row writes (up to 500 per call)
- Lark wiki read flow: URL token → `lark_wiki_v2_space_getNode` → `obj_token` → `lark_docx_v1_document_rawContent`

### TestRail CLI (`testrail.sh`)
- `getSections` and `getCases` auto-paginate (250 items/page, uses `_links.next`)
- **zsh bug fixed:** `local` declarations must be outside `while` loops — declaring inside causes zsh to print variable values to stdout, corrupting JSON output
- **zsh loop bug:** `for x in $VAR` does not split on newlines in zsh — use `while IFS= read -r x; do ... done <<< "$VAR"` instead
- **Control characters:** never store large API JSON in a bash variable — pipe to temp file instead, then run jq on the file
- `project_id` is not in TestRail URL — discover via `getSuites`

---

## Completed Work

### Skills repo (committed)
| Commit | Description |
|--------|-------------|
| `64b3916` | Support multiple TestRail reference links (`{$testrailLinks}`) in generate-testcases skill |
| `5d77f33` | Add `scripts/testrail.sh` with auto-pagination fix (zsh-compatible) |
| `9bd5872` | Update skill docs: Lark export approach (lark_docx + bitable) and pagination notes |

### Skills files updated
- `skills/generate-testcases.md` — Step 4 uses `lark_docx_builtin_import` (Option A) and `lark_bitable_v1_appTableRecord_batchCreate` (Option B); Lark Sheets removed
- `skills/testrail-cli.md` — pagination notes, zsh warning, troubleshooting rows, repo URL updated to `scripts/`
- `scripts/testrail.sh` — auto-pagination, zsh-compatible `local` placement

### Trial demo executed
- PRD: `https://traveloka.sg.larksuite.com/wiki/Wh9EwCAD2iobryk76wYlZcj7gQf` (doc token `ODZmdkXSIontCDxaVxxlil9jg4d`)
- 85 test cases generated, exported to Lark Doc: `https://traveloka.sg.larksuite.com/docx/LsO9doy3Ao6rdHxrUeflaglogkb`
- Redundant split docs (ignore): `M4R5dIXt5o4Qy1xgpirliQftgNd`, `IAKFdgRfxo6sRbxLRWglUV4Tgsh`, `YoVkd3gJ3ooABqxiTTFlLlo9gAd`, `RB8dddHAfoTbihxtvVBlb0n4gcb`

---

## Active TestRail Context

### Suite 7 — Project 7
- Total sections: **287** (2 pages × 250 limit)

### Section 512560 — "Pax Selection Blossom" (depth 0, parent: none)
URL: `https://traveloka.testrail.net/index.php?/suites/view/7&group_by=cases:section_id&group_order=asc&display=subtree&display_deleted_cases=0&group_id=512560`

**Subsections (22 direct children, all depth 1):**

| ID | Name | Cases |
|----|------|-------|
| 512561 | Header | 4 |
| 512562 | Product info card | 0 |
| 512568 | Important Information Pill | 9 |
| 512576 | Bundle Product card | 1 |
| 512577 | Bundle Product name | 5 |
| 512578 | Bundle Item Name | 6 |
| 512579 | Bundle Item Card | 11 |
| 512580 | Bundle Date selector | 12 |
| 512581 | Bundle Timeslot Selector | 6 |
| 512582 | Validity Info | 8 |
| 512583 | Price Group Option | 4 |
| 512589 | Preventive | 0 |
| 512592 | Bundle Price group option | 16 |
| 512593 | Bundle Price group description tray | 3 |
| 512594 | Reactive snack bar | 6 |
| 512595 | Blue info box component | 0 |
| 512600 | Footer | 2 |
| 512601 | Price breakdown | 8 |
| 512602 | Entry Point | 12 |
| 512603 | Ticket list to Pax selection | 6 |
| 512604 | Tweety Ticket list to Pax selection | 6 |
| 512605 | Booking form to pax selection | 3 |

**Total cases fetched: 128**

Sections with 0 cases (no test cases yet): 512562, 512589, 512595

---

## Previous TestRail References
- Suite 2751, section 86997 (Ticket List Web): 30+ cases — used as reference in trial demo
- Suite 7, section 512560: 128 cases (fetched and confirmed above)

---

## Relevant Files
| File | Purpose |
|------|---------|
| `skills/generate-testcases.md` | Primary skill: test case generation + Lark export |
| `skills/testrail-cli.md` | TestRail CLI skill: setup, usage, pagination, troubleshooting |
| `skills/testrail-read-data.md` | TestRail read data skill |
| `skills/lark-read-data.md` | Lark read data skill |
| `examples/testcase-templates.md` | Test case template examples |
| `scripts/testrail.sh` | CLI script: `.env` loader + auto-pagination (zsh-safe) |

---

## Lark Auth
Remote OAuth via MCP — no curl direct access. Use Lark MCP tools only.

## Blocked Items
- `.env` auto-loader warning: resolves to `~/.env` instead of `~/testrail-cli/.env` when sourced in zsh — cosmetic only, credentials still work if exported in shell environment
- Target Lark Spreadsheet `J5CwsVpOchTVY7tR7nVloNPDgyc` (sheet `9b2f18`): no write-values tool available, use Lark Doc instead
