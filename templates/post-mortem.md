# Post-Mortem: [Incident Title]

**Incident ID:** INC-YYYY-NNN
**Date of incident:** YYYY-MM-DD
**Post-mortem date:** YYYY-MM-DD
**Authors:** [Names]
**Severity:** [P0 / P1 / P2]

## Executive summary

One paragraph: what failed, for how long, impact on users, and the primary fix applied.

## What happened

Chronological narrative of the incident from detection to resolution. Include
technical detail sufficient for any engineer to understand the sequence of events.

## Root cause analysis

### Primary root cause

Describe the fundamental technical reason the incident occurred.

### 5 Whys

1. **Why did the service fail?** → [answer]
2. **Why did [answer]?** → [answer]
3. **Why did [answer]?** → [answer]
4. **Why did [answer]?** → [answer]
5. **Why did [answer]?** → [root cause]

## What went well

- Detection was fast (< X minutes)
- Runbook steps were accurate
- Communication to stakeholders was clear

## What went poorly

- Alert threshold was too high
- Runbook step Y was out of date
- Escalation path was unclear

## Where we got lucky

- The incident occurred during low-traffic hours
- A team member happened to notice the anomaly before the alert fired

## Action items

| Action | Category | Owner | Due date | Status |
|---|---|---|---|---|
| [Fix the root cause] | Prevention | [Name] | YYYY-MM-DD | Open |
| [Update runbook step Y] | Process | [Name] | YYYY-MM-DD | Open |
| [Add alert for X] | Detection | [Name] | YYYY-MM-DD | Open |
| [Improve escalation docs] | Response | [Name] | YYYY-MM-DD | Open |

## Metrics

| Metric | Value |
|---|---|
| Time to detect | X min |
| Time to engage | X min |
| Time to mitigate | X min |
| Time to resolve | X min |
| Total downtime | X min |
| Users affected | X |

## Lessons learned

Summarise the key lessons in 2–3 bullet points that will meaningfully change
how the team operates, monitors, or deploys.
