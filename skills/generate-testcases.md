# Skill: Create New Test Cases

## Description
Generate comprehensive test cases from PRD (Product Requirement Document) following senior QA engineer standards.

## Prerequisites
- Access to PRD document (Lark wiki, Confluence, etc.)
- TestRail account with access to existing test cases
- Lark account with permission to create/edit spreadsheets (via Lark MCP)

---

## Standard Prompt Template (Use This First)

This is the primary prompt template to kick off test case generation. Fill in the variables before sending to the AI agent.

```
Hello, I am a Software Quality Assurance Engineer currently working on a product called {$productName}.
Based on the Product Requirement Document (PRD) located at {$prdLink}, I want to generate test cases
covering all possible scenarios derived from the provided PRD.

You can refer to the existing test cases from the following TestRail link(s):
{$testrailLinks}

For each link, learn about the pattern, the components that need to be tested, the steps, title format, and expected result style.
Also consider which existing test cases are still relevant and should be included or referenced in the newly generated test cases for this feature.

The test cases should include the following types: Positive, Negative, Edge, Security, and Performance.

The test cases should cover: {choose one or more: Functional | API | Visual}

Generate test case scenarios relevant to the target platform: {choose one or more: Mobile | Website},
ensuring alignment with the end-user experience.

Export the results directly into the Lark Spreadsheet at {$spreadsheetLink} with the following columns:
Test Case Id, Title, Section, Automation Type, Estimate, Priority, Preconditions, Steps (Text), Expected Result, Type

Apply the following default values:
- Test Case Id: format TC-001, TC-002, and so on
- Automation Type: Manual
- Section: grouped by feature or module name
- Estimate: in minutes; use 5 minutes as default if no reference is available
- Priority: Critical / High / Medium / Low
- Type: Positive / Negative / Edge / Security / Performance

Steps should be written as a numbered list, one action per line.
Generate all test cases in English.
```

### Variables to Fill In

| Variable | Description | Example |
|----------|-------------|---------|
| `{$productName}` | Name of the product or feature being tested | `Traveloka Attractions PDP` |
| `{$prdLink}` | URL to the PRD document (Lark, Confluence, etc.) | `https://traveloka.sg.larksuite.com/wiki/XXX` |
| `{$testrailLinks}` | One or more TestRail URLs to reference existing test cases. List each on a new line with a `-` prefix if providing multiple | Single: `https://traveloka.testrail.net/index.php?/suites/view/7&group_id=267` — Multiple: see below |
| `{$spreadsheetLink}` | URL of the existing Lark Spreadsheet to write into, or leave empty to create a new one | `https://traveloka.sg.larksuite.com/sheets/XXX` |

#### Multiple TestRail Links — Example

When referencing more than one section or suite, replace `{$testrailLinks}` with a bullet list:

```
- https://traveloka.testrail.net/index.php?/suites/view/7&group_id=267
- https://traveloka.testrail.net/index.php?/suites/view/7&group_id=312
- https://traveloka.testrail.net/index.php?/suites/view/7&group_id=450
```

The AI agent will fetch and analyze all listed links before generating test cases.

### Coverage Options

| Option | When to Use |
|--------|-------------|
| **Functional** | Core business logic, happy/unhappy paths, validations |
| **API** | Backend endpoints, request/response, error codes |
| **Visual** | UI design, Figma compliance, layout, typography |

### Platform Options

| Option | When to Use |
|--------|-------------|
| **Mobile** | iOS / Android native or mobile web |
| **Website** | Desktop or responsive web (includes MWEB) |

### Output Columns Explained

| Column | Description | Default |
|--------|-------------|---------|
| Test Case Id | Unique identifier | TC-001, TC-002, ... |
| Title | Short descriptive name of the test | — |
| Section | Feature or module grouping | Grouped by feature name |
| Automation Type | Manual or Automated | Manual |
| Estimate | Time to execute in minutes | 5 min |
| Priority | Criticality level | Critical / High / Medium / Low |
| Preconditions | Setup required before execution | — |
| Steps (Text) | Numbered steps, one action per line | — |
| Expected Result | What should happen after steps | — |
| Type | Test case category | Positive / Negative / Edge / Security / Performance |

### Test Type Definitions

| Type | Description | Example |
|------|-------------|---------|
| **Positive** | Valid input, expected happy path | "User selects a valid ticket and proceeds to checkout" |
| **Negative** | Invalid input, error scenarios | "User submits form with empty required fields" |
| **Edge** | Boundary conditions, rare states | "0 tickets available", "max 999 quantity" |
| **Security** | Auth, injection, data exposure | "Unauthenticated user cannot access booking" |
| **Performance** | Speed, load, responsiveness | "Page loads within 2s with 100+ items" |

