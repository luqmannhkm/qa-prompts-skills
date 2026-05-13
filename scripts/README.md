# TestRail CLI Helper

A simple command-line interface for interacting with TestRail API, designed for quick testing, automation, and AI agent integration.

## Features

- Get test suites, sections, and cases
- Add test results directly from terminal
- Generic API function for any TestRail endpoint
- Easy configuration via environment variables

## Setup

### 1. Clone the repository
```bash
git clone <repository-url>
cd testrail-cli
```

### 2. Configure your TestRail credentials

Edit `testrail.sh` and replace the default values:

```bash
export TESTRAIL_URL="https://your-company.testrail.net"
export TESTRAIL_USERNAME="your_email@company.com"
export TESTRAIL_API_KEY="your_api_key"
```

**Get your API key:** TestRail → My Settings → API Keys → Add Key

### 3. Load the script

**Option A: Source it manually**
```bash
source testrail.sh
```

**Option B: Add to your shell config (recommended)**
```bash
# For zsh users
echo "source $(pwd)/testrail.sh" >> ~/.zshrc

# For bash users
echo "source $(pwd)/testrail.sh" >> ~/.bashrc
```

## Usage

### Get all suites for a project
```bash
getSuites 7
```

### Get all sections for a project and suite
```bash
getSections 7 2751
```

### Get all test cases for a project and suite
```bash
getCases 7 2751
```

### Get test cases for a specific section
```bash
getCases 7 2751 86977
```

### Get test results for a test run
```bash
getResults 12345
```

### Add a test result
```bash
# Status IDs: 1=Passed, 2=Blocked, 3=Untested, 4=Retest, 5=Failed
addResult 123456 1 "Test passed successfully"
addResult 123456 5 "Test failed: timeout error"
```

### Generic API call
```bash
# GET request
testrail "get_suites/7"

# POST request
testrail "add_result/123456" "POST" '{"status_id": 1}'
```

## For AI Agents

When using this with AI tools (like OpenCode, Claude, etc.):

1. **Source the script first:**
   ```bash
   source testrail.sh
   ```

2. **Fetch test data:**
   ```bash
   # Get all sections and their hierarchy
   getSections 7 2751
   
   # Get test cases for specific section
   getCases 7 2751 86977
   ```

3. **Parse JSON output:**
   The output is piped through `jq` for readable JSON formatting. AI agents can parse this to understand test structure.

4. **Example workflow:**
   ```bash
   # Read all test cases for PDP feature
   getCases 7 2751 86977  # Product Detail section
   getCases 7 2751 86997  # Ticket List section
   ```

## Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `TESTRAIL_URL` | Your TestRail instance URL | `https://traveloka.testrail.net` |
| `TESTRAIL_USERNAME` | Your TestRail email | `your_email@company.com` |
| `TESTRAIL_API_KEY` | Your API key | `your_api_key` |

## Dependencies

- `curl` - for API requests
- `jq` - for JSON formatting (install via `brew install jq` on macOS)

## Examples

### TestRail PDP Test Cases
```bash
# Get all sections in project 7, suite 2751 (Experience Demand - Web)
getSections 7 2751

# Get all test cases in Product Detail section (86977)
getCases 7 2751 86977

# Get all test cases in Ticket List section (86997)
getCases 7 2751 86997
```

## License

MIT License

## Contributing

Feel free to submit issues and pull requests!
