# TD (TODO) Tracker

This file tracks all TODO comments and issues in this Project/Codebase. Items should be added to an appropriate section or category before code can be merged.

## Priority Levels

### ⚠️ High Priority
Issues that affect critical features or prevent major functionality:
- Security vulnerabilities (CVEs, XSS, SQL injection)
- Critical bugs that could break core workflows
- System dependencies that need urgent fixes

### 🟡 Medium Priority
Functional issues that could impact user experience:
- Logic errors in simple business logic flows
- Minor bugs affecting normal operations
- Features not currently in use but need testing coverage

### 🔴 Low Priority
Non-critical items that can be deferred if no blockers exist:
- Linting warnings and style improvements
- Unnecessary optimizations without performance impact
- Bug fixes for edge cases that don't violate principles
- Documentation updates or API changes

## Categories and Sub-categories

### Security & Compliance
```
- ✅ [ ] Fix security vulnerability (CVE #XXXXXX)
- ⚠️ Block TODOs about potential future threats
- ❌ Do not track production code TODOs for now
- 📝 Add security compliance tests to test suite
```

### Performance Optimization
```
- ✅ Optimize memory usage in heavy modules
- 🚀 Reduce load on slow endpoints (e.g., Firebase)
- 🔨 Remove dead code paths (< 5 lines of logic)
- ⏱️ Avoid O(n²) complexity patterns where possible
- 🔧 Pre-populate caches if needed
- 👉 Profile and test before deprecating features
```

### Bug Fixes & Refactoring
```
- 🐛 Fix critical functionality crashes (line 100-200 of buggy code)
- 🔓 Correct existing behavior without breaking anything
- 💡 Suggest refactoring patterns that might be helpful in the future
- ✅ Test changed functionality thoroughly before deploying
- ⏱️ Document when to refactor and why
```

### Code Quality & Style
```
- 🛠️ Linting warnings (format issues, missing braces)
- 👏 Praise clean code, well-tested functions
- 🔎 Add FIXMEs for incomplete edge cases in new areas
- ✨ Suggest improvements only to existing patterns
- 📝 Update test expectations if breaking something
- ✅ Test all modified areas before merging
```

### Feature & Architecture
```
- 🔧 Refactor old architecture into new (not just adding dependencies)
- 👣 Update API contracts or add missing dependencies
- ⏭️ Add documentation for deprecated features to avoid breaking tests
- 🔄 Consider refactoring related code before focusing on one item
- ✅ Ensure backward compatibility with upgrades
```

### Testing & Quality
```
- ✅ Cover the entire module/functionality thoroughly
- 🔍 Identify edge cases, special values, complex scenarios
- ☝️ Add new test coverage for new features that don't exist yet
- 🧪 Create integration tests when refactoring major paths
- ⚖️ Ensure tests explain bugs without just fixing them
- ✅ Write tests before accepting a fix as "done"
```

### Documentation & Deployment
```
- ⚡ Update API docs or migration guide
- 🔍 Verify all changes are covered by existing tests
- 📝 Add README or CHANGELOG entries where applicable
- 🚀 Schedule post-production testing before production deployment
- ✅ Document what the new behavior does versus what it used to do
```

## Guidelines for Adding Items

1. **Add items to TD.md file**: Do not just insert them in comments - log them here.
2. **"First Action" Rule**: Before adding, try to fix the underlying problem or provide context about it first.
3. **No Production TODOs**: Do not add production code changes (like migrations, deployments) to this tracker.
4. **Move Items to TD.md instead**: Use this editor for detailed tracking rather than just inserting into files.
