## 1. Directory Rename

- [x] 1.1 Rename `repos/skill/src/` to `repos/skill/skills/` via `git mv`

## 2. Update Path References

- [x] 2.1 Update `.claude-plugin/marketplace.json`: change all `./src/` paths to `./skills/`
- [x] 2.2 Update `scripts/validate.sh`: change `src/*/SKILL.md` to `skills/*/SKILL.md`
- [x] 2.3 Update `README.md`: installation instructions, directory structure diagram, development commands

## 3. Verification

- [x] 3.1 Run `./scripts/validate.sh` and confirm all skills pass
- [x] 3.2 Verify no remaining `src/` references in tracked files (`grep -r "src/" --include="*.md" --include="*.json" --include="*.sh"`)
