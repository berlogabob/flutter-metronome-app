# Agent Collision Resolution Plan

**Version**: 3.0.1 (Collision Fix Release)  
**Date**: 2026-03-11  
**Priority**: CRITICAL  
**Status**: Pending Approval

---

## Executive Summary

Comprehensive collision analysis identified **12 role collisions**, **8 authority conflicts**, **5 hierarchy inconsistencies**, **6 missing collaboration links**, and **4 duplicate functionality areas**.

This document provides actionable fixes for all identified issues, prioritized by severity.

---

## Priority 1: CRITICAL Fixes (Immediate - 2-3 days)

### 1.1 Consolidate Code Quality Enforcement

**Problem**: 5 agents enforce TODO/print()/analyze rules simultaneously

**Agents Affected**:
- app-audit-agents
- mr-compliance
- mr-governor
- mr-cleaner
- mr-senior-developer

**Resolution**:

#### New Enforcement Chain
```
mr-compliance (Detection)
     ↓
mr-cleaner (Auto-fix if safe)
     ↓
mr-senior-developer (Manual review if needed)
     ↓
app-audit-agents (Final BLOCK authority)
     ↓
mr-governor (Logging only - no enforcement)
```

#### File Changes Required

**mr-compliance.md** — Update:
```markdown
## Authority
- DETECT code violations (TODO, print(), analyze errors)
- AUTO-FIX safe issues (formatting, imports)
- REPORT to mr-governor for logging
- ESCALATE to app-audit-agents for blocking

## No Longer Responsible For
- Blocking releases (transferred to app-audit-agents)
- Logging violations (transferred to mr-governor)
```

**mr-cleaner.md** — Update:
```markdown
## Authority
- AUTO-FIX: formatting, imports, whitespace, trailing commas
- REMOVE: TODO comments (track in cleanup log)
- NO BLOCKING AUTHORITY (transferred to app-audit-agents)

## Workflow
1. mr-compliance detects issue
2. If auto-fix safe → mr-cleaner fixes
3. If manual fix needed → mr-senior-developer reviews
```

**mr-governor.md** — Update:
```markdown
## Authority
- LOG violations detected by mr-compliance
- TRACK agent compliance scores
- NO DIRECT ENFORCEMENT (transferred to app-audit-agents)
- NO AUTO-FIX (transferred to mr-cleaner/mr-compliance)
```

**app-audit-agents.md** — Update:
```markdown
## Final BLOCK Authority
- Code Quality Agent: BLOCK after mr-compliance detection + mr-senior-developer review
- Final quality gate before release
```

---

### 1.2 Unify Blocking Authority Hierarchy

**Problem**: Two different hierarchies documented (README.md vs GOVERNANCE_AGENTS.md)

**Resolution**:

#### Update README.md Hierarchy Section

Replace existing hierarchy with:

```markdown
## 🏗️ Updated Hierarchy (v3.0.1)

```
USER (Final Authority)
  │
  ├── mr-controller (Master Controller) — Governance Layer
  │   ├── mr-governor (Project Governance)
  │   │   └── mr-compliance (Automated Compliance)
  │   ├── task-guardian (Scope Enforcement)
  │   └── app-audit-agents (Quality Audit)
  │
  ├── mr-sync (Development Coordinator)
  │   ├── mr-planner (Task Decomposition)
  │   │   └── mr-coder (Implementation)
  │   ├── mr-architect (Design Validation)
  │   ├── mr-senior-developer (Code Review)
  │   ├── mr-tester (Testing)
  │   ├── mr-logger (Logging)
  │   ├── mr-ux-agent (UI Implementation)
  │   ├── widget-guardian (Widget Architecture)
  │   └── mr-cleaner (Automated Formatting)
  │
  ├── mr-release (Release Orchestration)
  │   ├── mr-android (Android Platform)
  │   ├── mr-ios (iOS Platform)
  │   ├── mr-web (Web Platform)
  │   ├── mr-firebase (Backend/Firebase)
  │   └── mr-devops (CI/CD & Automation)
  │
  └── creative-director (UX Proposals)
