# QA Prompts & Skills Repository

A collection of prompts, workflows, and skills for QA engineering tasks using AI agents (OpenCode, Claude, etc.).

## Repository Structure

```
qa-prompts-skills/
├── README.md                          # This file
├── conversation-prompts.md           # All prompts from our conversation
├── skills/
│   ├── testrail-read-data.md       # Skill: Read data from TestRail
│   ├── testrail-create-testcases.md # Skill: Create new test cases
│   ├── lark-read-data.md           # Skill: Read data from Lark
│   └── generate-testcases.md       # Skill: Generate comprehensive test cases
└── examples/
    ├── testrail-script.md          # TestRail CLI script reference
    └── testcase-templates.md       # Test case templates (Google Sheets format)
```

## Quick Start

### For AI Agents (OpenCode, Claude, etc.)

1. **Clone this repo:**
   ```bash
   git clone https://github.com/luqmannhkm/qa-prompts-skills.git
   cd qa-prompts-skills
   ```

2. **Follow skill guides:**
   - Read data from TestRail → `skills/testrail-read-data.md`
   - Create new test cases → `skills/generate-testcases.md`
   - Read data from Lark → `skills/lark-read-data.md`

### For Humans

Review `conversation-prompts.md` to see the full workflow we used to:
- Fetch TestRail data (projects, suites, sections, test cases)
- Read PRD documents from Lark
- Generate comprehensive test cases for PDP features
- Create Excel exports for test cases

## Skills Overview

| Skill | Description | File |
|-------|-------------|------|
| TestRail Read Data | Fetch projects, suites, sections, test cases via API | `skills/testrail-read-data.md` |
| Create Test Cases | Generate comprehensive test cases from PRD | `skills/generate-testcases.md` |
| Read Lark Documents | Fetch PRD/confluence docs from Lark wiki | `skills/lark-read-data.md` |
| TestRail CLI | Command-line helper for TestRail API | `skills/testrail-cli.md` |

## Example Workflow

```
User: "Read my TestRail project 7, suite 2751, sections 86977 and 86997"
  ↓
AI Agent: Reads skill from skills/testrail-read-data.md
  ↓
AI Agent: Uses testrail.sh or direct API calls
  ↓
AI Agent: Returns structured test case data
```

## Contributing

Feel free to submit PRs with new prompts, skills, or improvements!

## License

MIT License