### How AI Should Execute This Prompt

1. **Read PRD** — fetch from `{$prdLink}`, extract features, user stories, acceptance criteria
2. **Read existing TestRail cases** — fetch from each URL in `{$testrailLinks}`, learn title patterns, components, step style, expected result format
3. **Identify test scope** — determine which features need Functional / API / Visual coverage
4. **Determine platform** — Mobile, Website, or both
5. **Generate test cases** — per feature/module, covering all 5 types (Positive, Negative, Edge, Security, Performance)
6. **Apply defaults** — TC-001 IDs, Manual type, 5 min estimate, sections grouped by feature
7. **Export to Lark** — use `lark_docx_builtin_import` to create a Lark Doc (markdown table format), or `lark_bitable_v1_appTableRecord_batchCreate` for a Bitable table. **Do not use Lark Sheets** — the MCP has no write-values tool.

---

## Step 1: Read & Analyze PRD

### Using Lark (if PRD is on Lark wiki)
```bash
# Step 1: Get node info from wiki token (last part of URL)
lark_wiki_v2_space_getNode '{"token": "WIKI_TOKEN", "obj_type": "wiki"}'

# Step 2: Get raw document content using obj_token from response
lark_docx_v1_document_rawContent '{"document_id": "OBJ_TOKEN", "query": {"lang": 0}}'
```

### Manual Input
Copy-paste key PRD sections:
- Feature requirements
- User stories
- Acceptance criteria
- Design mockups (Figma links)

---

## Step 2: Read Existing Test Cases from TestRail URL

### Parse the TestRail URL

Given a TestRail URL like:
```
https://traveloka.testrail.net/index.php?/suites/view/7&group_by=cases:section_id&group_order=asc&display=subtree&group_id=267
```

Extract the following values:

| Parameter | Where to Find | Example |
|-----------|--------------|---------|
| `suite_id` | `/suites/view/{suite_id}` | `7` |
| `section_id` | `group_id={section_id}` | `267` |

> **Note:** `project_id` is not directly in the URL. Use `getSuites` to list all suites — the `project_id` is returned in each suite object.

---

### Step-by-Step: Fetch Data from TestRail URL

#### 1. Source the CLI script
```bash
source ~/testrail-cli/testrail.sh
```

#### 2. Find the project_id from the suite_id
```bash
# List all suites and find "project_id" in the matching suite object
getSuites 7
```

#### 3. Get all sections to understand the hierarchy
```bash
# getSections <project_id> <suite_id>
getSections 7 7

# Filter to find your target section by group_id
getSections 7 7 | jq '.sections[] | select(.id == 267)'
```

#### 4. Fetch test cases for the section (group_id)
```bash
# getCases <project_id> <suite_id> <section_id>
getCases 7 7 267
```

#### 5. Fetch test cases for all subsections
```bash
# List all child sections under the group_id
getSections 7 7 | jq -r '.sections[] | select(.parent_id == 267) | "\(.id) \(.name)"'

# Loop through each subsection
for section_id in 267 71696 73360 35511 44431; do
  echo "=== Section $section_id ==="
  getCases 7 7 $section_id | jq -r '.cases[] | "\(.id) | \(.title)"'
done
```

---

### Full Example: Read from TestRail URL

**URL:**
```
https://traveloka.testrail.net/index.php?/suites/view/7&group_id=267
```

**Execute:**
```bash
source ~/testrail-cli/testrail.sh

# Confirm project_id
getSuites 7 | jq '.suites[] | select(.id == 7) | {id, name, project_id}'

# Get section info
getSections 7 7 | jq '.sections[] | select(.id == 267) | {id, name, parent_id}'

# Get test cases
getCases 7 7 267 | jq -r '.cases[] | "\(.id) | \(.title)"'

# Count total
getCases 7 7 267 | jq '.cases | length'
```

---

### What to Learn from Existing Test Cases
```
Review existing test cases and identify:
- Naming/title pattern (e.g. "[version] Title describes scenario")
- Components being tested (calendar, stepper, CTA, price, etc.)
- Step writing style (imperative, numbered, one action per line)
- Expected result format (assertion-based, descriptive)
- Gaps in coverage — what's missing
- Which existing cases are still relevant to the new feature
```

---

## Step 3: Format Output for Lark Spreadsheet

### Column Format
```
| Test Case Id | Title | Section | Automation Type | Estimate | Priority | Preconditions | Steps (Text) | Expected Result | Type |
|--------------|-------|---------|-----------------|----------|----------|---------------|--------------|-----------------|------|
| TC-001 | Verify [feature] displays correctly | Feature Name | Manual | 5 | High | 1. User is on page | 1. Open page<br>2. Observe feature | Feature renders correctly | Positive |
| TC-002 | Verify error shown on invalid input | Feature Name | Manual | 5 | Medium | 1. User is on page | 1. Enter invalid data<br>2. Submit form | Error message displayed | Negative |
```