```

## 🚨 Blocking Authority Hierarchy (v3.0.1)

**Priority order (highest to lowest):**

1. **mr-controller** — Supreme authority (below user only)
2. **task-guardian** — Scope violations (final say on scope)
3. **mr-governor** — Governance violations (rule interpretation)
4. **app-audit-agents Security Agent** — Security vulnerabilities (final BLOCK)
5. **app-audit-agents Functionality Agent** — Broken features (final BLOCK)
6. **mr-compliance** — Compliance violations (auto-fix first, then block)
7. **mr-architect** — Unapproved architecture
8. **widget-guardian** — Widget architecture violations
9. **mr-senior-developer** — Code quality violations (review, then escalate)
10. **mr-tester** — Test coverage <85%
11. **app-audit-agents other agents** — Audit findings (final gate)
```

---

### 1.3 Clarify "Final Say" Claims

**Problem**: 4 agents claim "final" authority

**Resolution**:

#### Update Agent Definitions

**mr-controller.md** — Add:
```markdown
## Final Say Scope
- **FINAL ON**: Agent conflicts, rule exceptions, emergency declarations
- **NOT FINAL ON**: Scope interpretation (task-guardian), quality decisions (app-audit-agents)
- **CAN OVERRIDE**: All agents except user
```

**task-guardian.md** — Add:
```markdown
## Final Say Scope
- **FINAL ON**: Scope interpretation, instruction fidelity
- **NOT FINAL ON**: Quality decisions, governance rules
- **ESCALATES TO**: mr-controller for conflicts with other agents
```

**app-audit-agents.md** — Add:
```markdown
## Final Say Scope
- **FINAL ON**: Quality gate decisions (ship/no-ship), audit findings
- **NOT FINAL ON**: Scope interpretation, governance rules
- **ESCALATES TO**: mr-controller for conflicts with other agents
```

**mr-governor.md** — Add:
```markdown
## Final Say Scope
- **FINAL ON**: Governance rule interpretation
- **NOT FINAL ON**: Scope, quality, agent conflicts
- **ESCALATES TO**: mr-controller for overrides
```

---

## Priority 2: HIGH Fixes (Within 1 week)

### 2.1 Standardize Test Coverage

**Problem**: 4 agents enforce different coverage thresholds (80%, 85%, undefined)

**Resolution**:

#### Universal Coverage Standard

**All Agents Updated to**:
```markdown
## Test Coverage Requirement
- **Threshold**: ≥85% for business logic
- **Minimum**: ≥80% for UI code
- **Enforcer**: mr-tester (primary), app-audit-agents (final audit)
```

**mr-tester.md** — Update:
```markdown
## Authority
- ENFORCE ≥85% coverage for business logic
- ENFORCE ≥80% coverage for UI code
- BLOCK releases below threshold
- REPORT to mr-governor for tracking
```

**app-audit-agents.md** — Update:
```markdown
## Testing Agent
- VALIDATE mr-tester coverage reports
- FINAL BLOCK if coverage <85% (business logic) or <80% (UI)
```

---

### 2.2 Clarify Release Blocking

**Problem**: 9 agents can independently block releases

**Resolution**:

#### Veto-Based Release System

**mr-release.md** — Add:
```markdown
## Release Blocking Protocol

### Veto System
Any agent can VETO release for their area:
- mr-android: Platform-specific issues
- mr-ios: App Store compliance
- mr-web: Browser compatibility
- mr-firebase: Backend/security issues
- mr-devops: CI/CD pipeline issues
- mr-tester: Coverage issues
- app-audit-agents: Quality issues (FINAL)

### Resolution Process
1. Agent issues VETO with reason
2. mr-release logs veto in RELEASE_LOG.md
3. Responsible agent fixes issue
4. Vetoing agent confirms fix
5. mr-release proceeds if all vetoes resolved

### Final Authority
- **app-audit-agents**: Final quality veto (ship/no-ship)
- **mr-controller**: Can override vetoes (with user approval)
```

