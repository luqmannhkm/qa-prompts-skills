# Skill: Restore QA Session Context

## Trigger
Use this skill when the user says **"qa-prompt-skills"**, **"restore session"**, or starts a new session and needs context.

## What to Do

1. Read `SESSION.md` from the repo root — it contains the full session state
2. Read the relevant skill files listed in SESSION.md under "Relevant Files"
3. Confirm to the user what context has been restored and what the last active task was

## Steps

### Step 1: Read session state
```
Read file: /Users/luqmanul.hakim/Documents/GitHub/qa-prompts-skills/SESSION.md
```

Or if working from the repo root:
```
Read file: SESSION.md
```

### Step 2: Read key skill files (as needed)
```
Read file: skills/generate-testcases.md
Read file: skills/testrail-cli.md
```

### Step 3: Confirm restored context
Tell the user:
- What project/feature was last being worked on
- What TestRail data has been fetched (suite, sections, case counts)
- What was last exported (Lark Doc URLs)
- What the next pending action is

### Step 4: Ask how to proceed
```
Session context restored. Last active work:
- Fetched 128 test cases from section 512560 (Pax Selection Blossom), suite 7
- 22 subsections mapped, 3 sections have 0 cases (512562, 512589, 512595)

What would you like to do next?
- Generate test cases based on fetched data
- Fetch more TestRail sections
- Export existing cases to Lark Doc
```

---

## How to Update SESSION.md

After completing significant work, update `SESSION.md`:
1. Update the "Active TestRail Context" section with new section/case data
2. Add new completed work to the "Completed Work" table
3. Update "Blocked Items" if resolved
4. Commit: `git commit -m "Update session context: <brief summary>"`
