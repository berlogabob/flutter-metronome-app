# Agent System for RepSync / FlowGroove Metronome

Autonomous AI agents that drive development, testing, and release of the Flutter metronome app.

**Version**: 2.0.0 (2026-03-06)  
**Total Agents**: 18  
**Status**: Active

---

## 🏗️ Updated Hierarchy

```
USER (Final Authority)
│
├── mr-sync (Coordinator — NO task decomposition)
│   └── Tracks progress, resolves conflicts, escalates blockers
│
├── mr-planner (Task Decomposition)
│   ├── Breaks down tasks
│   ├── Assigns to agents
│   └── mr-coder (Implementation — NEW)
│       └── Writes code from approved designs
│
├── mr-architect (Design Validation)
│   ├── Approves architecture
│   └── Blocks unapproved designs
│
├── creative-director (UX Proposals — NO enforcement)
│   └── Proposes UX flows only
│
├── mr-senior-developer (Code Review)
│   ├── Reviews code quality
│   └── Blocks low-quality code
│
├── mr-cleaner (Automated Formatting — NO review authority)
│   ├── dart format
│   ├── Dead code removal
│   └── Import optimization
│
├── mr-tester (Testing)
│   ├── Writes tests
│   ├── Target ≥85% coverage
│   └── Blocks untested code
│
├── mr-logger (Logging — PII anonymized)
│   ├── Structured logging
│   └── Crashlytics integration
│
├── mr-ux-agent (UI Implementation)
│   ├── Implements approved designs
│   └── Applies MonoPulse theme
│
├── widget-guardian (Widget Architecture)
│   ├── Validates widget structure
│   ├── Blocks widgets >300 lines
│   └── Enforces const constructors
│
├── app-audit-agents (Final Audit Gate)
│   ├── Code Quality Agent
│   ├── Performance Agent
│   ├── Functionality Agent
│   ├── UI/UX Agent
│   ├── Testing Agent
│   └── Security Agent (PII enforcement)
│
├── mr-android (Android Platform — MERGED with mr-android-debug)
│   ├── Builds & deployment
│   ├── Debugging & crash analysis
│   └── Performance profiling
│
├── mr-release (Release Orchestration)
│   ├── Versioning
│   ├── Build artifacts
│   └── Deployment
│
└── task-guardian (Scope Enforcement — Highest Priority)
    └── Blocks scope violations
```

---

## 📊 Agent Categories

### 🎯 Coordination & Planning
| Agent | Purpose | Status | Changes v2.0.0 |
|-------|---------|--------|----------------|
| **mr-sync** | Main coordinator, conflict resolution | ✅ Active | Removed task decomposition (mr-planner owns) |
| **mr-planner** | Task decomposition, assignments | ✅ Active | Clarified authority |
| **mr-architect** | Design validation, architecture approval | ✅ Active | No changes |
| **creative-director** | UX flow proposals | ✅ Active | Removed enforcement authority |
| **mr-coder** | Code implementation | ✅ NEW | Created to fill implementation gap |

### 🔧 Development
| Agent | Purpose | Status | Changes v2.0.0 |
|-------|---------|--------|----------------|
| **mr-senior-developer** | Code review, best practices | ✅ Active | No changes |
| **mr-cleaner** | Automated formatting, dead code removal | ✅ Active | Removed review authority |
| **mr-tester** | Unit tests, integration tests, coverage | ✅ Active | No changes |
| **mr-logger** | Structured logging, Crashlytics | ✅ Active | Added PII anonymization |

### 🎨 UI/UX
| Agent | Purpose | Status | Changes v2.0.0 |
|-------|---------|--------|----------------|
| **mr-ux-agent** | UI implementation, theme compliance | ✅ Active | No changes |
| **widget-guardian** | Widget architecture, performance | ✅ Active | No changes |
| **app-audit-agents** | Comprehensive app auditing | ✅ Active | No changes |

### 📱 Platform & Release
| Agent | Purpose | Status | Changes v2.0.0 |
|-------|---------|--------|----------------|
| **mr-android** | Android builds, debugging, crashes | ✅ Active | Merged with mr-android-debug |
| ~~mr-android-debug~~ | ~~Real-time debugging~~ | ❌ REMOVED | Merged into mr-android |
| **mr-release** | Release orchestration, versioning | ✅ Active | No changes |

### 🛡️ Quality Assurance
| Agent | Purpose | Status | Changes v2.0.0 |
|-------|---------|--------|----------------|
| **task-guardian** | Instruction fidelity, scope enforcement | ✅ Active | No changes |

---

## 🚨 Critical Fixes Applied (v2.0.0)

