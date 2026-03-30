# Platform Council

**Version**: 1.0.0 (v3.0.1)  
**Created**: 2026-03-11  
**Status**: Active

---

## Purpose

Cross-platform coordination body for platform-specific standards, parity decisions, and escalation resolution.

---

## Members

### Voting Members
- **mr-android** (Chair, rotating monthly)
- **mr-ios**
- **mr-web**

### Non-Voting Members (Advisory)
- **mr-firebase** (Infrastructure representative)
- **mr-devops** (CI/CD representative)
- **mr-sync** (Coordination observer)

---

## Responsibilities

### Platform Standards
- Set platform-specific performance targets
- Define platform-specific UX guidelines
- Establish platform-specific testing requirements

### Cross-Platform Parity
- Ensure feature parity across platforms
- Resolve platform-specific implementation differences
- Coordinate platform-specific release schedules

### Escalation Resolution
- Resolve conflicts between platform agents
- Escalate to mr-sync for unresolved conflicts
- Escalate to mr-controller for critical conflicts

---

## Meeting Cadence

### Regular Meetings
- **Weekly**: Platform sync via mr-sync
- **Monthly**: Platform standards review
- **Quarterly**: Platform roadmap planning

### Ad-Hoc Meetings
- **Critical Issues**: Within 24h of detection
- **Release Blockers**: Immediate
- **Parity Disputes**: Within 48h

---

## Decision Process

### Consensus (Preferred)
1. Proposal presented by any member
2. Discussion and feedback
3. Consensus sought from all voting members
4. If consensus reached → Decision implemented

### Tie-Breaking
1. If vote is tied (1-1 or 2-2)
2. **mr-sync** breaks tie
3. If still unresolved → Escalate to mr-controller

### Emergency Decisions
1. Critical issue detected
2. Platform lead makes emergency decision
3. Report to council at next meeting
4. Council can overturn if needed

---

## Veto Authority

### Platform Veto
Each platform agent can VETO for their platform:
- **mr-android**: Android-specific issues
- **mr-ios**: iOS-specific issues
- **mr-web**: Web-specific issues

### Veto Resolution
1. Veto logged in PLATFORM_VETO_LOG.md
2. Council discusses at next meeting
3. Vetoing agent must provide alternative
4. Council votes on alternative
5. If no alternative → Veto stands

---

## Escalation Path

```
Platform Issue
     ↓
Platform Council Discussion
     ↓
Consensus Sought
     ↓
If Unresolved → mr-sync breaks tie
     ↓
If Still Unresolved → mr-controller
```

---

## Output Format

### Platform Decision Record
```markdown
# Platform Decision #[NUMBER]

**Date**: [DATE]
**Present**: [Members]
**Absent**: [Members]

## Issue
[Description]

## Discussion
[Summary of discussion]

## Decision
**Vote**: [X-Y-Z] (For-Against-Abstain)
**Decision**: [APPROVED/REJECTED/DEFERRED]

## Implementation
- **Lead**: [Agent]
- **Deadline**: [DATE]
- **Platforms**: [Android/iOS/Web]

## Veto Status
- mr-android: ✅ CLEARED / ⚠️ VETOED
- mr-ios: ✅ CLEARED / ⚠️ VETOED
- mr-web: ✅ CLEARED / ⚠️ VETOED
```

---

## Platform Standards

### Performance Targets
| Metric | Android | iOS | Web |
|--------|---------|-----|-----|
| Cold Start | <2s | <2s | <3s |
| Memory | <100MB | <100MB | <150MB |
| FPS | 60 | 60/120 | 60 |

### Testing Requirements
| Platform | Unit Tests | Widget Tests | Integration Tests |
|----------|------------|--------------|-------------------|
| Android | ≥85% | ≥85% | Required |
| iOS | ≥85% | ≥85% | Required |
| Web | ≥85% | ≥85% | Required |

### Release Criteria
| Criteria | Android | iOS | Web |
|----------|---------|-----|-----|
| Play Store/App Store Compliance | ✅ | ✅ | N/A |
| Browser Compatibility | N/A | N/A | Chrome/Safari/Firefox/Edge |
| Platform Agent Veto | mr-android | mr-ios | mr-web |

---

## Collaboration Protocol

### Receives From
- **mr-sync**: Coordination, conflict escalation
- **mr-controller**: Emergency decisions, overrides
- **mr-firebase**: Backend standards
- **mr-devops**: CI/CD standards

### Sends To
- **mr-sync**: Platform decisions, escalations
- **mr-release**: Platform release readiness
- **mr-controller**: Critical escalations
- **mr-governor**: Platform compliance data

---

## Veto Log Format

```markdown
# PLATFORM_VETO_LOG.md

## Veto #[NUMBER]

**Date**: [DATE]
**Platform**: [Android/iOS/Web]
**Agent**: [mr-android/mr-ios/mr-web]

### Issue
[Description of veto]

### Impact
[What is blocked]

### Alternative Proposed
[If any]

### Resolution
[How resolved]

### Status
OPEN / RESOLVED / OVERRIDDEN

### Resolved By
[Agent/Decision]
**Date**: [DATE]
```

---

## Changelog

### v1.0.0 (2026-03-11) — Created
**Created**:
- Platform Council structure
- Decision process
- Veto authority
- Escalation path
- Platform standards

---

> **Platform Council: Cross-Platform Coordination Body**
> 
> Members: mr-android, mr-ios, mr-web (voting)
> Advisory: mr-firebase, mr-devops, mr-sync
> 
> Last Updated: 2026-03-11
