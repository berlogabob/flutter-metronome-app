# Governance & Control Agents

**Version**: 1.0.0 (2026-03-11)  
**Total Governance Agents**: 5  
**Status**: Active

---

## 🏛️ Governance Hierarchy

```
USER (Final Authority)
  │
  ▼
mr-controller (Master Controller) ← SUPREME AUTHORITY
  │
  ├── mr-governor (Project Governance) ← Rules & Politics
  ├── mr-compliance (Automated Enforcement) ← Continuous Scanning
  ├── task-guardian (Scope Enforcement) ← Instruction Fidelity
  └── app-audit-agents (Quality Audit) ← Final Quality Gate
```

---

## 📊 Governance Agents Overview

| Agent | Role | Authority | Color |
|-------|------|-----------|-------|
| **mr-controller** | Master Controller | Supreme (below user) | #2C3E50 |
| **mr-governor** | Project Governance | Ultimate on rules | #9B59B6 |
| **mr-compliance** | Automated Enforcement | Real-time scanning | #E74C3C |
| **task-guardian** | Scope Enforcement | Instruction fidelity | Cyan |
| **app-audit-agents** | Quality Audit | Final quality gate | Multi |

---

## 🎯 Agent Details

### mr-controller (Master Controller)

**Purpose**: Supreme authority over all agents (below user only).

**Key Responsibilities**:
- Coordinate all governance agents
- Resolve high-level conflicts
- Approve/deny exceptions
- Make strategic decisions
- Emergency powers

**Authority Level**: 
- ✅ Override any agent decision
- ✅ Suspend agent operations
- ✅ Declare emergencies
- ✅ Modify governance rules (with user approval)

**When to Invoke**:
- Complex conflicts between agents
- Exception requests to rules
- Strategic decisions needed
- Emergency situations

**Example Usage**:
```bash
@mr-controller Resolve conflict between mr-governor and mr-coder
@mr-controller Approve exception to RULE-ARCH-001
@mr-controller Declare emergency for security fix
```

---

### mr-governor (Project Governor)

**Purpose**: Ultimate authority on project rules, politics, and standards.

**Key Responsibilities**:
- Enforce all project rules
- Maintain agent hierarchy
- Proactive compliance monitoring
- Daily governance reports
- Violation tracking

**Authority Level**:
- ✅ Block governance violations
- ✅ Log violations in GOVERNANCE_LOG.md
- ✅ Issue compliance directives
- ✅ Escalate to mr-controller

**Rules Enforced**:
- CODE: 5 rules (analyze, docs, TODOs, print(), tests)
- ARCH: 5 rules (offline-first, Riverpod, separation, etc.)
- DESIGN: 5 rules (Mono Pulse, colors, spacing, etc.)
- SEC: 5 rules (secrets, PII, HTTPS, Firebase, validation)
- DOC: 5 rules (CHANGELOG, README, agents, etc.)
- PROC: 5 rules (tasks, authority, merges, etc.)

**When to Invoke**:
- Rule clarification needed
- Governance clearance required
- Violation detected
- Daily governance report

**Example Usage**:
```bash
@mr-governor Request governance clearance for feature
@mr-governor Report rule violation
@mr-governor Request daily governance report
```

---

### mr-compliance (Automated Compliance)

**Purpose**: Continuous automated compliance scanning and enforcement.

**Key Responsibilities**:
- Real-time code scanning
- Automated violation detection
- Auto-fix safe issues
- Pre-commit gates
- CI/CD integration

**Authority Level**:
- ✅ Auto-fix formatting issues
- ✅ Block commits with violations
- ✅ Generate compliance reports
- ✅ Scan all changes

**Scan Patterns**:
- CRITICAL: API keys, HTTP URLs, print(), TODOs, force unwrap
- MAJOR: Missing docs, hardcoded colors/spacing, long methods
- MINOR: Style deviations, optional improvements

**Scan Frequency**:
- Every 15 minutes: Quick scan
- Every hour: Full code scan
- Every 6 hours: Security scan
- Daily: Full compliance report

**When to Invoke**:
- Compliance scan needed
- Pre-commit check
- Auto-fix formatting
- Compliance report

**Example Usage**:
```bash
@mr-compliance Scan lib/screens/metronome_screen.dart
@mr-compliance Run pre-commit check
@mr-compliance Auto-fix formatting issues
@mr-compliance Generate compliance report
```

---

### task-guardian (Scope Guardian)

**Purpose**: Ensure 100% instruction fidelity — block scope creep.

**Key Responsibilities**:
- Validate agent outputs match user requests
- Block unauthorized additions
- Prevent scope expansion
- Enforce "explicit only" rule

**Authority Level**:
- ✅ BLOCK any output with scope creep
- ✅ Require modifications before pass
- ✅ Final say on scope matters

