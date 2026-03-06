# App Audit Agents - Strict Quality Control

## Purpose
Automated agents for comprehensive app auditing with zero tolerance for deviations.

## Agent Structure

### 1. **Code Quality Agent**
**Purpose**: Enforce code standards
**Checks**:
- flutter analyze: 0 errors, 0 warnings
- No unused imports
- No unused variables
- Proper null safety
- Type safety compliance

**Strict Rules**:
- BLOCK any TODO comments in production code
- BLOCK any print() statements
- BLOCK any dynamic types without justification
- BLOCK any force unwrapping (!)

---

### 2. **Performance Agent**
**Purpose**: Enforce performance standards
**Checks**:
- Build times < 5 seconds (incremental)
- App startup < 2 seconds
- Memory usage < 100 MB
- No jank (60 FPS maintained)
- No memory leaks

**Strict Rules**:
- BLOCK any synchronous operations on main thread
- BLOCK any unbounded lists in UI
- BLOCK any unnecessary setState() calls
- BLOCK any image assets without size constraints

---

### 3. **Functionality Agent**
**Purpose**: Verify all features work correctly
**Checks**:
- Metronome starts/stops correctly
- BPM changes work (10-260 range)
- Time signature changes work
- Subdivisions work (1-12)
- Beat modes work (normal/accent/silent)
- Tone settings dialog opens and saves
- Audio plays correctly on all platforms

**Strict Rules**:
- BLOCK any feature that doesn't work on first try
- BLOCK any unhandled exceptions
- BLOCK any missing error states
- BLOCK any broken navigation

---

### 4. **UI/UX Agent**
**Purpose**: Enforce design system compliance
**Checks**:
- Mono Pulse colors used correctly
- Typography scale followed
- Spacing consistent (4-point grid)
- Touch targets ≥ 48px
- Contrast ratios meet WCAG AA

**Strict Rules**:
- BLOCK any hardcoded colors
- BLOCK any hardcoded spacing values
- BLOCK any text without proper style
- BLOCK any buttons < 48px touch target
- BLOCK any low contrast text

---

### 5. **Testing Agent**
**Purpose**: Ensure test coverage
**Checks**:
- All critical paths have tests
- Test pass rate: 100%
- No flaky tests
- Test coverage ≥ 80% for business logic

**Strict Rules**:
- BLOCK any untested critical feature
- BLOCK any failing tests
- BLOCK any tests with TODOs
- BLOCK any tests without assertions

---

### 6. **Security Agent**
**Purpose**: Enforce security best practices
**Checks**:
- No hardcoded secrets
- No sensitive data in logs
- Firebase rules properly configured
- No insecure HTTP connections
- No permission overreach

**Strict Rules**:
- BLOCK any API keys in code
- BLOCK any passwords in code
- BLOCK any print() with sensitive data
- BLOCK any http:// URLs (https only)
- BLOCK any unnecessary permissions

---

## Audit Execution Flow

```
1. Code Quality Agent → Must PASS
2. Security Agent → Must PASS
3. Functionality Agent → Must PASS
4. Performance Agent → Must PASS
5. UI/UX Agent → Must PASS
6. Testing Agent → Must PASS
```

**Any agent failure = AUDIT FAILED**

---

## Task Guardian Integration

All agents MUST use @task-guardian for validation:
- Before any code generation
- Before any plan execution
- Before any recommendations

**Task Guardian validates**:
- No scope creep
- No unauthorized changes
- No fake data
- No alternative suggestions
- No commentary

---

## Audit Report Format

```markdown
# App Audit Report

## Date: [DATE]
## Version: [VERSION]
## Overall Status: PASS/FAIL

### Code Quality Agent
Status: PASS/FAIL
Issues: [LIST]
Severity: [CRITICAL/MAJOR/MINOR]

### Performance Agent
Status: PASS/FAIL
Issues: [LIST]
Severity: [CRITICAL/MAJOR/MINOR]

### Functionality Agent
Status: PASS/FAIL
Issues: [LIST]
Severity: [CRITICAL/MAJOR/MINOR]

### UI/UX Agent
Status: PASS/FAIL
Issues: [LIST]
Severity: [CRITICAL/MAJOR/MINOR]

### Testing Agent
Status: PASS/FAIL
Issues: [LIST]
Severity: [CRITICAL/MAJOR/MINOR]

### Security Agent
Status: PASS/FAIL
Issues: [LIST]
Severity: [CRITICAL/MAJOR/MINOR]

## Summary
Total Issues: [COUNT]
Critical: [COUNT]
Major: [COUNT]
Minor: [COUNT]

## Recommendation
[SHIP/BLOCK/FIX_REQUIRED]
```

---

## Enforcement

**CRITICAL issues**: Immediate BLOCK
**MAJOR issues**: Must be fixed before merge
**MINOR issues**: Should be fixed, documented if deferred

**Zero tolerance for**:
- Security vulnerabilities
- Data loss risks
- Crashes
- Broken critical features

---

## Usage

To run full audit:
```bash
# Run all agents
flutter analyze
flutter test
flutter run --profile # for performance
```

To run specific agent:
```bash
# Code quality
flutter analyze --no-fatal-infos

# Tests
flutter test --coverage

# Performance
flutter run --profile --trace-skia
```

---

**These agents are STRICT. No exceptions. No compromises.**
