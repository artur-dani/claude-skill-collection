# Claude Skill Collection

A plugin marketplace for [Claude Code](https://claude.ai/code) containing [Agent Skills](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview) that extend Claude's capabilities with specialized workflows.

## Available Plugins

| Plugin | Description | Skills/Commands |
|--------|-------------|-----------------|
| **backend-tools** | Backend development with Node.js, Go, REST/GraphQL APIs | `/backend-tools:backend-development` |
| **git** | Git workflow commands | `/git:cm`, `/git:cp`, `/git:pr` |
| **dl** | Core development skills | `/brainstorming`, `/code-review`, `/skill-creator` |

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
/plugin install backend-tools@dani-lab-skills

# Install git plugin
/plugin install git@dani-lab-skills

# Install dl plugin (brainstorming, code-review, skill-creator)
/plugin install dl@dani-lab-skills
```

### Installation Scopes

When installing, choose the appropriate scope for your needs:

#### User Scope (default)
Available across all your projects. Stored in `~/.claude/`.

```
/plugin install dl@dani-lab-skills
```

#### Project Scope
Shared with all collaborators via `.claude/settings.json`. Use this when the whole team should have access.

```
/plugin install dl@dani-lab-skills --scope project
```

#### Local Scope
Only for you in the current repository. Not shared with collaborators.

```
/plugin install dl@dani-lab-skills --scope local
```

## Usage

### Skills

Skills activate automatically based on context, or invoke them directly:

| Skill | Invocation | Description |
|-------|------------|-------------|
| brainstorming | `/brainstorming` | Collaborative dialogue for turning ideas into designs |
| code-review | `/code-review` | Code review workflows and best practices |
| skill-creator | `/skill-creator` | Guide for creating effective Agent Skills |
| backend-development | `/backend-tools:backend-development` | Backend development with modern technologies |

### Git Commands

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
/plugin marketplace update dani-lab-skills
```

Uninstall a plugin:

```
/plugin uninstall dl@dani-lab-skills
```

## Repository Structure

```
claude-skill-collection/
├── .claude-plugin/
│   └── marketplace.json       # Marketplace configuration
├── plugins/
│   ├── backend-tools/         # Standalone plugin
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   └── skills/
│   │       └── backend-development/
│   ├── git/                   # Standalone plugin
│   │   ├── .claude-plugin/
│   │   │   └── plugin.json
│   │   └── commands/
│   │       ├── cm.md
│   │       ├── cp.md
│   │       └── pr.md
│   └── skills/                # dl plugin (bundled skills)
│       ├── brainstorming/
│       │   └── SKILL.md
│       ├── code-review/
│       │   ├── SKILL.md
│       │   └── references/
│       └── skill-creator/
│           ├── SKILL.md
│           ├── references/
│           └── scripts/
└── README.md
```

## License

MIT
