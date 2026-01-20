#!/bin/bash
# Quick validation script for skills - minimal version

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Helper to print error and exit
fail() {
  echo -e "${RED}$1${NC}"
  exit 1
}

# Check argument
if [ -z "$1" ]; then
  echo "Usage: $(basename "$0") <skill_directory>"
  exit 1
fi

SKILL_PATH="$1"
SKILL_MD="$SKILL_PATH/SKILL.md"

# 1. Check SKILL.md exists
if [ ! -f "$SKILL_MD" ]; then
  fail "SKILL.md not found"
fi

# 2. Read and validate frontmatter bounds
# Check if file starts with ---
FIRST_LINE=$(head -n 1 "$SKILL_MD")
if [ "$FIRST_LINE" != "---" ]; then
  fail "No YAML frontmatter found (must start with ---)"
fi

# Extract frontmatter block (content between first two ---)
# We use sed to print lines from line 1 to the next ---, then delete the --- markers
FRONTMATTER=$(sed -n '1,/^---$/p' "$SKILL_MD" | sed '1d;$d')

if [ -z "$FRONTMATTER" ]; then
  fail "Invalid frontmatter format"
fi

# 3. Check for unexpected properties
# Allowed: name, description, license, allowed-tools, metadata
# We extract keys (text before :)
USED_KEYS=$(echo "$FRONTMATTER" | awk -F: '/^[a-z]/ {print $1}')
ALLOWED_KEYS="name description license allowed-tools metadata"

for key in $USED_KEYS; do
  is_allowed=false
  for allowed in $ALLOWED_KEYS; do
    if [ "$key" == "$allowed" ]; then
      is_allowed=true
      break
    fi
  done
  
  if [ "$is_allowed" = false ]; then
    fail "Unexpected key(s) in SKILL.md frontmatter: $key. Allowed properties are: ${ALLOWED_KEYS// /, }"
  fi
done

# 4. Extract Name and Description
# We strip quotes and whitespace
NAME=$(echo "$FRONTMATTER" | grep "^name:" | sed 's/^name:[[:space:]]*//' | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")
DESCRIPTION=$(echo "$FRONTMATTER" | grep "^description:" | sed 's/^description:[[:space:]]*//' | sed -e 's/^"//' -e 's/"$//' -e "s/^'//" -e "s/'$//")

# 5. Validate Name Presence
if [ -z "$NAME" ]; then
  fail "Missing 'name' in frontmatter"
fi

# 6. Validate Description Presence
if [ -z "$DESCRIPTION" ]; then
  fail "Missing 'description' in frontmatter"
fi

# 7. Validate Name Format
# Check regex (lowercase letters, digits, hyphens only)
if [[ ! "$NAME" =~ ^[a-z0-9-]+$ ]]; then
  fail "Name '$NAME' should be hyphen-case (lowercase letters, digits, and hyphens only)"
fi

# Check edges and consecutive hyphens
if [[ "$NAME" == -* ]] || [[ "$NAME" == *- ]] || [[ "$NAME" == *--* ]]; then
  fail "Name '$NAME' cannot start/end with hyphen or contain consecutive hyphens"
fi

# Check length (max 64)
if [ "${#NAME}" -gt 64 ]; then
  fail "Name is too long (${#NAME} characters). Maximum is 64 characters."
fi

# 8. Validate Description Format
# Check for angle brackets
if [[ "$DESCRIPTION" == *"<"* ]] || [[ "$DESCRIPTION" == *">"* ]]; then
  fail "Description cannot contain angle brackets (< or >)"
fi

# Check length (max 1024)
if [ "${#DESCRIPTION}" -gt 1024 ]; then
  fail "Description is too long (${#DESCRIPTION} characters). Maximum is 1024 characters."
fi

# Success
echo -e "${GREEN}Skill is valid!${NC}"
exit 0