---
name: taktera-feature-development
description: "Use when building ANY new feature or bugfix in taktera. Enforces TDD (test-first), gate-based verification (no 'done' without proof), subagent-driven implementation, and design system compliance. Loads taktera-design-system, taktera-core/taktera-swift, and taktera-testing skills automatically. The agent MUST NOT declare work complete without passing all gates."
---

# taktera Feature Development

## Overview

Self-validating feature development process: **Plan → TDD → Implement → Gate → Done**. The agent NEVER declares a feature complete without passing automated verification gates. No exceptions.

**Core principle:** "Done" means "proven to work", not "I think it's done".

## When to Use

- Building any new feature in taktera-core, taktera-mobile, or taktera-ios
- Fixing bugs that need regression tests
- Refactoring that changes behavior
- Adding new UI components
- Adding new Cloud Functions
- Any code change that affects users

## Required Skills (Load These First)

1. **`taktera-design-system`** — Colors, typography, button rules (cursor-pointer!), hover effects
2. **`taktera-core`** — Web app architecture, store patterns, component conventions
3. **`taktera-swift`** — iOS/SwiftUI patterns, mobile-specific conventions
4. **`taktera-testing`** — Playwright E2E, Vitest unit tests, test patterns

## The Process

### Phase 0: Understand & Plan

Before writing ANY code:

```
1. Read relevant existing code (store, components, types)
2. Read relevant Vault docs (feature docs, code overview)
3. Define Test Criteria (what "working" means)
4. Create implementation plan with atomic tasks
5. Each task MUST have: What + How + Test Criteria
```

**Test Criteria Template:**
```
Feature: [Name]
Test Criteria:
- TC1: [Specific observable behavior]
- TC2: [Specific observable behavior]
- TC3: [Edge case]

Verification:
- Unit test: [What to test]
- E2E test: [What user journey to test]
- Manual check: [What to verify in browser/app]
```

### Phase 1: TDD Per Task

For EACH task in the plan:

#### Step 1: Write Failing Test FIRST

```bash
# Unit test (Vitest)
npm test -- --reporter=verbose

# E2E test (Playwright) 
npx playwright test tests/e2e/XX-feature.spec.ts
```

The test MUST fail before implementation. If it passes already, the feature exists or the test is wrong.

#### Step 2: Implement Minimal Code

Write the minimum code to make the test pass. No scope creep.

#### Step 3: Verify Test Passes

```bash
# Run the specific test
npm test -- --reporter=verbose
# or
npx playwright test tests/e2e/XX-feature.spec.ts

# Run full regression
npm test
npm run test:e2e
```

#### Step 4: Gate Check (MANDATORY)

```
GATE CHECKLIST:
  □ Test written BEFORE implementation (TDD)
  □ Test PASSES after implementation
  □ TypeScript compiles: npx tsc --noEmit
  □ Build succeeds: npm run build
  □ No regressions: existing tests still pass
  □ Design system compliance: cursor-pointer, hover effects, brand colors
  □ Code committed: git add -A && git commit -m "..."
```

**If ANY gate fails → Fix and re-check. Do NOT proceed.**

### Phase 2: Subagent Implementation (for complex features)

For features with 3+ tasks, use `delegate_task` with this template:

```python
delegate_task(
    goal="Implement [Task N]: [Description]",
    context="""
    TASK: [Full task description]
    
    TEST CRITERIA:
    - [TC1]
    - [TC2]
    
    TDD PROCESS:
    1. Write failing test first
    2. Run test (verify FAIL)
    3. Implement minimal code
    4. Run test (verify PASS)
    5. Run full test suite (verify no regressions)
    6. Commit
    
    FILES TO MODIFY:
    - [file1]
    - [file2]
    
    DESIGN SYSTEM REQUIREMENTS:
    - All buttons: cursor-pointer + hover effect + transition
    - Colors: use brand-X / slate-X tokens only
    - Font: Inter (web) or system font (mobile)
    - Border-radius: min 12px for buttons
    
    PROJECT CONTEXT:
    - Repo: /Volumes/DevDrive/Projects/taktera-core
    - Store: Zustand slices in src/store/slices/
    - Components: src/components/ui/ for base, src/features/ for feature-specific
    - Types: src/types.ts
    - Tests: tests/e2e/ for E2E, src/lib/*.test.ts for unit
    
    GATE:
    Return the EXACT test output (pass/fail) and git commit hash.
    Do NOT claim "done" without test proof.
    """,
    toolsets=['terminal', 'file']
)
```

### Phase 3: Integration Verification

After ALL tasks complete:

```bash
# 1. Full TypeScript check
npx tsc --noEmit

# 2. Full build
npm run build

# 3. All unit tests
npm test

# 4. All E2E tests (regression)
npm run test:e2e

# 5. New feature E2E test
npx playwright test tests/e2e/XX-feature.spec.ts
```

**Only when ALL pass → Feature is Done.**

### Phase 4: Report

The agent reports with proof:

```
✅ FEATURE COMPLETE: [Name]

Evidence:
- TypeScript: 0 errors
- Build: success
- Unit tests: X/X passing
- E2E tests: X/X passing (0 regressions)
- New test: tests/e2e/XX-feature.spec.ts (X tests, all pass)
- Git: commit abc123f

Changes:
- [file1]: [what changed]
- [file2]: [what changed]
```

## Design System Enforcement

**Every UI change MUST comply with taktera-design-system:**

1. **Buttons**: `cursor-pointer` + hover effect + `transition-all duration-200` — NO exceptions
2. **Colors**: Only `brand-X` and `slate-X` tokens — no arbitrary hex
3. **Typography**: Inter (web) or system font (mobile)
4. **Radii**: Min 12px for buttons, 20px for cards
5. **Shadows**: Use `--shadow-md`, `--shadow-lg`, `--shadow-glass` tokens
6. **Interactive elements**: All clickable items get `cursor-pointer`

## Error Handling

### If Tests Fail After Implementation
1. Analyze failure message
2. Fix root cause (not symptom)
3. Re-run test
4. Re-run full regression
5. Only then proceed

### If Subagent Fails a Task
1. Capture exact error output
2. Dispatch new subagent with: original task + error context + fix instructions
3. Max 3 retries per task, then escalate to human

### If E2E Tests Are Flaky
1. Check if it's a timing issue (increase timeout)
2. Check if it's a test data issue (fix setup)
3. Check if it's a real bug (fix the bug)
4. Never disable tests to make gates pass

## Vault Documentation

After completing a feature, update the Vault:

```
1. Update relevant doc in 02_Areas/Taktera/ (e.g., CODE_FEATURE_*.md)
2. Update CODE_OVERVIEW.md if architecture changed
3. Update FEATURES_OVERVIEW.md if feature status changed
4. Note any new patterns or conventions discovered
```

## Quick Reference

```bash
# Full verification pipeline (run this before declaring done)
npx tsc --noEmit && npm run build && npm test && npm run test:e2e

# Single feature test
npx playwright test tests/e2e/XX-feature.spec.ts --reporter=list

# Unit test watch (during development)
npm run test:watch

# E2E with UI (debugging)
npm run test:e2e:ui
```
