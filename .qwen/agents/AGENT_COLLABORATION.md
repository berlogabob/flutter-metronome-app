# Agent Collaboration Matrix

**Version**: 3.0.1 (2026-03-11)  
**Status**: Complete

---

## Purpose

Comprehensive matrix of all agent collaboration links, data flows, and communication protocols.

---

## Collaboration Matrix

### Governance Layer

| Agent | Receives From | Sends To | Works With |
|-------|---------------|----------|------------|
| **mr-controller** | All governance agents, user, mr-sync | All agents, user, mr-governor, mr-sync | task-guardian, app-audit-agents, mr-governor, mr-compliance |
| **mr-governor** | mr-compliance, all agents, task-guardian, app-audit-agents, mr-architect, mr-sync, user | All agents, user, mr-architect, mr-sync, mr-release, mr-controller | mr-compliance, task-guardian, app-audit-agents, mr-architect, mr-senior-developer, mr-controller |
| **mr-compliance** | File system, Git hooks | mr-governor, app-audit-agents, mr-sync | mr-cleaner, mr-tester, task-guardian, app-audit-agents |
| **task-guardian** | All agents (before output) | All agents (validation results) | mr-governor, app-audit-agents, mr-controller |
| **app-audit-agents** | mr-compliance, mr-cleaner, mr-senior-developer, mr-governor, mr-tester, all agents | mr-release, mr-governor, mr-controller, user, all agents | mr-compliance, mr-cleaner, mr-senior-developer, mr-tester, mr-governor, task-guardian |

### Coordination & Planning Layer

| Agent | Receives From | Sends To | Works With |
|-------|---------------|----------|------------|
| **mr-sync** | All agents, user | All agents, user, mr-release | mr-controller, mr-planner, mr-release |
| **mr-planner** | user, task-guardian, mr-governor, mr-architect, mr-sync | All development agents, task-guardian, mr-governor, mr-sync | task-guardian, mr-governor, mr-architect, mr-sync, mr-coder, mr-tester |
| **mr-architect** | mr-planner, user | mr-coder, mr-senior-developer, mr-ux-agent, widget-guardian | mr-planner, mr-coder, mr-senior-developer, mr-governor, mr-compliance |
| **creative-director** | user, mr-planner | mr-ux-agent, mr-architect, mr-planner | mr-ux-agent, widget-guardian, mr-architect, mr-planner |

### Development Layer

| Agent | Receives From | Sends To | Works With |
|-------|---------------|----------|------------|
| **mr-senior-developer** | mr-coder, mr-architect, mr-planner | mr-coder, mr-tester, mr-cleaner, app-audit-agents | mr-coder, mr-architect, mr-cleaner, mr-tester, app-audit-agents, mr-governor |
| **mr-cleaner** | mr-compliance, mr-senior-developer, mr-planner | mr-governor, mr-senior-developer, mr-tester | mr-compliance, mr-senior-developer, mr-tester, mr-logger, app-audit-agents |
| **mr-coder** | mr-architect, mr-senior-developer, mr-planner, mr-logger, mr-ux-agent, widget-guardian, task-guardian | mr-cleaner, mr-tester, mr-senior-developer, mr-logger, mr-ux-agent, widget-guardian | mr-architect, mr-senior-developer, mr-cleaner, mr-tester, mr-logger, mr-ux-agent, widget-guardian, task-guardian |
| **mr-tester** | mr-coder, mr-cleaner, mr-senior-developer, mr-planner | mr-governor, mr-senior-developer, mr-coder, app-audit-agents | mr-coder, mr-cleaner, mr-senior-developer, mr-compliance, app-audit-agents |
| **mr-logger** | All agents (logging requirements) | mr-coder, all agents (logging standards) | mr-coder, mr-cleaner, mr-android, mr-ios, app-audit-agents |
| **mr-ux-agent** | creative-director, mr-architect, mr-coder | mr-coder, widget-guardian, app-audit-agents | creative-director, mr-architect, mr-coder, widget-guardian, app-audit-agents |
| **widget-guardian** | mr-architect, mr-coder, mr-ux-agent | mr-coder, app-audit-agents, mr-governor | mr-architect, mr-coder, mr-ux-agent, app-audit-agents, mr-governor |

