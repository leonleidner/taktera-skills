---
name: taktera-time-tracking
description: "taktera Zeiterfassung: Firestore-Modell, Cloud Functions, Mobile/Web Integration, Deploy-Checklist."
---

# taktera Zeiterfassung

## Status
Phases 1-5 erledigt, Phase 6 (Beta/Rollout) offen.

## Preis
1 EUR / aktiver MA / Monat, mindestens 19 EUR / Monat.
(WARNUNG: Im Pricing-Doc steht 29€ flat – Widerspruch!)

## Firestore-Modell

### timeDays (Summary)
Path: `practices/{practiceId}/timeDays/{yyyyMMdd_employeeId}`
- state, clockInAt, clockOutAt, breakMinutes, grossMinutes, netMinutes
- plannedMinutes, deltaMinutes
- warnings[], approvalStatus, lockedAt, approvedAt

### events (Append-only Audit Log)
Path: `practices/{practiceId}/timeDays/{dayId}/events/{eventId}`
- type: clock_in, break_start, break_end, clock_out, correction_request, admin_correction, approval, lock
- clientCreatedAt, serverCreatedAt, actorUid, actorRole, source
- idempotencyKey (min 8 chars)
- ⚠️ Events sind append-only! Keine Updates, keine Deletes.

### config
Path: `practices/{practiceId}/timeTracking/config`
- enabled, timezone, approvalMode, correctionMode
- autoBreakPolicy, roundingPolicy
- exportSettings.csvEnabled, exportSettings.datevEnabled
- datevMapping (regularHoursWageType, overtimeWageType)

## Cloud Functions

| Function | Trigger | Zweck |
|---|---|---|
| `onTimeEventCreated` | Firestore Trigger | Event → Summary berechnen |
| `recalculateTimeDay` | Callable | Summary neu berechnen |
| `unstampedReminder` | Scheduled 60min | Push: "Vergessen auszustempeln?" |
| `monthlyTimeReport` | Callable | Monatsaggregat |
| `lockApprovedMonth` | Callable | Monat sperren |
| `datevExport` | Callable | DATEV Lodas CSV |
| `syncTimeTrackingSeats` | Scheduled täglich | Stripe Quantity Sync |
| `switchPractice` | Callable | Praxis wechseln (Rate Limited) |

## Compliance-Warnungen
- >10h Tagesarbeitszeit
- <30min Pause nach 6h
- <45min Pause nach 9h
- Offener Check-in ohne Check-out
- ⚠️ Ruhezeit <11h zwischen Arbeitstagen FEHLT noch!

## Blockers (Phase 6)
1. Stripe Price + Env Var `STRIPE_PRICE_TIME_TRACKING` anlegen
2. `firebase deploy --only functions`
3. `firebase deploy --only firestore:rules`
4. `firebase deploy --only firestore:indexes`
5. Xcode: Swift-Dateien zum Projekt hinzufügen

## Betroffene Dateien

### taktera-core
- `functions/src/timeTracking.ts` (681 Zeilen)
- `functions/src/index.ts` (Stripe Sync, switchPractice)
- `functions/src/pushUtils.ts` (extrahiert)
- `src/features/time-tracking/TimeTrackingView.tsx`
- `src/types.ts` (TimeDay, TimeEvent Types)
- `firestore.rules` + `firestore.indexes.json`

### taktera-mobile
- `app/(tabs)/time.tsx` (Zeit-Screen)
- `context/EmployeeContext.tsx` (installedApps, timeTrackingEnabled)
- `components/PracticeSwitcher.tsx`
- `components/CustomTabBar.tsx` (konditioneller Zeit-Tab)
- `firestore.rules` + `firestore.indexes.json`

### taktera-ios
- `Models/TimeTracking.swift`
- `ViewModels/TimeTrackingViewModel.swift`
- `Views/TimeTracking/TimeTrackingView.swift`
- `Views/Components/PracticeSwitcherView.swift`
- `Core/Auth/AuthManager.swift`

## Verknüpfungen
- [[TAKTERA_OVERVIEW]]
- [[OWL_CODE_ANALYSIS]]
- [[taktera-testing]]
