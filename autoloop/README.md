# infra-commons/operations/autoloop — Shared Autoloop Scripts

Canonical autoloop scripts used by all entity org autoloops. Each org keeps its own copy
of these scripts (seeded from here) plus org-specific `constitution.md`, `prompts/`, and
`plans/queue` files.

## How to instantiate for a new org

1. **Clone the template files into the org's meta/operations repo:**
   ```bash
   cp autoloop/loop.sh ~/repos/{org}/{meta-or-ops}/
   cp autoloop/run-once.sh ~/repos/{org}/{meta-or-ops}/
   cp autoloop/run-batch.sh ~/repos/{org}/{meta-or-ops}/
   cp autoloop/queue-runner.sh ~/repos/{org}/{meta-or-ops}/
   mkdir -p ~/repos/{org}/{meta-or-ops}/prompts
   cp autoloop/prompts/iterate.md ~/repos/{org}/{meta-or-ops}/prompts/
   ```

2. **Create org-specific files:**
   - `constitution.md` — non-negotiable rules for this org's autoloop (see template below)
   - `plans/queue` — empty queue file (one plan dir per line)

3. **Instantiate the systemd files:**
   - Copy `{org}-autoloop.service.template` → `autoloop/{org}-autoloop.service`
   - Copy `{org}-autoloop.timer.template` → `autoloop/{org}-autoloop.timer`
   - Fill in: org name, repo path, CLAUDE_CONFIG_DIR, GH_CONFIG_DIR, BILLING_DAY

4. **Install systemd units (Kevin action):**
   ```bash
   mkdir -p ~/.config/systemd/user
   cp autoloop/{org}-autoloop.service ~/.config/systemd/user/
   cp autoloop/{org}-autoloop.timer ~/.config/systemd/user/
   systemctl --user daemon-reload
   systemctl --user enable --now {org}-autoloop.timer
   ```

5. **Verify:**
   ```bash
   systemctl --user status {org}-autoloop.timer
   ```

## constitution.md template

```markdown
# {Org} — Autoloop Constitution

This file is the project-level anchor for every autonomous loop. Plans come and go;
these rules do not. The agent reads this every iteration and obeys them.

## What this project is

Autonomous plan delivery across the {Org} tech stack.

## Non-negotiable rules

1. **Draft PRs only, and never merge.** Always `gh pr create --draft`. Never merge.
2. **One unit of work per iteration.** Small, reviewable diff.
3. **GitHub CLI config.** All {org-name} operations MUST use:
   `GH_CONFIG_DIR=/home/kev/.config/gh-{org} gh ...`

## Authentication model

- GitHub: `GH_CONFIG_DIR=/home/kev/.config/gh-{org}`

## Blocked / needs human — when to stop

Stop and record in `progress.md` when:
- A step requires Kevin to take a web UI action
- Credentials are needed that aren't in the environment
- An assumption is required that isn't settled in `vision.md`
```

## Updating scripts across orgs

When `loop.sh` or `queue-runner.sh` changes here, propagate to each entity org manually:
```bash
for org in rolliq cashbucket chargingblindly klsjapan; do
  # find the ops/meta repo for this org and copy updated scripts
done
```

## Files in this directory

| File | Purpose |
|---|---|
| `loop.sh` | Main autonomous plan loop driver |
| `run-once.sh` | Billing-aware single-batch runner (use from June 15 2026) |
| `run-batch.sh` | Pre-billing runner (uses shared subscription pool) |
| `queue-runner.sh` | Reads `plans/queue`, picks next pending plan, runs it |
| `prompts/iterate.md` | Standard iterate prompt loaded by loop.sh each iteration |
| `README.md` | This file |
