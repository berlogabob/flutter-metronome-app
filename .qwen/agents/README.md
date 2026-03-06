# Agent System for RepSync / FlowGroove Metronome

Autonomous AI agents that drive development, testing, and release of the Flutter metronome app.

## 📊 Agent Categories

### 🎯 Coordination & Planning
| Agent | Purpose | Status |
|-------|---------|--------|
| **mr-sync** | Main coordinator, merge conflicts | ✅ Active |
| **mr-planner** | Task decomposition, sprint planning | ✅ Active |
| **mr-architect** | System design, architecture validation | ✅ Active |
| **creative-director** | UX flow, creative direction | ✅ Active |

### 🔧 Development
| Agent | Purpose | Status |
|-------|---------|--------|
| **mr-senior-developer** | Code review, best practices | ✅ Active |
| **mr-cleaner** | Refactoring, optimization, code quality | ✅ Active |
| **mr-tester** | Unit tests, integration tests, coverage | ✅ Active |
| **mr-logger** | Logging standards, debug output | ✅ Active |

### 🎨 UI/UX
| Agent | Purpose | Status |
|-------|---------|--------|
| **mr-ux-agent** | UI implementation, theme compliance | ✅ Active |
| **widget-guardian** | Widget architecture, performance, reusability | ✅ NEW |
| **app-audit-agents** | Comprehensive app auditing, quality control | ✅ NEW |

### 📱 Platform & Release
| Agent | Purpose | Status |
|-------|---------|--------|
| **mr-android** | Android-specific debugging, builds | ✅ Active |
| **mr-android-debug** | Android crash analysis, logcat | ✅ Active |
| **mr-release** | Release orchestration, versioning | ✅ Active |
| **mr-sync** | Repository sync, remote management | ✅ Active |

### 🛡️ Quality Assurance
| Agent | Purpose | Status |
|-------|---------|--------|
| **task-guardian** | Instruction fidelity, scope enforcement | ✅ Active |
| **mr-stupid-user** | User perspective, edge cases | ✅ Active |

---

## 🏗️ Hierarchy

```
mr-sync (Coordinator)
├── mr-planner (Task decomposition)
│   ├── mr-architect (Design validation)
│   └── creative-director (UX flow)
├── mr-senior-developer (Code review)
├── mr-cleaner (Refactor & optimization)
├── mr-tester (Testing)
├── mr-logger (Logging)
├── mr-ux-agent (UI implementation)
├── widget-guardian (Widget quality) ← NEW
├── app-audit-agents (App auditing) ← NEW
├── mr-android (Mobile debug)
├── mr-android-debug (Crash analysis)
└── mr-release (Release orchestration)
```

---

## 🚀 Usage

### 1. Request Work
```bash
# Assign task to specific agent
@agent mr-planner Design song structure editor

# Use guardian agents for validation
@task-guardian Validate this implementation

# Use widget guardian for widget quality
@widget-guardian Review this widget architecture
```

### 2. Agents Collaborate
Each agent produces **GOST-formatted** output (Guided Output Structure Template).

### 3. Coordinator Merges
`mr-sync` ensures no conflicts between agent outputs.

### 4. Verify
All changes tested before merge to main branch.

---

## 📋 Rules

- ✅ All agents follow **GOST format** (Guided Output Structure Template)
- ✅ No direct code modification — only recommendations
- ✅ Critical issues block releases
- ✅ Versioning: `MAJOR.MINOR.PATCH+BUILD` (build auto-increments)
- ✅ **widget-guardian** must approve all widget changes
- ✅ **app-audit-agents** run before major releases
- ✅ **task-guardian** validates scope on all tasks

---

## 🎯 Guidelines

### Modularity
- Extract components if used ≥3 times
- Single Responsibility Principle enforced
- Maximum widget size: 300 lines

### Consistency
- Theme colors: `MonoPulseColors` only
- Spacing: `MonoPulseSpacing` 4-point grid
- Typography: `MonoPulseTypography` scale
- Components: Reusable, configurable

### Fail-Safe
- All features must work offline first
- Firebase sync is secondary
- No hardcoded values

### Performance
- Widgets must be const where possible
- No setState for global state
- Granular rebuilds with Riverpod
- 60 FPS maintained

---

## 🆕 New Agents

### widget-guardian
**Purpose**: Enforce widget architecture standards

**Responsibilities**:
- Block widgets > 300 lines
- Enforce component separation
- Require const constructors
- Validate Semantics usage
- Ensure reusability

**Triggers**:
- Any new widget file
- Widget refactoring
- Performance issues

### app-audit-agents
**Purpose**: Comprehensive app quality auditing

**Responsibilities**:
- Code quality checks
- Security vulnerability scanning
- Accessibility compliance
- Performance profiling
- Documentation coverage

**Triggers**:
- Before major releases
- Sprint completion
- User-reported issues

---

## 📊 Agent Status Summary

| Category | Agents | New | Active |
|----------|--------|-----|--------|
| Coordination | 4 | 0 | 4 |
| Development | 4 | 0 | 4 |
| UI/UX | 3 | 2 | 3 |
| Platform/Release | 4 | 0 | 4 |
| Quality Assurance | 2 | 0 | 2 |
| **TOTAL** | **17** | **2** | **17** |

---

> Built with ❤️ for musicians and cover bands  
> Repository: [flutter-flowgroove-app-metronome](https://github.com/berlogabob/flutter-flowgroove-app-metronome)
