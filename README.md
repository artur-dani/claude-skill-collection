# Claude Skill Collection

A plugin marketplace for [Claude Code](https://claude.ai/code) containing [Agent Skills](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview) that extend Claude's capabilities with specialized workflows.

## Available Plugins

| Plugin | Description | Skills/Commands |
|--------|-------------|-----------------|
| **backend-tools** | Backend development with Node.js, Go, REST/GraphQL APIs | `backend-development` skill |
| **git** | Git workflow commands | `/git:cm`, `/git:cp`, `/git:pr` |
| **skill-creator** | Guide for creating Agent Skills | `skill-creator` skill |
| **code-review** | Code review workflows and best practices | `code-review` skill |

## Installation

### Step 1: Add the Marketplace

From within Claude Code, add this marketplace:

```
/plugin marketplace add artur-dani/claude-skill-collection
```

Or add from a local path if you've cloned the repository:

```
/plugin marketplace add /path/to/claude-skill-collection
```

### Step 2: Install Plugins

Browse available plugins in the Discover tab:

```
/plugin
```

Or install directly via command line:

```
# Install backend-tools plugin
/plugin install backend-tools@artur-dani-claude-skill-collection

# Install git plugin
/plugin install git@artur-dani-claude-skill-collection

# Install skill-creator plugin
/plugin install skill-creator@artur-dani-claude-skill-collection

# Install code-review plugin
/plugin install code-review@artur-dani-claude-skill-collection
```

### Installation Scopes

When installing, choose the appropriate scope:

- **User scope** (default): Available across all your projects
- **Project scope**: Shared with all collaborators via `.claude/settings.json`
- **Local scope**: Only for you in the current repository

## Usage

Once installed, skills activate automatically based on context:

- **backend-development**: Activates when working on backend code, REST APIs, authentication
- **skill-creator**: Activates when creating new Agent Skills
- **code-review**: Activates during code review workflows

### Custom Commands

The `git` plugin provides slash commands:

| Command | Description |
|---------|-------------|
| `/git:cm` | Stage all files and create a conventional commit |
| `/git:cp` | Commit and push changes |
| `/git:pr` | Create a pull request using GitHub CLI |

## Managing Plugins

View installed plugins:

```
/plugin
```

Then navigate to the **Installed** tab.

Update marketplace to get latest plugins:

```
/plugin marketplace update artur-dani-claude-skill-collection
```

Uninstall a plugin:

```
/plugin uninstall backend-tools@artur-dani-claude-skill-collection
```

## Repository Structure

```
claude-skill-collection/
├── .claude-plugin/
│   └── marketplace.json       # Marketplace configuration
├── plugins/
│   ├── backend-tools/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json    # Plugin metadata
│   │   └── skills/
│   │       └── backend-development/
│   ├── git/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   └── commands/
│   │       ├── cm.md
│   │       ├── cp.md
│   │       └── pr.md
│   ├── skill-creator/
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   └── skills/
│   │       └── skill-creator/
│   └── code-review/
│       ├── .claude-plugin/
│       │   └── plugin.json
│       └── skills/
│           └── code-review/
└── README.md
```

## License

MIT
