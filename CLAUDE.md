# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Claude Code plugin collection repository containing Agent Skills that extend Claude Code's capabilities with specialized knowledge and workflows. The repository follows the Agent Skills specification with a marketplace-based plugin architecture.

## Repository Structure

```
claude-plugins/
├── .claude-plugin/
│   └── marketplace.json          # Plugin marketplace configuration
├── plugins/
│   ├── backend-tools/            # Backend development skills
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json       # Plugin metadata
│   │   └── skills/
│   │       └── backend-development/
│   │           ├── SKILL.md      # Main skill file
│   │           └── references/   # Backend reference docs
│   └── meta-tools/               # Meta development tools
│       ├── .claude-plugin/
│       │   └── plugin.json       # Plugin metadata
│       ├── commands/             # Custom commands
│       │   ├── git/              # Git workflow commands
│       │   └── skill/            # Skill creation commands
│       └── skills/
│           ├── code-review/      # Code review workflows
│           └── skill-creator/    # Skill creation workflows
│               └── scripts/      # Skill creation automation
└── README.md
```

## Plugin Architecture

### Marketplace Configuration
- **Location:** `.claude-plugin/marketplace.json`
- **Purpose:** Defines the plugin marketplace, owner, and registered plugins
- **Key Fields:**
  - `name`: Marketplace name
  - `owner`: Owner information (name, email)
  - `metadata`: Description, version, pluginRoot
  - `plugins[]`: Array of registered plugins

### Plugin Configuration
- **Location:** `plugins/<plugin-name>/.claude-plugin/plugin.json`
- **Purpose:** Defines individual plugin metadata
- **Key Fields:**
  - `name`: Plugin identifier
  - `description`: What the plugin provides
  - `version`: Semantic version
  - `author`: Author information
  - `commands`: Optional array of command paths

### Plugin Types
1. **Skill Plugins:** Provide specialized Agent Skills (e.g., backend-tools)
2. **Command Plugins:** Provide custom slash commands (e.g., meta-tools)
3. **Hybrid Plugins:** Combine skills and commands (e.g., meta-tools)

## Agent Skills Architecture

### Skill Structure
Every skill follows this structure:
```
skill-name/
├── SKILL.md (required)           # Main skill file with YAML frontmatter
├── scripts/ (optional)           # Executable code (Node.js, Python)
├── references/ (optional)        # Documentation loaded as needed
└── assets/ (optional)            # Files used in output (templates, etc.)
```

### SKILL.md Requirements
- **Size Limit:** Under 200 lines (use references/ for detailed docs)
- **Frontmatter:** YAML with required fields: name, description, license/version
- **Description Quality:** Must be specific about when to use the skill and what it provides
- **Writing Style:** Use imperative/infinitive form, not second person
- **Progressive Disclosure:** Keep core procedural knowledge in SKILL.md, detailed references in references/

### Bundled Resources
- **scripts/**: Executable code for deterministic tasks (prefer Node.js/Python over Bash for Windows compatibility)
- **references/**: Documentation loaded into context as needed (< 200 lines each)
- **assets/**: Files for output (templates, images, boilerplate)

## Skill Creation Workflow

### Using Skill Creator Scripts
The meta-tools plugin provides automation scripts for skill development:

1. **Initialize New Skill**
   ```bash
   node plugins/meta-tools/skills/skill-creator/scripts/init_skill.js <skill-name> --path <output-directory>
   ```
   - Creates skill directory with proper structure
   - Generates SKILL.md template with frontmatter
   - Creates example resource directories

2. **Validate Skill**
   ```bash
   node plugins/meta-tools/skills/skill-creator/scripts/quick_validate.js <path/to/skill-folder>
   ```
   - Validates YAML frontmatter format
   - Checks required fields and naming conventions
   - Verifies directory structure

3. **Package Skill**
   ```bash
   node plugins/meta-tools/skills/skill-creator/scripts/package_skill.js <path/to/skill-folder> [output-dir]
   ```
   - Automatically validates first
   - Creates distributable zip file
   - Maintains proper directory structure

### Skill Creation Process (from skill-creator SKILL.md)
1. **Understand with Examples:** Gather concrete use cases
2. **Plan Reusable Contents:** Identify scripts, references, assets needed
3. **Initialize Skill:** Run `init_skill.js` to generate template
4. **Edit Skill:** Implement bundled resources, update SKILL.md
5. **Package:** Run `package_skill.js` to validate and package
6. **Iterate:** Test and refine based on usage

## Custom Commands

### Git Commands (meta-tools)
- **Location:** `plugins/meta-tools/commands/git/`
- **/cm (commit):** Stage all files and create conventional commits
  - Follows conventional commit rules (feat, fix, perf, refactor, etc.)
  - NO AI attribution signatures (no "Co-Authored-By: Claude" or similar)
  - Split new files and changes into separate commits
  - DO NOT push to remote automatically