---

### 2.3 Add Missing Collaboration Links

**Problem**: Key agents missing critical collaboration links

**Resolution**:

#### mr-coder.md — Add Collaboration:
```markdown
## Collaboration Protocol

### Receives From
- mr-architect: Approved designs
- mr-senior-developer: Code review feedback
- mr-planner: Task assignments
- **mr-logger: Logging requirements** ← NEW
- **mr-ux-agent: UI implementation guidance** ← NEW
- **widget-guardian: Widget structure requirements** ← NEW
- **task-guardian: Scope validation** ← NEW

### Sends To
- mr-cleaner: Code for formatting
- mr-tester: Code for testing
- mr-senior-developer: Code for review
- **mr-logger: Implementation details for logging** ← NEW
- **mr-ux-agent: UI code for theme compliance** ← NEW
- **widget-guardian: Widget code for validation** ← NEW
```

#### mr-planner.md — Add Collaboration:
```markdown
## Collaboration Protocol

### Sends To
- **task-guardian: Task scope for validation** ← NEW
- **mr-governor: Task assignments for governance clearance** ← NEW
```

#### mr-release.md — Add Collaboration:
```markdown
## Collaboration Protocol

### Sends To
- **app-audit-agents: Release candidate for final audit** ← NEW
- **mr-governor: Release for governance clearance** ← NEW
- **mr-compliance: Release for compliance scan** ← NEW
- **mr-controller: Release for final approval** ← NEW
```

---

## Priority 3: MEDIUM Fixes (Within 2 weeks)

### 3.1 Consolidate Compliance Scanning

**Problem**: 4 agents perform overlapping code scanning

**Resolution**:

#### Scanning Responsibilities Matrix

| Agent | Scan Type | Frequency | Auto-Fix | Block Authority |
|-------|-----------|-----------|----------|-----------------|
| **mr-compliance** | Code patterns | Every 15 min | Yes (safe only) | Yes (after auto-fix fails) |
| **mr-cleaner** | Formatting | On-demand | Yes | No |
| **mr-governor** | Governance rules | Daily | No | No (logs only) |
| **app-audit-agents** | Quality audit | Pre-release | No | Yes (final gate) |

**Update Each Agent Accordingly**

---

### 3.2 Unify Reporting

**Problem**: 4 different daily/compliance/audit reports

**Resolution**:

#### Unified Reporting Structure

**mr-governor.md** — Update:
```markdown
## Reports

### Daily Governance Report (Consolidated)
- Includes: Compliance data from mr-compliance
- Includes: Violation logs from all agents
- Includes: Agent compliance scores
- Sent to: mr-controller, user
```

**mr-compliance.md** — Update:
```markdown
## Reports

### Compliance Scan Data
- Format: Structured data (JSON)
- Sent to: mr-governor (for daily report)
- Frequency: Every scan (every 15 min)
```

**mr-controller.md** — Update:
```markdown
## Reports

### Daily Command Report
- Content: High-level decisions only
- Frequency: Daily
- Includes: Escalations, exceptions, overrides
```

**app-audit-agents.md** — Update:
```markdown
## Reports

### Pre-Release Audit Report
- Trigger: On-demand (before release)
- Content: Quality gate results
- Sent to: mr-release, user
```

---

### 3.3 Clarify Platform Agent Boundaries

**Problem**: Platform agents have unclear boundaries with mr-devops and mr-firebase

**Resolution**:

#### Platform Council Structure

**Create NEW: PLATFORM_COUNCIL.md**
```markdown
# Platform Council

## Members
- mr-android (Chair, rotating)
- mr-ios
- mr-web
- mr-firebase (Infrastructure representative)
- mr-devops (CI/CD representative)

## Responsibilities
- Cross-platform parity decisions
- Platform-specific standard setting
- Escalation to mr-sync for conflicts

## Meeting Cadence
- Weekly sync via mr-sync
- Ad-hoc for critical issues

## Decision Process
- Consensus preferred
- mr-sync breaks ties
- Escalate to mr-controller for unresolved conflicts
```

