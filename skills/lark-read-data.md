# Skill: Read Data from Lark

## Description
Fetch PRD (Product Requirement Document), wiki pages, and other documents from Lark (Feishu) for analysis and test case generation.

## Prerequisites
- Lark/Feishu account with access to the document
- Document URL or wiki token
- OpenCode with Lark integration (or use `lark_docx_v1_document_rawContent` API)

---

## Method 1: Using OpenCode Lark Integration

### Fetch Wiki Document
```bash
# Step 1: Get node info from wiki URL
# URL format: https://traveloka.sg.larksuite.com/wiki/XXX

lark_wiki_v2_space_getNode '{"token": "Wh9EwCAD2iobryk76wYlZcj7gQf", "obj_type": "wiki"}'
```

**Response gives you:**
- `obj_token` - The actual document ID
- `obj_type` - Usually "docx" for new documents
- `title` - Document title

### Fetch Document Content
```bash
# Step 2: Get raw text content
lark_docx_v1_document_rawContent '{"document_id": "ODZmdkXSIontCDxaVxxlil9jg4d", "query": {"lang": 0}}'
```

**Output:** Plain text content of the entire document.

---

## Method 2: Using Lark API Directly (curl)

### Get Access Token
```bash
# You'll need to set up Lark app to get access token
# Refer to Lark Open Platform documentation
```

### Get Document Content
```bash
curl -X POST "https://open.feishu.cn/open-apis/docx/v1/documents/{document_id}/raw_content" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"lang": 0}'
```

---

## Example Workflow: Read PRD and Generate Test Cases

### Step 1: Fetch PRD Document
**Prompt to AI:**
```
Read this PRD document from Lark: https://traveloka.sg.larksuite.com/wiki/Wh9EwCAD2iobryk76wYlZcj7gQf

Please:
1. Summarize the key features
2. List all user stories
3. Extract acceptance criteria for each feature
```

### Step 2: AI Fetches and Analyzes
**AI Action:**
```bash
# Get node info
lark_wiki_v2_space_getNode '{"token": "Wh9EwCAD2iobryk76wYlZcj7gQf", "obj_type": "wiki"}'

# Returns: obj_token = "ODZmdkXSIontCDxaVxxlil9jg4d", obj_type = "docx"

# Get content
lark_docx_v1_document_rawContent '{"document_id": "ODZmdkXSIontCDxaVxxlil9jg4d", "query": {"lang": 0}}'
```

**AI Response:**
```
PRD Summary: [TList] Ticket Group & Display for Desktop

Key Features:
1. Promotional Section - Horizontal scrollable section for isPromotional=TRUE tickets
2. TList Sidebar - Sticky left sidebar with category links
3. TList Groupings - Categorized grouping structure (max 10 groups initially)
4. Expanded Item Card - Inline pax selection (replaces modal)
5. State Management - Maintain selections when closing/reopening

User Stories:
- As a user, I want to see promotional items highlighted so I can quickly choose...
- As a user, I want to see items grouped into categories so I can...
[etc.]
```

### Step 3: Generate Test Cases
**Prompt:**
```
As a senior QA engineer, generate comprehensive test cases for Feature #3 (TList Groupings).

PRD Details:
[PASTE_FEATURE_3_DETAILS]

Format: Section | Case | Title | Precondition | Steps | Expected Result

Include: Logic, UI Behavior, User Interaction, E2E Flow, Edge Cases, Design Validation
```

---

## For AI Agents (OpenCode, Claude, etc.)

### Prompt Template
```
I need to read a PRD from Lark and generate test cases.

PRD URL: https://COMPANY.larksuite.com/wiki/XXX

Please:
1. Fetch the document content using lark_wiki_v2_space_getNode and lark_docx_v1_document_rawContent
2. Summarize the key features and user stories
3. Generate comprehensive test cases for [SPECIFIC_FEATURE]
4. Format output for Google Sheets (Markdown table with <br> for line breaks)
```

### How AI Should Execute
1. **Extract wiki token** from URL (part after `/wiki/`)
2. **Call `lark_wiki_v2_space_getNode`** to get `obj_token` and `obj_type`
3. **Call `lark_docx_v1_document_rawContent`** with `document_id = obj_token`
4. **Parse the text content**
5. **Generate test cases** based on PRD requirements

---

## Lark Document Types Supported

| Type | Description | How to Fetch |
|------|-------------|----------------|
| wiki | Wiki page/node | `lark_wiki_v2_space_getNode` |
| docx | New document format | `lark_docx_v1_document_rawContent` |
| doc | Old document format | Use different API endpoint |
| bitable | Multidimensional table | `lark_bitable_v1_*` APIs |
| sheet | Spreadsheet | Different API |

---

## Tips for Reading PRDs

1. **Look for these sections:**
   - Background / Problem Statement
   - User Stories (As a... I want to... So that...)
   - Acceptance Criteria
   - UI Mockups / Figma Links
   - API Endpoints
   - Edge Cases / Non-Functional Requirements

2. **Extract testable requirements:**
   - "System displays X when Y" → UI test case
   - "User can click Z" → Interaction test case
   - "If A then B" → Logic test case

3. **Identify dependencies:**
   - Does this feature depend on other features?
   - What data setup is required?
   - Are there API dependencies?

---

## Example: Full Workflow with TestRail Integration

### Step 1: Read PRD from Lark
```bash
# AI fetches PRD content
lark_wiki_v2_space_getNode '{"token": "XXX", "obj_type": "wiki"}'
lark_docx_v1_document_rawContent '{"document_id": "YYY", "query": {"lang": 0}}'
```

### Step 2: Read Existing Test Cases from TestRail
```bash
source testrail.sh
getCases 7 2751 86977  # Existing test cases for reference
```

### Step 3: Generate New Test Cases
```
Based on PRD Feature #4 and existing test cases, generate 25+ new test cases.

Format: Section | Case | Title | Precondition | Steps | Expected Result

Include: Expanded Card Logic, Ticket Header, Date Picker, Time Slot, Quantity Selector, Booking CTA, State Management, E2E Flow, Edge Cases
```

### Step 4: Export to Excel
```bash
python3 generate_testcases.py  # (Refer to generate-testcases.md skill)
```

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| "code": 99991663 (permission denied) | Check if your Lark account has access to the document |
| "code": 99991664 (not found) | Verify wiki token is correct (check URL) |
| Empty content returned | Document might be empty, or in unsupported format |
| "obj_type": "doc" (old format) | Use different API endpoint for old docs |
| Cannot find document_id | Use the `obj_token` from `getNode` response as `document_id` |

---

## Quick Reference: Lark API Functions in OpenCode

| Function | Purpose |
|----------|---------|
| `lark_wiki_v2_space_getNode` | Get node info from wiki URL |
| `lark_docx_v1_document_rawContent` | Get plain text content of document |
| `lark_bitable_v1_appTableRecord_search` | Search records in Bitable |
| `lark_bitable_v1_appTableRecord_create` | Create record in Bitable |
| `lark_docx_builtin_search` | Search for documents |
| `lark_task_v2_task_create` | Create a task in Lark |
