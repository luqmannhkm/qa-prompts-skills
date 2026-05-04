# Conversation Prompts

All prompts from the conversation that led to our QA workflow.

## Prompt 1: Check TestRail Script in Zsh

**User Prompt:**
```
do you know that i have script to get testrail data on my zsh?
```

**Context:** User asked if I knew about their TestRail script in zsh configuration.

---

## Prompt 2: Run TestRail Command

**User Prompt:**
```
testrail /getSuites 7
```

**Context:** User wanted to run a TestRail command to get suites for project 7.

---

## Prompt 3: User Claims Script Was Previously Added

**User Prompt:**
```
on the previos session you said you already put the tetrail script on my zsh file and since opencode running on zsh i can use the script when open the new session
```

**Context:** User referenced a previous session where I supposedly added TestRail script to their zsh file. I clarified that each session is independent and checked their `~/.zshrc` file directly.

---

## Prompt 4: Read TestRail Data for PDP

**User Prompt:**
```
first i want you to read data and learn about the testcase on my testrail with project 7 & testsuites id 2751 and group id 86977 & 86997 and all of the testcase with subgroup under both of that group id
```

**Context:** User wanted me to fetch and analyze all test cases from:
- Project: 7
- Suite: 2751 (Experience Demand - Web)
- Sections: 86977 (Product Detail) and 86997 (Ticket List)
- All subgroups under both sections

**Result:** Fetched 67 sections and ~128 test cases, documented the hierarchy.

---

## Prompt 5: Read PRD Document from Lark

**User Prompt:**
```
now you already have the knowledge about the example testcases of PDP (product detail page) and ticket list section, then i want you to read this PRD document about new feature on PDP and ticket list: https://traveloka.sg.larksuite.com/wiki/Wh9EwCAD2iobryk76wYlZcj7gQf
```

**Context:** User asked me to read a PRD (Product Requirement Document) from Lark wiki about new desktop web features for PDP Ticket List.

**Result:** Fetched PRD content which described 5 key features:
1. Promotional Section
2. TList Sidebar
3. TList Groupings
4. Expanded Item Card (Pax Selection)
5. State Management

---

## Prompt 6: Generate Test Cases as Senior QA (with Format)

**User Prompt:**
```
I'll give you task ask a senior QA engineer: for each feature from that PRD i want you to generate new test case with format have column: Section | Title | Precondition | Steps | Expected Result, give me the format that i can directly copy to gooogle spreadsheet, and my suggestion don't forget to add the all possible testcases like testcase related design, test case related to end to end flow, test case related to user behavior like scroll/swipe, continue to next page and go back etc
```

**Context:** User wanted comprehensive test cases in Google Sheets format for all PRD features.

**Result:** Generated 46 test cases covering:
- Promotional Section (10 cases)
- TList Sidebar (14 cases)
- TList Groupings (9 cases)
- Expanded Item Card (14 cases)
- State Management (5 cases)
- E2E Flow (4 cases)
- User Behavior (5 cases)
- Edge Cases (6 cases)
- Design (3 cases)

---

## Prompt 7: Generate .xlsx File

**User Prompt:**
```
could you generate the .xlsx file?
```

**Context:** User wanted the test cases exported to Excel format.

**Result:** Created `TestRail_TestCases_PDP_TicketList.xlsx` using Python with `xlsxwriter` library.

---

## Prompt 8: Review Test Cases Like Partner QA

**User Prompt:**
```
nice, now as a partner QA engineer team i want to review the testcase one by one with you, i also have made the testcases for this feature and i've more comprehensive testcases, this is example testcase i've made for promotional item feature, i want you to learn from this:
[User provided 30+ test cases for Promotional Items with columns: Section, Case, Title, Precondition, Steps, Expected Result]
```

**Context:** User shared their MORE comprehensive test cases for Promotional Items feature. They had better structure with "Case" column for grouping, and included edge cases I missed (sold-out states, special characters, background image sizing, etc.).

**Key Learnings:**
- Use "Case" column to group related scenarios (Logic, UI Behavior, User Interaction, Page Behavior, E2E Flow)
- Include edge cases: sold-out, special characters, loading states, JavaScript disabled
- Add design validation test cases
- Test state persistence across page refresh, browser back, etc.

---

## Prompt 9: Generate TList Sidebar Test Cases (Improved Format)

**User Prompt:**
```
now elaborate your previous testcase for tlist sidebar with more comprehensive testcases and grouping the testcases by case also remove the tag br, just give me the output on the terminal with format like you give before (easy format to copy paste on google spreadsheet) and no neet to generate .xlsx file
```

**Context:** User wanted improved TList Sidebar test cases in the format they used (with "Case" column), more comprehensive, and output directly to terminal (not file).

**Result:** Generated 35+ TList Sidebar test cases grouped by:
- Sidebar Logic
- UI Behavior
- Active State
- Category Navigation
- Scrolling Behavior
- Localization
- Loading State
- E2E Flow
- Edge Cases
- Responsive

---

## Prompt 10: Separate TList Sidebar and TList Groupings

