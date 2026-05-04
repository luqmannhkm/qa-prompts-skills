# Skill: Create New Test Cases

## Description
Generate comprehensive test cases from PRD (Product Requirement Document) following senior QA engineer standards.

## Prerequisites
- Access to PRD document (Lark wiki, Confluence, etc.)
- TestRail API access (optional, for fetching existing test cases)
- Understanding of the feature requirements

---

## Step 1: Read & Analyze PRD

### Using Lark (if PRD is on Lark wiki)
```bash
# Use OpenCode's Lark integration
# Prompt: "Read this PRD document: https://traveloka.sg.larksuite.com/wiki/XXX"
```

### Using Direct Fetch (if public URL)
```bash
curl -s "PRD_URL" | jq .
```

### Manual Input
Copy-paste key PRD sections:
- Feature requirements
- User stories
- Acceptance criteria
- Design mockups (Figma links)

---

## Step 2: Read Existing Test Cases (Optional)

### From TestRail
```bash
source testrail.sh

# Get existing test cases for reference
getCases 7 2751 86977  # Product Detail section
getCases 7 2751 86997  # Ticket List section
```

### Analyze Existing Coverage
```
Review existing test cases, identify:
- Gaps in coverage
- Missing edge cases
- Design validation needs
- E2E flow coverage
```

---

## Step 3: Generate Test Cases by Feature

### Use This Prompt Template
```
As a senior QA engineer, generate comprehensive test cases for [FEATURE_NAME] with format:

Columns: Section | Case | Title | Precondition | Steps | Expected Result

Include test cases for:
1. Logic (happy path, validation)
2. UI Behavior (design validation per Figma)
3. User Interaction (click, scroll, swipe, hover)
4. State Management (persistence, reset, back button)
5. E2E Flow (complete user journey)
6. Edge Cases (0 items, sold out, special characters)
7. Localization (non-English locale)
8. Error Handling (API errors, network issues)
9. Responsive (different viewports, if applicable)

Reference PRD feature: [PASTE_FEATURE_DETAILS_HERE]
```

---

## Step 4: Format Output for Google Sheets

### Markdown Table Format (Easy Copy-Paste)
```
| Section | Case | Title | Precondition | Steps | Expected Result |
|---------|------|-------|--------------|-------|-----------------|
| Feature Name | Logic | Test case title | Precondition here | 1. Step 1<br>2. Step 2 | Expected result here |
```

**Key Formatting Rules:**
- Use `<br>` for line breaks in Steps column (Google Sheets will interpret as new lines)
- No `<br>` tags in other columns
- Keep it concise for easy copy-paste

---

## Step 5: Review & Improve

### Use This Review Prompt
```
Review the test cases I generated for [FEATURE].

Existing test cases I've made (for reference):
[PASTE_YOUR_EXISTING_TEST_CASES]

Please:
1. Identify gaps compared to my existing format
2. Suggest edge cases I missed
3. Improve coverage for E2E flows
4. Add design validation test cases
5. Include user behavior tests (scroll, swipe, back button)
```

---

## Example: Generate Promotional Section Test Cases

### Prompt
```
As a senior QA engineer, generate comprehensive test cases for "Promotional Section" feature:

PRD Summary:
- Horizontal scrollable section at top for isPromotional=TRUE tickets
- Shows: Product Name (2 lines), Strikethrough Price, Final Price, Discount %, Select CTA
- Pax selection pop-up aligned to card
- "Choose Other Dates" CTA when unavailable for selected date

Format: Section | Case | Title | Precondition | Steps | Expected Result

Include: Logic, UI Behavior, User Interaction, State Management, E2E Flow, Edge Cases, Design Validation
```

### Output Example
```
| Promotional Items | Logic | Promotional section displayed when isPromotional=TRUE tickets exist | 1. PDP loaded for attraction with ≥1 ticket tagged isPromotional=TRUE<br>2. Content config has Promotion Title, Subtitle, Background Image set | 1. Load PDP<br>2. Scroll to Ticket List section | Promotional Section displayed at top, shows correct Promotion Title, Subtitle, Background Image |
```

---

## Step 6: Export to Excel (.xlsx)

### Python Script (Optional)
```python
import xlsxwriter

workbook = xlsxwriter.Workbook('TestCases.xlsx')
worksheet = workbook.add_worksheet('Test Cases')

# Define formats
header_format = workbook.add_format({'bold': True, 'bg_color': '#4472C4', 'font_color': 'white'})

# Write headers and data...
# (Refer to generate_testcases.py for full script)

workbook.close()
```

### Prompt for AI to Generate Excel
```
Generate Python script to create .xlsx file with test cases.

Columns: Section | Case | Title | Precondition | Steps | Expected Result

Test cases:
[PASTE_YOUR_TEST_CASES]

Requirements:
- Header row with blue background
- Text wrap enabled for all cells
- Column widths: A=25, B=20, C=50, D=60, E=60
```

---

## Step 7: Update TestRail (Optional)

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

## Test Case Categorization (Use "Case" Column)

| Category | Description | Examples |
|----------|-------------|----------|
| Logic | Core functionality, happy path | "Section displayed", "Button click works" |
| UI Behavior | Design validation, visual elements | "Font size matches Figma", "Image aspect ratio" |
| User Interaction | User actions, gestures | "Click CTA", "Scroll horizontal", "Swipe left/right" |
| State Management | Data persistence, reset | "Maintain state after close", "Reset after booking" |
| E2E Flow | Complete user journey | "From select to booking confirmation" |
| Edge Cases | Boundary conditions, rare scenarios | "0 items", "Sold out", "Special characters" |
| Localization | Multi-language support | "Bahasa Indonesia locale", "Thai characters" |
| Error Handling | API errors, network issues | "500 error", "Network timeout" |
| Responsive | Different screen sizes | "Mobile viewport", "1024px width" |
| Design Validation | Figma spec compliance | "Matches Figma", "Color #007AFF" |