### Platform Layer

| Agent | Receives From | Sends To | Works With |
|-------|---------------|----------|------------|
| **mr-android** | mr-planner, mr-sync, Platform Council | mr-release, mr-governor, mr-sync, Platform Council | mr-ios, mr-web, mr-firebase, mr-devops, mr-release, Platform Council |
| **mr-ios** | mr-planner, mr-sync, Platform Council | mr-release, mr-governor, mr-sync, Platform Council | mr-android, mr-web, mr-firebase, mr-devops, mr-release, Platform Council |
| **mr-web** | mr-planner, mr-sync, Platform Council | mr-release, mr-governor, mr-sync, Platform Council | mr-android, mr-ios, mr-firebase, mr-devops, mr-release, Platform Council |
| **mr-firebase** | mr-planner, mr-architect, mr-sync, Platform Council | mr-governor, mr-sync, Platform Council, mr-web | mr-android, mr-ios, mr-web, mr-devops, mr-architect, Platform Council |
| **mr-devops** | mr-planner, mr-sync, Platform Council | mr-governor, mr-sync, mr-release, Platform Council | mr-android, mr-ios, mr-web, mr-firebase, mr-release, Platform Council |

### Release Layer

| Agent | Receives From | Sends To | Works With |
|-------|---------------|----------|------------|
| **mr-release** | All platform agents, app-audit-agents, mr-governor, mr-compliance, mr-controller | app-audit-agents, mr-governor, mr-compliance, mr-controller, mr-sync | mr-android, mr-ios, mr-web, mr-firebase, mr-devops, mr-tester, app-audit-agents |

---

## Data Flow Diagrams

### Code Quality Flow
```
mr-compliance (DETECT)
     ↓
mr-cleaner (AUTO-FIX)
     ↓
mr-senior-developer (REVIEW)
     ↓
app-audit-agents (FINAL BLOCK)
     ↓
mr-governor (LOG)
```

### Task Assignment Flow
```
user (REQUEST)
     ↓
mr-planner (DECOMPOSE)
     ↓
task-guardian (VALIDATE SCOPE)
     ↓
mr-governor (CLEARANCE)
     ↓
mr-coder (IMPLEMENT)
```

### Release Flow
```
mr-release (COORDINATE)
     ↓
Platform Agents (VETO/CLEAR)
     ↓
mr-compliance (SCAN)
     ↓
mr-governor (CLEARANCE)
     ↓
app-audit-agents (FINAL APPROVAL)
     ↓
mr-release (DEPLOY)
```

---

## Communication Protocols

### Request Format
```markdown
@agent [Action] [Context]

**Priority**: HIGH/NORMAL/LOW
**Deadline**: [DATE]
**Dependencies**: [List]
```

### Response Format
```markdown
## [AGENT] Response

**Status**: ACCEPTED/DECLINED/ESCALATED
**ETA**: [TIME]
**Blockers**: [List]
**Collaboration**: [Agents involved]
```

### Escalation Format
```markdown
## ESCALATION

**From**: [Agent]
**To**: [Agent/User]
**Issue**: [Description]
**Impact**: [What's blocked]
**Urgency**: CRITICAL/HIGH/MEDIUM/LOW
**Requested Action**: [What's needed]
```

---

## Collision Resolution

### Collision Detection
When multiple agents claim same responsibility:
1. Check this matrix for primary owner
2. If unclear → Escalate to mr-controller
3. mr-controller updates matrix

### Missing Link Resolution
When collaboration link is missing:
1. Agent requests link addition
2. mr-controller approves
3. Matrix updated
4. All agents notified

---

## Version History

| Version | Date | Changes |
|---------|------|---------|
| 3.0.1 | 2026-03-11 | Added governance layer, Platform Council, veto system |
| 3.0.0 | 2026-03-11 | Initial governance agents |
| 2.1.0 | 2026-03-06 | Added platform specialists |
| 2.0.0 | 2026-03-06 | Critical collision fixes |
| 1.0.0 | Initial | Initial agent system |

---

> **Agent Collaboration Matrix: Single Source of Truth**
> 
> Maintained by: mr-controller
> Updated: 2026-03-11 (v3.0.1)