**User Prompt:**
```
i think the testcases you created before is mixing the logic between the tlist sidebar and tlist grouping, i've review and remove the testcase related tlist grouping from tlist sidebar testcase like logic to limit 10 groups only, logic to have show more button, logic to click hidden group and etc all of them is logic for tlist grouping section. now i will ask you to generate comprehensive testcases for tlist grouping section, before you do that please read again the PRD for feature number 3 on Tlist grouping, group conditions, item display conditions, show more / expand behavior, global see more ticket group, default display for regular ticket (collapse state), group with top picks item, expanding regular items, promo ticket display (general rule), promo ticket execption (cheapest and only)
```

**Context:** User corrected me - I was mixing TList Sidebar and TList Groupings. They wanted me to focus ONLY on TList Groupings feature (#3 in PRD).

**Result:** Generated 30+ TList Groupings test cases covering:
- Group Logic (sorting, custom groups, BE priority list)
- Item Display (default collapsed state, Top Picks, regular items)
- Show More/Expand behavior (per group)
- Global Group Limit (10 groups, See more button)
- Promo Ticket Handling (general rule, cheapest exception, only exception)
- Localization
- UI Behavior
- E2E Flow
- Edge Cases

---

## Prompt 11: Generate Test Cases for Feature 1b (Promotional Item Not Available)

**User Prompt:**
```
good result, now give me the testcases for feature 1b promotional item not available states
```

**Context:** User wanted test cases specifically for Feature 1b in PRD: "As a user, I want to know if a promotional item is not available for my selected date."

**Result:** Generated 20+ test cases for Promotional Item Not Available feature, covering:
- Not Available Logic (unavailable state, CTA changes to Choose Other Dates)
- UI Behavior (visual styling, sold out states)
- User Interaction (Choose Other Dates opens calendar, date selection opens pax pop-up)
- Edge Cases (all dates unavailable, single promo item, multiple promo items)
- State Management (main date filter remains original)
- E2E Flow
- Design Validation
- Localization
- Error Handling

---

## Prompt 12: Fix Broken Table Format

**User Prompt:**
```
i think the table you give it to me is broken, could you help to give me the proper table like the tlist grouping tetscase you give to me before?
```

**Context:** User pointed out the table format was broken (had `<br>` tags instead of `<br>`). They wanted the same clean format as TList Groupings.

**Result:** Fixed table format using `<br>` for line breaks, matching the exact format of TList Groupings test cases.

---

## Prompt 13: Generate Test Cases for Feature 4 (Expanded Item Card)

**User Prompt:**
```
now i want you to create testcases for feature number 4 about expanded item card as pax selection
```

**Context:** User wanted test cases for Feature #4: "As a user, I would like to choose the relevant specifications for my desired item within the same page."

**Result:** Generated 25+ Expanded Item Card test cases covering:
- Expanded Card Logic (click Select, only 1 expanded, close card)
- Ticket Header & Inclusions (dynamic title, package inclusions, value badges)
- Visit Date Selection (horizontal date picker, calendar modal, main filter carryover)
- Time Slot Selection (grid display, dynamic updates, unavailable slots)
- Quantity Selector (categories, dynamic pricing, child needs adult rule)
- Booking Summary & CTA (validity note, total price, loyalty points, disabled until complete)
- Sticky Elements (header and footer sticky on scroll)
- State Management (close/reopen maintains state, reset after booking)
- Design Validation
- E2E Flow
- User Behavior
- Edge Cases
- Error Handling

---

## Prompt 14: Create GitHub Repo for TestRail CLI

**User Prompt:**
```
from the previous file to get data from testrail could you create new repo on my directory including the script file and file readme.md about how other people or AI agent could use it when clone the repro
```

**Context:** User wanted me to create a GitHub repository with the TestRail CLI script and README documentation so others (and AI agents) could use it.

**Result:** Created `testrail-cli` repo at https://github.com/luqmannhkm/testrail-cli with:
- `testrail.sh` - CLI helper script
- `README.md` - Setup guide, usage examples, AI agent instructions
- `.env.example` - Template for credentials
- `.gitignore` - Protects `.env` and system files

---

## Prompt 15: Document All Prompts to New Repo with Skill.md Files

**User Prompt:**
```
now i want to documenting all of the prompt i give you here to new repo with multiple skill.md file including skill how to read data from testrail, how to create new test case, and how to read data from lark
```

**Context:** User wanted me to create a new repository documenting ALL prompts and skills from our conversation, with separate skill.md files for each major skill.

**Status:** This is the current task being executed.

---

## Prompt 16: TestRail Add Result - Which ID to Use?

**User Prompt:**
```
from the script you created if i want to put the test run result what id i need to pass for?
```

**Context:** User asked which ID they need to pass to the `addResult` function in testrail.sh.

**Answer:** You need to pass the **test ID** (not test case ID or test run ID). Steps:
1. Get Test Run ID
2. Use `getTests <run_id>` to get tests in that run
3. Use the `id` field from output as test_id
4. Call `addResult <test_id> <status_id> [comment]`

---

## Summary of Skills Demonstrated

1. **Read TestRail Data** - Fetch projects, suites, sections, test cases via API
2. **Read Lark Documents** - Fetch PRD/wiki content from Lark
3. **Generate Test Cases** - Create comprehensive test cases from PRD
4. **Format Output** - Google Sheets, Excel (.xlsx), Markdown tables
5. **Create CLI Tools** - Bash scripts for API interaction
6. **Document Workflows** - Create repos with skill documentation
