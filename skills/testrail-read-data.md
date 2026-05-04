# Skill: Read Data from TestRail

## Description
Fetch test cases, sections, suites, and other data from TestRail API for analysis and test case generation.

## Prerequisites
- TestRail account with API access
- API key (get from: TestRail → My Settings → API Keys)
- `curl` and `jq` installed (macOS: `brew install jq`)

## Method 1: Using testrail.sh Script

### Setup
```bash
# Clone the testrail-cli repo
git clone https://github.com/luqmannhkm/testrail-cli.git
cd testrail-cli

# Configure credentials
cp .env.example .env
# Edit .env with your actual credentials

# Load the script
source testrail.sh
```

### Available Commands
```bash
# Get all suites for a project
getSuites 7

# Get all sections for a project and suite
getSections 7 2751

# Get all test cases for a project and suite
getCases 7 2751

# Get test cases for a specific section
getCases 7 2751 86977

# Get test results for a test run
getResults 12345

# Add a test result
addResult 123456 1 "Test passed"

# Generic API call
testrail "get_suites/7"
```

---

## Method 2: Direct API Calls (Without Script)

### Get Suites
```bash
curl -s -u "your_email:your_api_key" \
  "https://your-company.testrail.net/index.php?/api/v2/get_suites/7" | jq .
```

### Get Sections
```bash
curl -s -u "your_email:your_api_key" \
  "https://your-company.testrail.net/index.php?/api/v2/get_sections/7&suite_id=2751" | jq .
```

### Get Test Cases
```bash
# All cases in suite
curl -s -u "your_email:your_api_key" \
  "https://your-company.testrail.net/index.php?/api/v2/get_cases/7&suite_id=2751" | jq .

# Cases in specific section
curl -s -u "your_email:your_api_key" \
  "https://your-company.testrail.net/index.php?/api/v2/get_cases/7&suite_id=2751&section_id=86977" | jq .
```

### Get Test Runs
```bash
curl -s -u "your_email:your_api_key" \
  "https://your-company.testrail.net/index.php?/api/v2/get_runs/7" | jq .
```

### Get Tests in a Run
```bash
curl -s -u "your_email:your_api_key" \
  "https://your-company.testrail.net/index.php?/api/v2/get_tests/12345" | jq .
```

### Add Test Result
```bash
curl -s -X POST -u "your_email:your_api_key" \
  -H "Content-Type: application/json" \
  -d '{"status_id": 1, "comment": "Test passed"}' \
  "https://your-company.testrail.net/index.php?/api/v2/add_result/67890" | jq .
```

**Status IDs:** 1=Passed, 2=Blocked, 3=Untested, 4=Retest, 5=Failed

---

## Example Workflow: Read PDP Test Cases

### Step 1: Get all sections to understand hierarchy
```bash
source testrail.sh
getSections 7 2751
```

**Output:** JSON with 67 sections, including:
- Section 86977: Product Detail (with subgroups 236804, 236805, etc.)
- Section 86997: Ticket List (with subgroups 86998, 206840)

### Step 2: Get test cases for specific sections
```bash
# Product Detail section and all subgroups
for section in 86977 236804 236805 236806 236807 236808 236810 236905 236906 236907 236908 236809; do
  echo "=== Section $section ==="
  getCases 7 2751 $section
done
```

### Step 3: Parse and analyze
```bash
# Count test cases in section 86977
getCases 7 2751 86977 | jq '.cases | length'

# List all test case titles
getCases 7 2751 86977 | jq -r '.cases[] | "\(.id) | \(.title)"'
```

---

## For AI Agents (OpenCode, Claude, etc.)

### Prompt Template
```
Read all test cases from TestRail:
- Project ID: 7
- Suite ID: 2751
- Sections: 86977 (Product Detail) and 86997 (Ticket List)
- Include all subgroups under both sections

Please fetch the data, analyze the test case structure, and summarize the coverage.
```

### How AI Should Respond
1. Use `getSections` to fetch section hierarchy
2. Use `getCases` for each section
3. Parse JSON output
4. Summarize: total cases, coverage areas, missing areas
5. Suggest improvements or new test cases

---

## Tips

1. **Pagination:** TestRail API returns max 250 items per request. Use `offset` parameter for more:
   ```bash
   curl -s -u "user:key" \
     "https://testrail.net/index.php?/api/v2/get_cases/7&suite_id=2751&offset=250" | jq .
   ```

2. **Filtering:** Use query parameters:
   - `&section_id=86977` - Filter by section
   - `&filter=title=*PDP*` - Filter by title pattern

3. **Output Formatting:** Always pipe to `jq .` for readable JSON

4. **Error Handling:** Check HTTP status codes:
   - 200: Success
   - 400: Bad request (check parameters)
   - 401: Unauthorized (check API key)
   - 404: Not found (check IDs)

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| `jq: command not found` | Install jq: `brew install jq` (macOS) or `apt-get install jq` (Linux) |
| 401 Unauthorized | Check API key in TestRail → My Settings → API Keys |
| 404 Not Found | Verify project_id, suite_id, section_id exist |
| Empty response | Check if section has test cases; verify permissions |
| `getSuites` not found | Run `source testrail.sh` first |
