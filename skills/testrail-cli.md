# Skill: TestRail CLI Tool

## Description
Use the `testrail.sh` script (from testrail-cli repo) to interact with TestRail API from command line or AI agent.

## Repository
URL: https://github.com/luqmannhkm/testrail-cli

## Quick Setup

### 1. Clone the repo
```bash
git clone https://github.com/luqmannhkm/testrail-cli.git
cd testrail-cli
```

### 2. Configure credentials via `.env`

The script automatically loads a `.env` file from the same directory as `testrail.sh`. You do **not** need to export variables manually.

#### Option A: Copy from the example template
```bash
cp ~/testrail-cli/.env.example ~/testrail-cli/.env
```

Then open and fill in your credentials:
```bash
nano ~/testrail-cli/.env
```

#### Option B: Create `.env` directly
```bash
cat > ~/testrail-cli/.env << EOF
TESTRAIL_URL=https://your-company.testrail.net
TESTRAIL_USERNAME=your_email@company.com
TESTRAIL_API_KEY=your_api_key_here
EOF
```

#### `.env` file format
```env
TESTRAIL_URL=https://traveloka.testrail.net
TESTRAIL_USERNAME=your_email@traveloka.com
TESTRAIL_API_KEY=your_api_key_here
```

> **How to get your API key:**
> 1. Log in to your TestRail instance
> 2. Go to **My Settings** (top-right avatar menu)
> 3. Click the **API Keys** tab
> 4. Click **Add Key** → copy the generated key

### 3. Load the script
```bash
source ~/testrail-cli/testrail.sh
```

When loaded successfully, you will see:
```
Loaded credentials from /Users/your-name/testrail-cli/.env
TestRail CLI helper loaded. Available commands:
  getSuites <project_id>
  getSections <project_id> <suite_id>
  ...
```

If `.env` is missing, you will see a warning:
```
Warning: No .env file found at /Users/your-name/testrail-cli/.env
Create one with: TESTRAIL_URL, TESTRAIL_USERNAME, TESTRAIL_API_KEY
```

### How `.env` Auto-Loading Works

The `testrail.sh` script detects its own directory using `BASH_SOURCE[0]` and automatically sources the `.env` file at startup:

```bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [ -f "$ENV_FILE" ]; then
  set -a        # auto-export all variables
  source "$ENV_FILE"
  set +a
fi
```

This means:
- `.env` must be in the **same folder** as `testrail.sh` (i.e. `~/testrail-cli/`)
- Variables in `.env` take priority; script falls back to hardcoded defaults if not set
- You never need to manually `export` credentials before sourcing the script

---

## Available Commands

### `getSuites <project_id>`
Get all test suites for a project.
```bash
getSuites 7
```

### `getSections <project_id> <suite_id>`
Get all sections in a project and suite.
```bash
getSections 7 2751
```

### `getCases <project_id> <suite_id> [section_id]`
Get test cases. Optional section_id to filter.
```bash
# All cases in suite
getCases 7 2751

# Cases in specific section
getCases 7 2751 86977
```

### `getResults <run_id>`
Get test results for a test run.
```bash
getResults 12345
```

### `getTests <run_id>`
Get all tests in a test run (to find test_id for addResult).
```bash
getTests 12345
```

### `addResult <test_id> <status_id> [comment]`
Add a test result.
```bash
# Status IDs: 1=Passed, 2=Blocked, 3=Untested, 4=Retest, 5=Failed
addResult 67890 1 "Test passed successfully"
addResult 67890 5 "Test failed: timeout"
```

### `testrail <endpoint> [method] [data]`
Generic API function for any TestRail endpoint.
```bash
# GET request
testrail "get_suites/7"

# POST request with data
testrail "add_result/67890" "POST" '{"status_id": 1}'
```

---

## For AI Agents (OpenCode, Claude, etc.)

### Prompt Template
```
I have a TestRail CLI script at ~/testrail-cli/testrail.sh.

Please:
1. Source the script: source ~/testrail-cli/testrail.sh
2. Get all sections for project 7, suite 2751
3. Get test cases for section 86977 (Product Detail)
4. Summarize the test case coverage
```

### How AI Should Execute
```bash
# Step 1: Source the script
source /Users/luqmanul.hakim/testrail-cli/testrail.sh

# Step 2: Fetch sections
getSections 7 2751

# Step 3: Fetch test cases
getCases 7 2751 86977

# Step 4: Parse JSON output (piped through jq)
# AI can analyze the "title", "custom_precond", etc.
```

---

## Example Workflow: Analyze PDP Test Coverage

### Step 1: Fetch Section Hierarchy
```bash
source testrail.sh
getSections 7 2751 | jq -r '.sections[] | "\(.id) | \(.name) | parent: \(.parent_id)"'
```

**Output:**
```
87011 | Sanity Test | parent: null
86977 | Product Detail | parent: null
  236804 | Main Photo & Thumbnail | parent: 86977
  236805 | Visitor's Section | parent: 86977
86997 | Ticket List | parent: null
  86998 | Seat map | parent: 86997
```

### Step 2: Fetch Test Cases for Each Section
```bash
for section in 86977 236804 236805 236806 236807 236808 236810 86997 86998; do
  echo "=== Section $section ==="
  getCases 7 2751 $section | jq -r '.cases[] | "\(.id) | \(.title)"'
done
```

### Step 3: Analyze Coverage
```
Summary:
- Product Detail (86977): 7 test cases
  - Main Photo & Thumbnail (236804): 7 cases
  - Visitor's Section (236805): 8 cases
  - ...
- Ticket List (86997): 18 test cases
  - Seat map (86998): 10 cases
```

---

## Add Test Cases to TestRail

### Using API
```bash
# Add a new test case to section 86977
curl -X POST -u "$TESTRAIL_USERNAME:$TESTRAIL_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "New test case title",
    "custom_precond": "Precondition here",
    "custom_steps": "Steps here",
    "custom_expected": "Expected result here"
  }' \
  "${TESTRAIL_URL}/index.php?/api/v2/add_case/86977" | jq .
```

---

## Tips

1. **Use `jq` for filtering:**
   ```bash
   getCases 7 2751 86977 | jq '.cases[] | select(.title | contains("scroll"))'
   ```

2. **Count test cases:**
   ```bash
   getCases 7 2751 86977 | jq '.cases | length'
   ```

3. **Export to CSV:**
   ```bash
   getCases 7 2751 86977 | jq -r '.cases[] | [.id, .title, .custom_precond] | @csv'
   ```

4. **Add result for multiple tests:**
   ```bash
   # Get all test IDs from a run
   getTests 12345 | jq -r '.tests[] | .id' | while read test_id; do
     addResult $test_id 1 "Batch pass"
   done
   ```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `command not found` | Run `source ~/testrail-cli/testrail.sh` first |
| `Warning: No .env file found` | Create `~/testrail-cli/.env` — see Setup Step 2 above |
| 401 Unauthorized | Check `TESTRAIL_API_KEY` in `.env` is correct and active |
| Credentials not loading | Ensure `.env` is in the **same folder** as `testrail.sh` |
| 404 Not Found | Verify project_id, suite_id, section_id exist |
| Empty response | Section might have no test cases |
| `jq: command not found` | Install jq: `brew install jq` (macOS) |

---

## Integration with Other Skills

- **Read TestRail Data** → Use this CLI tool (skill: `testrail-read-data.md`)
- **Generate Test Cases** → Output from PRD analysis (skill: `generate-testcases.md`)
- **Read PRD from Lark** → Fetch requirements (skill: `lark-read-data.md`)
