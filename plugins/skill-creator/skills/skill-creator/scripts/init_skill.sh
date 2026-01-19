#!/bin/bash
# Skill Initializer - Creates a new skill from template

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Help/Usage function
usage() {
  echo "Usage: $(basename "$0") <skill-name> --path <path>"
  echo ""
  echo "Skill name requirements:"
  echo "  - Hyphen-case identifier (e.g., 'data-analyzer')"
  echo "  - Lowercase letters, digits, and hyphens only"
  echo "  - Max 40 characters"
  echo "  - Must match directory name exactly"
  echo ""
  echo "Examples:"
  echo "  $(basename "$0") my-new-skill --path skills/public"
  echo "  $(basename "$0") my-api-helper --path skills/private"
  echo "  $(basename "$0") custom-skill --path /custom/location"
}

# Check argument count and flag
if [ "$#" -lt 3 ] || [ "$2" != "--path" ]; then
  usage
  exit 1
fi

SKILL_NAME=$1
TARGET_BASE_PATH=$3

# Validate skill name format (lowercase, digits, hyphens only)
if [[ ! $SKILL_NAME =~ ^[a-z0-9-]+$ ]]; then
  echo -e "${RED}Error: Skill name must be lowercase letters, digits, and hyphens only (e.g., 'my-skill')${NC}"
  echo "Got: $SKILL_NAME"
  exit 1
fi