**Key Formatting Rules:**
- Test Case Id must be sequential: TC-001, TC-002, TC-003...
- Steps must be numbered, one action per line
- Use `\n` for line breaks inside Steps and Preconditions when writing to Lark Sheets cells
- Keep Title and Expected Result as plain single-line text

---

## Step 4: Export to Lark

The Lark Sheets MCP does **not** have a write-values tool — only query, find, and replace are available. Use one of the two options below instead.

### Option A: Lark Doc (Recommended)

Use `lark_docx_builtin_import` to create a new Lark Doc containing all test cases formatted as a markdown table. This is the fastest and most reliable method.

#### Format the test cases as a markdown table, then call:
```
lark_docx_builtin_import
  file_name: "Test Cases - {$productName}"
  markdown: "<full markdown table with all TC rows>"
```

Response gives you a URL to the created Lark Doc. Share that URL as the output.

> **False-negative warning:** `lark_docx_builtin_import` may return a `Streamable HTTP error` even when the document was created successfully. Always check Lark directly for the created doc before retrying. A retry will create a duplicate.

#### Markdown table format
```markdown
| Test Case Id | Title | Section | Automation Type | Estimate | Priority | Preconditions | Steps (Text) | Expected Result | Type |
|---|---|---|---|---|---|---|---|---|---|
| TC-001 | Verify X displays correctly | Feature Name | Manual | 5 | High | 1. User is on page | 1. Open page\n2. Observe | Feature renders correctly | Positive |
| TC-002 | Verify error shown on invalid input | Feature Name | Manual | 5 | Medium | 1. User is on page | 1. Enter invalid data\n2. Submit | Error message displayed | Negative |
```

---

### Option B: Lark Bitable (Multi-Dimensional Table)

Use `lark_bitable_v1_appTableRecord_batchCreate` to write rows directly into a Bitable table. Best when structured/filterable data is required.

#### 1. Create or locate the Bitable app
```
lark_bitable_v1_app_create
  name: "Test Cases - {$productName}"
```

#### 2. Get the table_id
```
lark_bitable_v1_appTable_list
  app_token: "<app_token from step 1>"
```

#### 3. Batch create records (up to 500 per call)
```
lark_bitable_v1_appTableRecord_batchCreate
  app_token: "<app_token>"
  table_id: "<table_id>"
  records: [
    { "fields": { "Test Case Id": "TC-001", "Title": "...", "Section": "...", "Automation Type": "Manual", "Estimate": 5, "Priority": "High", "Preconditions": "...", "Steps (Text)": "1. Step\n2. Step", "Expected Result": "...", "Type": "Positive" } },
    ...
  ]
```

---

### How AI Agent Should Execute Step 4

1. Format all generated test cases as a markdown table with the 10 standard columns
2. Call `lark_docx_builtin_import` with the formatted markdown
3. If the response returns an error (including `Streamable HTTP error`), **check Lark first** — the doc may already exist
4. Return the Lark Doc URL to the user

---

## Step 5: Update TestRail (Optional)

### Add Test Cases to TestRail
```bash
# Using TestRail API
curl -X POST -u "user:key" \
  -H "Content-Type: application/json" \
  -d '{"title": "Test Case Title", "section_id": 86977, "custom_precond": "Precondition here"}' \
  "https://testrail.net/index.php?/api/v2/add_case/86977"
```

---

## Tips for Comprehensive Coverage

1. **Think Like a User:** How would real users interact? Scroll? Swipe? Go back?
2. **Think Like a Hacker:** What if I enter special characters? No internet? JavaScript disabled?
3. **Think Like a Designer:** Does it match Figma? Font sizes? Colors? Spacing?
4. **Think Like a Business:** Does it support localization? Multiple currencies?
5. **Think Like a Developer:** What if API returns 500? Network throttling?

---

## Test Case Type Reference

| Type | Description | Examples |
|------|-------------|----------|
| Positive | Valid inputs, happy path scenarios | "User selects ticket and proceeds", "Button click navigates correctly" |
| Negative | Invalid inputs, error scenarios | "Submit empty form", "Enter text in number field" |
| Edge | Boundary values, rare/extreme states | "0 tickets available", "999 max quantity", "Special characters in name" |
| Security | Auth, access control, injection | "Unauthenticated access blocked", "SQL injection in search field" |
| Performance | Speed, load, responsiveness | "Loads within 2s", "Handles 100+ items without lag" |
