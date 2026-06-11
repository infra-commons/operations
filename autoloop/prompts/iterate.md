You are working autonomously on ONE plan inside this repo.

Read these files first, every single time:
1. constitution.md           — non-negotiable rules. Obey them.
2. $PLAN_DIR/vision.md       — the goal and the Definition of Done.
3. $PLAN_DIR/progress.md     — what has happened so far.

Then do exactly this:
- Pick the SINGLE highest-value incomplete item that moves toward the Definition of Done.
- Implement just that one item. Small, reviewable diff.
- All GitHub operations must use the correct GH_CONFIG_DIR as specified in constitution.md.
- After making any GitHub API calls or changes, confirm the resulting state via gh CLI.
- Run the plan's checks ($PLAN_DIR/verify.sh) and fix anything that failed.
- Update $PLAN_DIR/progress.md: move the item to Done, note new items under
  "Blocked / needs human", and record any assumption you had to make.

PAUSE and record "Blocked / needs human" in progress.md when:
- A step requires Kevin to take a web UI action (e.g. creating a GitHub App via GitHub.com)
- A step requires credentials Kevin hasn't provided yet
- An assumption is required that isn't settled in vision.md

Stop signal:
- If EVERY item in the Definition of Done is met AND verify.sh passes, set the top
  line of $PLAN_DIR/progress.md to exactly:  STATUS: DONE
- Otherwise leave it as:  STATUS: IN_PROGRESS

Do not attempt the whole plan in one turn. One unit of work, verified, recorded.