**Non-Negotiable Rules**:
1. NO scope expansion
2. NO unauthorized changes
3. NO fake data
4. NO alternative suggestions
5. NO scope creep
6. NO commentary
7. NO self-diagnosed issues
8. EXPLICIT ONLY

**When to Invoke**:
- **ALWAYS** before any agent generates code
- **ALWAYS** before any plan execution
- **ALWAYS** before any recommendations

**Example Usage**:
```bash
@task-guardian Validate this code from mr-coder
@task-guardian Check mr-planner's plan for scope creep
@task-guardian Review this response before sending
```

**Response Format**:
- → PASS (matches explicit request)
- → BLOCKED: [violation] (doesn't match)
- → MODIFY REQUIRED: [change] (can be fixed)

---

### app-audit-agents (Quality Audit)

**Purpose**: Final quality gate with 6 specialized audit agents.

**Key Responsibilities**:
- Code quality audit
- Performance audit
- Functionality audit
- UI/UX audit
- Testing audit
- Security audit

**Authority Level**:
- ✅ BLOCK any feature with audit failures
- ✅ Require fixes before approval
- ✅ Final ship/no-ship decision

**Audit Agents**:

| Agent | Checks | Blocks For |
|-------|--------|------------|
| Code Quality | analyze, imports, variables, null safety | Errors, warnings, anti-patterns |
| Performance | build times, startup, memory, FPS | Jank, leaks, slow builds |
| Functionality | all features work | Broken features, exceptions |
| UI/UX | Mono Pulse, spacing, contrast | Hardcoded values, low contrast |
| Testing | coverage, pass rate, flaky tests | Untested features, failing tests |
| Security | secrets, logs, permissions, HTTPS | Vulnerabilities, overreach |

**When to Invoke**:
- Pre-release audit
- Feature completion check
- Quality verification
- Security review

**Example Usage**:
```bash
@app-audit-agents Run full audit on v2.1.0
@app-audit-agents Security audit for Firebase changes
@app-audit-agents Performance audit for metronome
```

---

## 🔄 Governance Workflow

### Standard Workflow
```
1. User Request
     ↓
2. task-guardian (scope check)
     ↓
3. mr-governor (governance clearance)
     ↓
4. Agent Execution
     ↓
5. mr-compliance (compliance scan)
     ↓
6. app-audit-agents (quality audit)
     ↓
7. mr-controller (final approval)
     ↓
8. User Delivery
```

### Emergency Workflow
```
1. Emergency Detected
     ↓
2. mr-controller declares emergency
     ↓
3. Normal processes suspended
     ↓
4. Fast-track fix
     ↓
5. Post-fix audit
     ↓
6. Documentation
```

---

## 📋 Violation Handling

### Violation Types & Responses

| Type | Detected By | Response | Escalation |
|------|-------------|----------|------------|
| Scope Creep | task-guardian | BLOCK immediately | mr-controller |
| Rule Violation | mr-governor | BLOCK + log | mr-controller |
| Compliance Issue | mr-compliance | Auto-fix or flag | mr-governor |
| Quality Issue | app-audit-agents | BLOCK + fix required | mr-controller |
| Authority Exceed | mr-governor | BLOCK + escalate | mr-controller |

### Escalation Path
```
Violation → Agent Detection → Initial Response
     ↓
mr-governor logs violation
     ↓
mr-controller reviews
     ↓
Decision: Fix / Override / Escalate
     ↓
If CRITICAL → @user notification
```

---

## 📊 Governance Reports

### Daily Governance Report (mr-governor)
```markdown
# Daily Governance Report

**Date**: 2026-03-11
**Period**: Past 24 hours

## Summary
- Agent Activities: 47
- Violations: 3
- Blocks: 2
- Escalations: 1

## Violations
| Type | Count | Resolved |
|------|-------|----------|
| CRITICAL | 0 | 0 |
| MAJOR | 2 | 2 |
| MINOR | 1 | 1 |

## Compliance Scores
| Agent | Score |
|-------|-------|
| mr-coder | 96% |
| mr-architect | 100% |
```

### Compliance Report (mr-compliance)
```markdown
# Compliance Report

**Scan**: 2026-03-11 14:30
**Files**: 127
**Status**: ✅ PASS

## Issues
- CRITICAL: 0
- MAJOR: 2 (auto-fixed)
- MINOR: 5
```

### Controller Report (mr-controller)
```markdown
# Daily Command Report

**Date**: 2026-03-11
**Status**: ACTIVE

## Decisions
| ID | Issue | Ruling |
|----|-------|--------|
| #001 | Architecture dispute | Approved Variant B |

## Agent Status
All agents operational.
```

---

## 🚨 Emergency Powers

### Declaration Authority
Only **mr-controller** can declare emergency.

### Emergency Levels

#### Level 1: CRITICAL
**Triggers**:
- Security vulnerability
- Production outage
- Data loss

**Response**:
- All agents report to mr-controller
- Normal processes suspended
- Immediate fix authorized
- Post-fix audit required

#### Level 2: HIGH
**Triggers**:
- Major feature broken
- Build failures
- Test failures >50%

**Response**:
- Priority reassignment
- Fast-track fixes
- Standard audit after

#### Level 3: MEDIUM
**Triggers**:
- Minor feature issues
- Documentation gaps
- Test failures <50%

**Response**:
- Normal priority adjustment
- Standard fix timeline

---

## 📖 Governance Rules

### Complete Rule List

#### Code Rules (RULE-CODE-xxx)
```
RULE-CODE-001: All code must pass flutter analyze with 0 errors
RULE-CODE-002: All public APIs must have documentation comments
RULE-CODE-003: No TODO comments in production code
RULE-CODE-004: No print() statements (use debugPrint)
RULE-CODE-005: All changes must have tests
```

#### Architecture Rules (RULE-ARCH-xxx)
```
RULE-ARCH-001: Offline-first design required for all data features
RULE-ARCH-002: Riverpod required for state management
RULE-ARCH-003: Separation of concerns (models/services/providers/screens)
RULE-ARCH-004: No direct Firestore access from UI layer
RULE-ARCH-005: All external API calls must have caching
```

#### Design Rules (RULE-DESIGN-xxx)
```
RULE-DESIGN-001: Mono Pulse Dark theme only (no light theme)
RULE-DESIGN-002: Orange accent (#FF5E00) only for primary actions
RULE-DESIGN-003: 4-point grid spacing (4, 8, 12, 16, 20, 24...)
RULE-DESIGN-004: Touch targets ≥ 48px
RULE-DESIGN-005: No hardcoded colors (use MonoPulseColors)
```

#### Security Rules (RULE-SEC-xxx)
```
RULE-SEC-001: No hardcoded secrets in code
RULE-SEC-002: No sensitive data in logs (anonymize PII)
RULE-SEC-003: HTTPS only (no HTTP connections)
RULE-SEC-004: Firebase security rules required for all collections
RULE-SEC-005: Input validation on all user inputs
```

#### Documentation Rules (RULE-DOC-xxx)
```
RULE-DOC-001: CHANGELOG.md updated for all changes
RULE-DOC-002: README.md updated for new features
RULE-DOC-003: All agents must have .md definition files
RULE-DOC-004: Architecture decisions documented in GOST format
RULE-DOC-005: Widget usage documented in lib/widgets/README.md
```

#### Process Rules (RULE-PROC-xxx)
```
RULE-PROC-001: All tasks must be assigned to specific agent
RULE-PROC-002: No agent may exceed their defined authority
RULE-PROC-003: All merges require app-audit-agents clearance
RULE-PROC-004: All releases require mr-release coordination
RULE-PROC-005: All CRITICAL violations escalate to user immediately
```

---

## 🎯 Quick Reference

### Which Agent to Invoke?

| Need | Agent |
|------|-------|
| Check scope | @task-guardian |
| Rule question | @mr-governor |
| Compliance scan | @mr-compliance |
| Quality audit | @app-audit-agents |
| Conflict resolution | @mr-controller |
| Emergency | @mr-controller |
| Exception request | @mr-controller |
| Governance report | @mr-governor |
| Pre-commit check | @mr-compliance |
| Pre-release audit | @app-audit-agents |

### Violation Reporting

```bash
# Report violation
@mr-governor Violation: [description]

# Request compliance scan
@mr-compliance Scan [file/path]

# Request scope check
@task-guardian Check [agent output]

# Escalate to controller
@mr-controller Escalate: [issue]
```

---

## 📈 Metrics & KPIs

### Governance Metrics
- **Compliance Rate**: % activities without violations
- **Violation Resolution Time**: Avg time to resolve
- **Escalation Rate**: % escalated to user
- **Auto-Fix Rate**: % issues auto-fixed

### Agent Metrics
- **Individual Scores**: Per-agent compliance
- **Response Times**: Avg response time
- **Accuracy**: % correct decisions
- **Collaboration**: Inter-agent cooperation

---

## 📝 Changelog

### v1.0.0 (2026-03-11) — Initial Governance Agents

**Created Agents**:
- ✅ mr-controller — Master controller with supreme authority
- ✅ mr-governor — Project governance & compliance
- ✅ mr-compliance — Automated compliance scanning

**Documentation**:
- ✅ GOVERNANCE_AGENTS.md created
- ✅ All agent definitions complete
- ✅ Governance workflow documented
- ✅ Rules database established

---

> **Governance is not optional. Compliance is mandatory.**
> Last Updated: 2026-03-11