**mr-firebase.md** — Reclassify:
```markdown
## Category: Infrastructure Agent (not Platform Specialist)

## Reporting
- mr-sync: Coordination
- mr-devops: CI/CD collaboration
- Platform Council: Backend standards
```

---

## Priority 4: LOW Fixes (Ongoing)

### 4.1 Centralize Metrics Tracking

**Problem**: Multiple agents tracking similar metrics

**Resolution**:

**mr-governor.md** — Add:
```markdown
## Central Metrics Repository

### Collects From
- mr-compliance: Scan frequency, violation counts
- app-audit-agents: Audit results, block counts
- mr-tester: Coverage metrics
- All agents: Compliance scores

### Publishes
- Daily compliance dashboard
- Weekly agent performance report
- Monthly trend analysis
```

---

### 4.2 Documentation Updates

**Required Updates**:
1. README.md — Update hierarchy and blocking authority
2. All agent files — Update collaboration protocols
3. GOVERNANCE_AGENTS.md — Align with README.md
4. Create AGENT_COLLABORATION.md — Collaboration matrix

---

## Implementation Checklist

### Phase 1: CRITICAL (2-3 days)
- [ ] 1.1 Update mr-compliance.md (detection only)
- [ ] 1.1 Update mr-cleaner.md (auto-fix only, no block)
- [ ] 1.1 Update mr-governor.md (logging only)
- [ ] 1.1 Update app-audit-agents.md (final block)
- [ ] 1.2 Update README.md hierarchy
- [ ] 1.3 Update all "final say" claims

### Phase 2: HIGH (3-5 days)
- [ ] 2.1 Standardize test coverage (85%/80%)
- [ ] 2.2 Implement veto-based release system
- [ ] 2.3 Add mr-coder collaboration links
- [ ] 2.3 Add mr-planner collaboration links
- [ ] 2.3 Add mr-release collaboration links

### Phase 3: MEDIUM (1-2 weeks)
- [ ] 3.1 Update compliance scanning matrix
- [ ] 3.2 Implement unified reporting
- [ ] 3.3 Create Platform Council
- [ ] 3.3 Reclassify mr-firebase

### Phase 4: LOW (Ongoing)
- [ ] 4.1 Centralize metrics in mr-governor
- [ ] 4.2 Update all documentation
- [ ] 4.2 Create AGENT_COLLABORATION.md

---

## Testing Plan

### Unit Tests (Per Agent)
- Verify collaboration links work
- Verify blocking authority respected
- Verify reporting functions

### Integration Tests
- Test full workflow: request → delivery
- Test veto resolution process
- Test escalation paths

### Regression Tests
- Ensure no functionality lost
- Verify no new collisions introduced

---

## Rollback Plan

If issues detected:
1. Revert to v3.0.0 agent definitions
2. Document specific collision encountered
3. Revise resolution approach
4. Re-deploy as v3.0.2

---

## Success Metrics

### Week 1
- [ ] All CRITICAL fixes deployed
- [ ] Zero duplicate blocking events
- [ ] Clear escalation paths

### Week 2
- [ ] All HIGH fixes deployed
- [ ] Collaboration links functional
- [ ] Test coverage standardized

### Month 1
- [ ] All MEDIUM fixes deployed
- [ ] Unified reporting operational
- [ ] Platform Council established

### Ongoing
- [ ] Zero agent conflicts unresolved >24h
- [ ] 100% documentation coverage
- [ ] Agent satisfaction (subjective metric)

---

**Approved By**: [Pending User Approval]  
**Implementation Lead**: [To Be Assigned]  
**Target Completion**: 2026-03-25 (2 weeks)

---

> **Remember**: The goal is not to eliminate all agent autonomy, but to ensure clear boundaries and efficient collaboration.
