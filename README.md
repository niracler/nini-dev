# dev-config-template

A template for coordinating multi-repo development with [OpenSpec](https://github.com/Fission-AI/OpenSpec) and AI assistant (Claude Code) integration.

## Why This Template?

When working on projects that span multiple repositories (e.g., a core library + integrations + documentation), you need:

- A central place to coordinate changes across repos
- Consistent AI assistant behavior across the workspace
- Easy setup for new contributors

This template provides that foundation.

## Features

- **Multi-repo coordination**: Manage multiple related repositories in one workspace with centralized configuration
- **OpenSpec integration**: Structured change management and proposal workflow across repos (via `openspec init`)
- **AI assistant guidance**: Pre-configured `CLAUDE.md` for Claude Code with reasoning framework and coding standards
- **One-command setup**: Clone all sub-repos with `./script/setup`

## Quick Start

### 1. Create from template

Click **"Use this template"** button on GitHub, or use the CLI:

```bash
gh repo create my-workspace --template niracler/dev-config-template --private --clone
cd my-workspace
```

### 2. Configure your repos

Edit `repos.json` to define your sub-repositories:

```json
{
  "repos": [
    {
      "name": "my-app",
      "url": "https://github.com/your-org/my-app.git",
      "path": "repos/my-app"
    },
    {
      "name": "my-lib",
      "url": "https://github.com/your-org/my-lib.git",
      "path": "repos/my-lib"
    }
  ]
}
```

### 3. Clone all repos

```bash
./script/setup
```

### 4. Customize CLAUDE.md

Run Claude Code and ask it to help customize the configuration:

```bash
claude
# Then ask: "Help me customize CLAUDE.md for my project"
```

## File Structure

```
my-workspace/
├── CLAUDE.md              # AI assistant guidance (customize this!)
├── AGENTS.md -> CLAUDE.md # Symlink for compatibility
├── repos.json             # Sub-repo configuration
├── .gitignore             # Ignores repos/ directory
├── script/
│   └── setup              # Clone script
├── repos/                 # Sub-repos (git-ignored)
│   ├── my-app/
│   └── my-lib/
└── README.md
```

## Optional Extensions

These can be added after initial setup:

### VSCode Workspace

Create `{project}.code-workspace` for multi-root workspace:

```json
{
  "folders": [
    { "path": ".", "name": "Config" },
    { "path": "repos/my-app", "name": "My App" },
    { "path": "repos/my-lib", "name": "My Lib" }
  ]
}
```

### OpenSpec (Change Management)

[OpenSpec](https://github.com/Fission-AI/OpenSpec) provides structured change management for AI-assisted development:

```bash
# Install openspec CLI, then:
openspec init
```

This creates `openspec/` directory with:

- Proposal workflow for planning changes
- Spec management for tracking requirements
- Integration with Claude Code slash commands

### Custom Claude Commands

Add custom slash commands in `.claude/commands/`:

```
.claude/
└── commands/
    └── my-command.md
```

## Credits

- CLAUDE.md template based on [Xuanwo's AGENTS.md](https://gist.github.com/Xuanwo/fa5162ed3548ae4f962dcc8b8e256bed)

## License

MIT
