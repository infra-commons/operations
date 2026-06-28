#!/usr/bin/env bash
# queue-runner.sh — sequential autoloop queue processor
#
# Reads plans/queue (ordered list, one plan dir per line).
# Skips plans whose autoloop branch already has STATUS: DONE in progress.md.
# Runs the first pending plan via run-batch.sh (or $RUNNER if overridden).
#
# Safe to call repeatedly from a systemd timer — idempotent on an empty/all-done queue.
#
# Queue format (plans/queue):
#   plans/marketing-agents      ← pending (runs next)
#   plans/pipeline-safeguards   ← pending (runs after marketing-agents)
#   # comments and blank lines ignored
#
# To add a plan:  echo "plans/my-plan" >> plans/queue  then commit + push
# To skip a plan: prefix the line with #
# To re-run a done plan: delete its autoloop/<plan> branch and re-run
#
# Subscription fallback: set CLAUDE_CONFIG_DIRS to a colon-separated ordered list
# of CLAUDE_CONFIG_DIR paths to try in sequence when exit 75 (subscription exhausted).
# CLAUDE_CONFIG_DIRS takes precedence over CLAUDE_CONFIG_DIR when set.
# Example: CLAUDE_CONFIG_DIRS=$HOME/.claude-<orgA>:$HOME/.claude-<orgB>
# After all entries exhausted: exits 75.
#
# Post-June-15-2026: set RUNNER=./run-once.sh in the autoloop service file
# and the queue runner picks it up automatically.

set -euo pipefail
cd "$(dirname "$0")"

QUEUE="plans/queue"
RUNNER="${RUNNER:-./run-batch.sh}"

# Fetch latest so origin/main:plans/queue reflects recent pushes.
git fetch origin --quiet 2>/dev/null || true

# Read queue from origin/main so we don't need to be on main ourselves.
# Falls back to the local file if the remote isn't available.
QUEUE_CONTENT=$(git show "origin/main:$QUEUE" 2>/dev/null \
             || { [[ -f "$QUEUE" ]] && cat "$QUEUE"; } \
             || true)

if [[ -z "$QUEUE_CONTENT" ]]; then
    echo "No plans/queue found — nothing to do."
    exit 0
fi

is_done() {
    local plan="$1"
    local branch="autoloop/$(basename "$plan")"
    git show "origin/$branch:$plan/progress.md" 2>/dev/null | grep -q '^STATUS: DONE' \
    || git show "$branch:$plan/progress.md" 2>/dev/null | grep -q '^STATUS: DONE'
}

PLAN_DIR=""
while IFS= read -r line; do
    [[ "$line" =~ ^[[:space:]]*# ]] && continue
    [[ -z "${line//[[:space:]]/}" ]] && continue
    plan="${line//[[:space:]]/}"
    if [[ ! "$plan" =~ ^plans/[a-zA-Z0-9_-]+$ ]]; then
        echo "skip (invalid plan name format): $plan" >&2
        continue
    fi
    if is_done "$plan"; then
        echo "skip (done): $plan"
        continue
    fi
    PLAN_DIR="$plan"
    break
done <<< "$QUEUE_CONTENT"

if [[ -z "$PLAN_DIR" ]]; then
    echo "All plans complete or queue empty — nothing to do."
    exit 0
fi

echo "Running: $PLAN_DIR"

# Build ordered subscription list.
# CLAUDE_CONFIG_DIRS (colon-separated) takes precedence over CLAUDE_CONFIG_DIR.
if [[ -n "${CLAUDE_CONFIG_DIRS:-}" ]]; then
    IFS=':' read -ra SUB_DIRS <<< "$CLAUDE_CONFIG_DIRS"
elif [[ -n "${CLAUDE_CONFIG_DIR:-}" ]]; then
    SUB_DIRS=("$CLAUDE_CONFIG_DIR")
else
    SUB_DIRS=()
fi

if [[ ${#SUB_DIRS[@]} -eq 0 ]]; then
    exec env PLAN_DIR="$PLAN_DIR" "$RUNNER"
fi

last_idx=$(( ${#SUB_DIRS[@]} - 1 ))
for i in "${!SUB_DIRS[@]}"; do
    dir="${SUB_DIRS[$i]}"
    [[ -z "$dir" ]] && continue
    echo "Trying subscription: $(basename "$dir")"
    if [[ $i -eq $last_idx ]]; then
        exec env PLAN_DIR="$PLAN_DIR" CLAUDE_CONFIG_DIR="$dir" "$RUNNER"
    fi
    exit_code=0
    env PLAN_DIR="$PLAN_DIR" CLAUDE_CONFIG_DIR="$dir" "$RUNNER" || exit_code=$?
    if [[ $exit_code -eq 75 ]]; then
        echo "Subscription exhausted ($(basename "$dir")) — trying next."
        continue
    fi
    exit $exit_code
done
# All subscriptions exhausted.
exit 75