# Validate length (max 40 chars)
if [ ${#SKILL_NAME} -gt 40 ]; then
  echo -e "${RED}Error: Skill name must be 40 characters or less${NC}"
  exit 1
fi

# Define full target path
SKILL_DIR="${TARGET_BASE_PATH%/}/$SKILL_NAME"

echo "🚀 Initializing skill: $SKILL_NAME"
echo "   Location: $TARGET_BASE_PATH"
echo ""

# Check if directory already exists
if [ -d "$SKILL_DIR" ]; then
  echo -e "${RED}❌ Error: Skill directory already exists: $SKILL_DIR${NC}"
  exit 1
fi

# Create skill directory
# The -p flag creates parent directories if needed (matching pathlib.mkdir(parents=True))
if mkdir -p "$SKILL_DIR"; then
  echo -e "${GREEN}✅ Created skill directory: $SKILL_DIR${NC}"
else
  echo -e "${RED}❌ Error creating directory.${NC}"
  exit 1
fi

# Generate Title Case Name for display
# (e.g., "my-new-skill" -> "My New Skill")
SKILL_TITLE=$(echo "$SKILL_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')

# Create SKILL.md
cat > "$SKILL_DIR/SKILL.md" << EOF
---
name: ${SKILL_NAME}
description: [TODO: Complete and informative explanation of what the skill does and when to use it. Include WHEN to use this skill - specific scenarios, file types, or tasks that trigger it.]
---

# ${SKILL_TITLE}

## Overview

[TODO: 1-2 sentences explaining what this skill enables]

## Structuring This Skill

[TODO: Choose the structure that best fits this skill's purpose. Common patterns:

**1. Workflow-Based** (best for sequential processes)
- Works well when there are clear step-by-step procedures
- Example: DOCX skill with "Workflow Decision Tree" → "Reading" → "Creating" → "Editing"
- Structure: ## Overview → ## Workflow Decision Tree → ## Step 1 → ## Step 2...

**2. Task-Based** (best for tool collections)
- Works well when the skill offers different operations/capabilities
- Example: PDF skill with "Quick Start" → "Merge PDFs" → "Split PDFs" → "Extract Text"
- Structure: ## Overview → ## Quick Start → ## Task Category 1 → ## Task Category 2...

**3. Reference/Guidelines** (best for standards or specifications)
- Works well for brand guidelines, coding standards, or requirements
- Example: Brand styling with "Brand Guidelines" → "Colors" → "Typography" → "Features"
- Structure: ## Overview → ## Guidelines → ## Specifications → ## Usage...

**4. Capabilities-Based** (best for integrated systems)
- Works well when the skill provides multiple interrelated features
- Example: Product Management with "Core Capabilities" → numbered capability list
- Structure: ## Overview → ## Core Capabilities → ### 1. Feature → ### 2. Feature...

Patterns can be mixed and matched as needed. Most skills combine patterns (e.g., start with task-based, add workflow for complex operations).

Delete this entire "Structuring This Skill" section when done - it's just guidance.]

## [TODO: Replace with the first main section based on chosen structure]

[TODO: Add content here. See examples in existing skills:
- Code samples for technical skills
- Decision trees for complex workflows
- Concrete examples with realistic user requests
- References to scripts/templates/references as needed]

## Resources

This skill includes example resource directories that demonstrate how to organize different types of bundled resources:

### scripts/
Executable code (Python/Bash/etc.) that can be run directly to perform specific operations.

**Examples from other skills:**
- PDF skill: \`fill_fillable_fields.py\`, \`extract_form_field_info.py\` - utilities for PDF manipulation
- DOCX skill: \`document.py\`, \`utilities.py\` - Python modules for document processing

**Appropriate for:** Python scripts, shell scripts, or any executable code that performs automation, data processing, or specific operations.

**Note:** Scripts may be executed without loading into context, but can still be read by Claude for patching or environment adjustments.

### references/
Documentation and reference material intended to be loaded into context to inform Claude's process and thinking.

**Examples from other skills:**
- Product management: \`communication.md\`, \`context_building.md\` - detailed workflow guides
- BigQuery: API reference documentation and query examples
- Finance: Schema documentation, company policies

**Appropriate for:** In-depth documentation, API references, database schemas, comprehensive guides, or any detailed information that Claude should reference while working.

### assets/
Files not intended to be loaded into context, but rather used within the output Claude produces.

**Examples from other skills:**
- Brand styling: PowerPoint template files (.pptx), logo files
- Frontend builder: HTML/React boilerplate project directories
- Typography: Font files (.ttf, .woff2)

**Appropriate for:** Templates, boilerplate code, document templates, images, icons, fonts, or any files meant to be copied or used in the final output.

---

**Any unneeded directories can be deleted.** Not every skill requires all three types of resources.
EOF
echo -e "${GREEN}✅ Created SKILL.md${NC}"

# Create scripts/ directory and example script
mkdir -p "$SKILL_DIR/scripts"
cat > "$SKILL_DIR/scripts/example.sh" << EOF
#!/bin/bash1
# Example helper script for ${SKILL_NAME}

echo "This is an example script for ${SKILL_NAME}"
# TODO: Add actual script logic here
# This could be data processing, file conversion, API calls, etc.
EOF
chmod 755 "$SKILL_DIR/scripts/example.sh"
echo -e "${GREEN}✅ Created scripts/example.sh${NC}"

# Create references/ directory and example reference doc
mkdir -p "$SKILL_DIR/references"
cat > "$SKILL_DIR/references/api_reference.md" << EOF
# Reference Documentation for ${SKILL_TITLE}

This is a placeholder for detailed reference documentation.
Replace with actual reference content or delete if not needed.

Example real reference docs from other skills:
- product-management/references/communication.md - Comprehensive guide for status updates
- product-management/references/context_building.md - Deep-dive on gathering context
- bigquery/references/ - API references and query examples

## When Reference Docs Are Useful

Reference docs are ideal for:
- Comprehensive API documentation
- Detailed workflow guides
- Complex multi-step processes
- Information too lengthy for main SKILL.md
- Content that's only needed for specific use cases

## Structure Suggestions

### API Reference Example
- Overview
- Authentication
- Endpoints with examples
- Error codes
- Rate limits

### Workflow Guide Example
- Prerequisites
- Step-by-step instructions
- Common patterns
- Troubleshooting
- Best practices
EOF
echo -e "${GREEN}✅ Created references/api_reference.md${NC}"

# Create assets/ directory and example asset
mkdir -p "$SKILL_DIR/assets"
cat > "$SKILL_DIR/assets/example_asset.md" << EOF
# Example Asset File

This placeholder represents where asset files would be stored.
Replace with actual asset files (templates, images, fonts, etc.) or delete if not needed.

Asset files are NOT intended to be loaded into context, but rather used within
the output Claude produces.

Example asset files from other skills:
- Brand guidelines: logo.png, slides_template.pptx
- Frontend builder: hello-world/ directory with HTML/React boilerplate
- Typography: custom-font.ttf, font-family.woff2
- Data: sample_data.csv, test_dataset.json

## Common Asset Types

- Templates: .pptx, .docx, boilerplate directories
- Images: .png, .jpg, .svg, .gif
- Fonts: .ttf, .otf, .woff, .woff2
- Boilerplate code: Project directories, starter files
- Icons: .ico, .svg
- Data files: .csv, .json, .xml, .yaml

Note: This is a text placeholder. Actual assets can be any file type.
EOF
echo -e "${GREEN}✅ Created assets/example_asset.md${NC}"

# Final output
echo ""
echo -e "${GREEN}✅ Skill '${SKILL_NAME}' initialized successfully at ${SKILL_DIR}${NC}"
echo ""
echo "Next steps:"
echo "1. Edit SKILL.md to complete the TODO items and update the description"
echo "2. Customize or delete the example files in scripts/, references/, and assets/"
echo "3. Run the validator when ready to check the skill structure"