### 1. ✅ Merged mr-android + mr-android-debug
**Problem**: Role collision — both agents handled Android debugging.  
**Fix**: Single `mr-android` agent owns ALL Android concerns.  
**Result**: No duplicate logcat commands, clear ownership.

### 2. ✅ Clarified UX Authority
**Problem**: 4 agents claimed design system enforcement.  
**Fix**:  
- creative-director: PROPOSES only (NO enforcement)
- mr-ux-agent: IMPLEMENTS approved designs
- widget-guardian: VALIDATES structure only
- app-audit-agents: AUDITS post-implementation

### 3. ✅ Code Quality Workflow
**Problem**: 3 agents with duplicate/contradictory authority.  
**Fix**:  
- mr-cleaner: AUTOMATED formatting only (NO review)
- mr-senior-developer: CODE REVIEW
- app-audit-agents: FINAL AUDIT GATE

### 4. ✅ Security vs Logging
**Problem**: mr-logger logged PII, Security Agent blocked it.  
**Fix**: mr-logger MUST anonymize PII (hashed IDs only).

### 5. ✅ Coordinator Hierarchy
**Problem**: mr-sync decomposed tasks AND coordinated.  
**Fix**:  
- mr-sync: COORDINATES only (NO decomposition)
- mr-planner: DECOMPOSES tasks

### 6. ✅ Created mr-coder
**Problem**: Multiple agents referenced non-existent `mr-coder`.  
**Fix**: Created `mr-coder` agent for implementation.

---

## 📋 Blocking Authority Hierarchy

**Priority order (highest to lowest):**

1. **task-guardian** — Scope violations (HIGHEST)
2. **app-audit-agents Security Agent** — Security vulnerabilities
3. **app-audit-agents Functionality Agent** — Broken features
4. **mr-architect** — Unapproved architecture
5. **widget-guardian** — Widget architecture violations
6. **mr-senior-developer** — Code quality violations
7. **mr-tester** — Test coverage <85%
8. **app-audit-agents other agents** — Audit findings (LOWEST)

---

## 📝 Usage Examples

### Request Work
```bash
# Assign task to specific agent
@mr-planner Design song structure editor

# Use guardian agents for validation
@task-guardian Validate this implementation

# Use widget guardian for widget quality
@widget-guardian Review this widget architecture

# Request code implementation (after design approval)
@mr-coder Implement metronome start/stop
```

### Agent Collaboration Flow
```
1. User requests feature
2. mr-planner decomposes into tasks
3. mr-architect approves design
4. mr-coder implements code
5. mr-cleaner formats code
6. mr-senior-developer reviews code
7. mr-tester validates tests
8. app-audit-agents perform final audit
9. task-guardian ensures scope compliance
10. mr-release deploys
```

---

## 🆕 New Agents (v2.0.0)

### mr-coder
**Purpose**: Code implementation from approved designs.

**Responsibilities**:
- Write code from mr-architect approved designs
- Follow mr-cleaner formatting standards
- Include mr-logger structured logging
- Pass mr-tester coverage requirements

**Collaboration**:
- Receives from: mr-architect (designs), mr-senior-developer (review approval)
- Sends to: mr-cleaner (formatting), mr-tester (validation)

---

## 📊 Agent Status Summary

| Category | Agents | New | Removed | Active |
|----------|--------|-----|---------|--------|
| Coordination | 5 | 1 (mr-coder) | 0 | 5 |
| Development | 4 | 0 | 0 | 4 |
| UI/UX | 3 | 0 | 0 | 3 |
| Platform/Release | 3 | 0 | 1 (mr-android-debug) | 3 |
| Quality Assurance | 3 | 0 | 0 | 3 |
| **TOTAL** | **18** | **1** | **1** | **18** |

---

## 📖 Changelog

### v2.0.0 (2026-03-06) — Critical Collision Fixes

**Merged Agents**:
- ✅ mr-android + mr-android-debug → Single `mr-android` agent

**Created Agents**:
- ✅ mr-coder — Implementation specialist

**Updated Agents**:
- ✅ mr-sync — Removed task decomposition
- ✅ creative-director — Removed enforcement authority
- ✅ mr-cleaner — Removed review authority
- ✅ mr-logger — Added PII anonymization

**Documentation**:
- ✅ Updated hierarchy diagram
- ✅ Defined blocking authority hierarchy
- ✅ Clarified collaboration protocols

### v1.0.0 (Initial)
- Initial agent system
- 17 agents defined

---

> Built with ❤️ for musicians and cover bands  
> Repository: [flutter-flowgroove-app-metronome](https://github.com/berlogabob/flutter-flowgroove-app-metronome)  
> **Last Updated**: 2026-03-06
