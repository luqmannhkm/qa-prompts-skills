#!/bin/bash
# TestRail API CLI Helper
# Usage: source testrail.sh or add to your .zshrc / .bashrc

# Auto-load .env file if it exists (looks in same directory as this script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [ -f "$ENV_FILE" ]; then
  set -a
  source "$ENV_FILE"
  set +a
  echo "Loaded credentials from $ENV_FILE"
else
  echo "Warning: No .env file found at $ENV_FILE"
  echo "Create one with: TESTRAIL_URL, TESTRAIL_USERNAME, TESTRAIL_API_KEY"
fi

# TestRail API Configuration (falls back to defaults if not set via .env)
export TESTRAIL_URL="${TESTRAIL_URL:-https://traveloka.testrail.net}"
export TESTRAIL_USERNAME="${TESTRAIL_USERNAME:-your_email@company.com}"
export TESTRAIL_API_KEY="${TESTRAIL_API_KEY:-your_api_key}"

# Generic TestRail API function
testrail() {
  local endpoint="$1"
  local method="${2:-GET}"
  local data="$3"
  local url="${TESTRAIL_URL}/index.php?/api/v2/${endpoint}"
  
  if [ "$method" = "GET" ]; then
    curl -s -u "$TESTRAIL_USERNAME:$TESTRAIL_API_KEY" "$url" | jq .
  else
    curl -s -X "$method" -u "$TESTRAIL_USERNAME:$TESTRAIL_API_KEY" \
      -H "Content-Type: application/json" -d "$data" "$url" | jq .
  fi
}

# Get suites for a project
getSuites() {
  if [ -z "$1" ]; then
    echo "Usage: getSuites <project_id>"
    return 1
  fi
  curl -s -u "$TESTRAIL_USERNAME:$TESTRAIL_API_KEY" \
    "${TESTRAIL_URL}/index.php?/api/v2/get_suites/$1" | jq .
}

# Get sections for a project and suite (auto-paginates all pages)
getSections() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: getSections <project_id> <suite_id>"
    return 1
  fi
  local project_id="$1"
  local suite_id="$2"
  local limit=250
  local offset=0
  local tmpdir combined
  tmpdir=$(mktemp -d)
  combined="${tmpdir}/combined.json"
  local page=0

  local response page_size next
  while true; do
    response=$(curl -s -u "$TESTRAIL_USERNAME:$TESTRAIL_API_KEY" \
      "${TESTRAIL_URL}/index.php?/api/v2/get_sections/${project_id}&suite_id=${suite_id}&limit=${limit}&offset=${offset}")
    page_size=$(printf '%s' "$response" | jq -r '.size // 0')
    next=$(printf '%s' "$response" | jq -r '._links.next // empty')
    printf '%s' "$response" | jq '.sections' > "${tmpdir}/page_${page}.json"
    page=$((page + 1))
    if [ -z "$next" ] || [ "$page_size" -lt "$limit" ]; then break; fi
    offset=$((offset + limit))
  done

  # Combine all pages: cat page files, slurp into array of arrays, flatten one level
  cat "${tmpdir}"/page_*.json | jq -s 'add' > "$combined"
  jq -n --slurpfile s "$combined" '{"sections": $s[0]}'
  rm -rf "$tmpdir"
}

# Get cases for a project, suite, and optional section (auto-paginates all pages)
getCases() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: getCases <project_id> <suite_id> [section_id]"
    return 1
  fi
  local project_id="$1"
  local suite_id="$2"
  local section_id="$3"
  local limit=250
  local offset=0
  local tmpdir combined
  tmpdir=$(mktemp -d)
  combined="${tmpdir}/combined.json"
  local page=0

  local response page_size next base_url
  while true; do
    base_url="${TESTRAIL_URL}/index.php?/api/v2/get_cases/${project_id}&suite_id=${suite_id}&limit=${limit}&offset=${offset}"
    if [ -n "$section_id" ]; then base_url="${base_url}&section_id=${section_id}"; fi
    response=$(curl -s -u "$TESTRAIL_USERNAME:$TESTRAIL_API_KEY" "$base_url")
    page_size=$(printf '%s' "$response" | jq -r '.size // 0')
    next=$(printf '%s' "$response" | jq -r '._links.next // empty')
    printf '%s' "$response" | jq '.cases' > "${tmpdir}/page_${page}.json"
    page=$((page + 1))
    if [ -z "$next" ] || [ "$page_size" -lt "$limit" ]; then break; fi
    offset=$((offset + limit))
  done

  # Combine all pages
  cat "${tmpdir}"/page_*.json | jq -s 'add' > "$combined"
  jq -n --slurpfile c "$combined" '{"cases": $c[0]}'
  rm -rf "$tmpdir"
}

# Get test results for a test run
getResults() {
  if [ -z "$1" ]; then
    echo "Usage: getResults <run_id>"
    return 1
  fi
  curl -s -u "$TESTRAIL_USERNAME:$TESTRAIL_API_KEY" \
    "${TESTRAIL_URL}/index.php?/api/v2/get_results/$1" | jq .
}

# Add a test result
addResult() {
  if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: addResult <test_id> <status_id> [comment]"
    echo "Status IDs: 1=Passed, 2=Blocked, 3=Untested, 4=Retest, 5=Failed"
    return 1
  fi
  local test_id="$1"
  local status_id="$2"
  local comment="${3:-}"
  local data="{\"status_id\": $status_id, \"comment\": \"$comment\"}"
  
  curl -s -X POST -u "$TESTRAIL_USERNAME:$TESTRAIL_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$data" \
    "${TESTRAIL_URL}/index.php?/api/v2/add_result/$test_id" | jq .
}

echo "TestRail CLI helper loaded. Available commands:"
echo "  getSuites <project_id>"
echo "  getSections <project_id> <suite_id>"
echo "  getCases <project_id> <suite_id> [section_id]"
echo "  getResults <run_id>"
echo "  addResult <test_id> <status_id> [comment]"
echo "  testrail <endpoint> [method] [data]"
