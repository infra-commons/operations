# Runbook: [Service Name]

**Owner:** [Team]
**Last reviewed:** YYYY-MM-DD
**Severity:** [P0 / P1 / P2]

## Overview

Brief description of the service and why this runbook exists.

## Pre-requisites

- Access to [system]
- `tool` installed and configured

## Common scenarios

### [Scenario 1: High error rate]

**Symptoms:**
- Error rate > X% for > Y minutes
- Alert: `[alert-name]`

**Steps:**
1. Check logs: `command here`
2. Verify health: `command here`
3. If issue persists → escalate to [owner]

**Resolution:** [What was done to resolve]

### [Scenario 2: Service down]

**Symptoms:**
- Health check failing

**Steps:**
1. Check status: `command here`
2. Restart if needed: `command here`

## Escalation

| Severity | Contact | Via |
|---|---|---|
| P0 | On-call engineer | PagerDuty |
| P1 | Team lead | Slack #ops |
| P2 | Team member | Slack ticket |

## References

- Dashboard: [link]
- Logs: [link]
- Related runbooks: [link]