- **/pr (pull request):** Create pull request using `gh` CLI
  - Arguments: [to-branch] [from-branch]
  - Defaults: to-branch=main, from-branch=current

### Skill Commands (meta-tools)
- **Location:** `plugins/meta-tools/commands/skill/`
- **/create:** Create new agent skill
  - Uses skill-creator workflow
  - Requires reading Agent Skills spec and documentation
  - Supports URL exploration for documentation-based skills

## Key Skills Reference

### backend-development (backend-tools)
- **Purpose:** Production-ready backend development with modern technologies
- **Tech Stack:** Node.js/TypeScript, Python, Go, Rust, PostgreSQL, MongoDB, Redis
- **Topics:** API design (REST/GraphQL/gRPC), authentication (OAuth 2.1, JWT), security (OWASP Top 10), performance, testing, DevOps
- **References:** 11 reference files covering technologies, API design, security, authentication, performance, architecture, testing, code quality, DevOps, debugging, mindset

### skill-creator (meta-tools)
- **Purpose:** Guide for creating effective Agent Skills
- **Process:** 6-step workflow from understanding to iteration
- **Scripts:** init_skill.js, quick_validate.js, package_skill.js
- **Key Principle:** Progressive disclosure (metadata → SKILL.md → bundled resources)

### code-review (meta-tools)
- **Purpose:** Proper code review practices with technical rigor
- **Three Practices:**
  1. Receiving feedback: Technical evaluation over performative agreement
  2. Requesting reviews: Systematic review via code-reviewer subagent
  3. Verification gates: Evidence before completion claims
- **Core Principle:** No performative agreement, verify before implementing, evidence before claims

## Development Guidelines

### File Organization
- Keep SKILL.md files under 200 lines
- Split detailed documentation into references/ (each < 200 lines)
- Use scripts/ for code that's repeatedly rewritten or needs deterministic reliability
- Use assets/ for templates and output resources

### Naming Conventions
- Plugin names: kebab-case (e.g., backend-tools, meta-tools)
- Skill names: kebab-case (e.g., backend-development, skill-creator)
- File names: SKILL.md (uppercase), kebab-case for others
- Script files: snake_case.js or snake_case.py

### Script Requirements
- Prefer Node.js or Python over Bash (Windows compatibility)
- Respect .env file hierarchy: process.env > .claude/skills/${SKILL}/.env > .claude/skills/.env > .claude/.env
- Include .env.example for required environment variables
- Write tests for all scripts

### Commit Conventions
- Follow conventional commits (feat, fix, perf, refactor, docs, style, ci, chore, build, test)
- Markdown changes in .claude/: use `perf:` instead of `docs:`
- New files in .claude/: use `feat:` instead of `docs:`
- Title < 70 characters
- NO AI attribution signatures

## Progressive Disclosure Principle

Skills use three-level loading to manage context:
1. **Metadata (name + description):** Always in context (~100 words)
2. **SKILL.md body:** When skill triggers (< 5k words)
3. **Bundled resources:** Loaded as needed by Claude (unlimited)

This allows efficient context management while providing unlimited capability through scripts and references.
