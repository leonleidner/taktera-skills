---
name: taktera-codebase
description: "taktera Codebase-Wissen: Architektur, Struktur, Deploy, Debugging für taktera-core (Web), taktera-mobile (Expo), Cloud Functions und iOS."
---

# taktera Codebase

## Verwandte Skills

- **`taktera-core`** — Web-App Coding Standards (React/TS/Zustand Patterns)
- **`taktera-swift`** — iOS/SwiftUI Coding Standards
- **`taktera-feature-development`** — TDD Feature Development Process
- **`taktera-design-system`** — Design Tokens & UI-Komponenten
- **`taktera-testing`** — Test-Struktur & Patterns

## Repositorien

| Repo | Pfad | Zweck |
|---|---|---|
| taktera-core | `/Volumes/DevDrive/Projects/taktera-core` | Web-App (app.taktera.de) |
| taktera-mobile | `/Volumes/DevDrive/Projects/taktera-mobile` | Mobile App (Expo SDK 54) |
| taktera-landing | `/Volumes/DevDrive/Projects/taktera-landing` | Landing Page (taktera.de) |
| Vault | `/Volumes/DevDrive/taktera-vault/taktera` | Obsidian Vault (Docs) |

**Wichtig**: DevDrive muss gemounted sein (`/Volumes/DevDrive`). Prüfen mit `ls /Volumes/DevDrive`.

## taktera-core (Web-App)

### Tech-Stack
- React 19 + TypeScript + Vite + Tailwind CSS 4
- Zustand (7-Slice-Architektur) in `src/store/slices/`
- Firebase (Auth, Firestore, Functions v2, Vertex AI)
- @dnd-kit für Drag & Drop
- Framer Motion für Animationen
- React Router v7 mit Lazy Loading

### Store-Architektur
- `src/store/clinicStore.ts` – Hauptstore (317 Zeilen)
- Slices: `planSlice` (739!), `employeeSlice` (230), `absenceSlice` (143), `roomSlice` (85), `roleSlice` (29), `announcementSlice` (34)
- ⚠️ `timeTrackingSlice` FEHLT – Zeiterfassung hat keinen eigenen Slice
- Dual-Layer: `assignmentsByDate` (Firestore) + `draftAssignmentsByDate` (Zustand)

### Wichtige Dateien
- `src/App.tsx` – Router mit Lazy Loading
- `src/store/slices/planSlice.ts` – Plan-State (739 Zeilen, komplex!)
- `src/components/ai/AiChatWidget.tsx` – KI Chat (609 Zeilen)
- `src/features/time-tracking/TimeTrackingView.tsx` – Zeiterfassung Admin-View
- `src/config/marketplace.ts` – Marketplace-App-Registry
- `src/types.ts` – Globale Types
- `functions/src/index.ts` – Cloud Functions Entry (2338 Zeilen)
- `functions/src/timeTracking.ts` – Zeiterfassung Functions (681 Zeilen)
- `functions/src/praxisAiTools.ts` – KI Tools (~900 Zeilen)
- `functions/src/praxisAiGemini.ts` – Gemini Orchestrierung (~600 Zeilen)

### Firestore-Struktur
```
practices/{practiceId}                    ← Praxis-Dokument
  ├── plannerConfig, providerOrder, installedApps, subscriptionStatus
  └── roles/{roleId}
plans/{practiceId}/days/{date}            ← Tages-Plan (assignments, published)
plans_meta/{practiceId}_{date}            ← Published-Metadaten
employees/{employeeId}                    ← Mitarbeiter (practiceId, isProvider)
rooms/{roomId}                            ← Räume
practices/{practiceId}/absences/{id}      ← Abwesenheiten
practices/{practiceId}/announcements/{id}  ← Ankündigungen
users/{uid}                               ← Benutzer
timeDays/{yyyyMMdd_employeeId}            ← Zeiterfassung Summary
timeDays/{...}/events/{eventId}           ← Zeiterfassung Events (append-only)
timeMonths/{yyyyMM_employeeId}            ← Monatsaggregat
practices/{practiceId}/timeTracking/config ← Zeiterfassung Config
```

### Deploy
```bash
# Web-App build + deploy
cd /Volumes/DevDrive/Projects/taktera-core
npm run build
firebase deploy -P dev        # Development
firebase deploy -P default    # Production

# Nur Functions
firebase deploy --only functions

# Nur Rules/Indexes
firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
```

### Tests

#### Vitest (Unit Tests)
```bash
npm test                      # Vitest (nur Utils, 1.214 Zeilen)
npm run test:watch            # Watch Mode
```
⚠️ Keine Tests für Store, Cloud Functions oder Feature-Komponenten!

#### Playwright (E2E Tests)
```bash
npm run test:e2e              # Alle E2E Tests
npm run test:e2e:ui           # Mit UI (Debug)
npm run test:e2e:headed       # Browser sichtbar
npm run test:e2e:debug        # Debug-Modus
```
Test-Dateien in `tests/e2e/`:
- `01-login.spec.ts` – Login Flow (8 Tests)
- `02-planner.spec.ts` – FluentPlanner (11 Tests)
- `03-dashboard.spec.ts` – Dashboard & Navigation (8 Tests)
- `04-team.spec.ts` – Teamverwaltung (7 Tests)
- `05-absences.spec.ts` – Abwesenheitsmanagement (6 Tests)
- `06-marketplace.spec.ts` – Marketplace (9 Tests)
- `07-lockout.spec.ts` – Abo-Sperre (3 Tests)

**Gesamt: 52 E2E-Tests**

Test-Helpers in `tests/e2e/helpers/auth.ts` (Login/Logout Flow)
Test-Fixtures in `tests/fixtures/test-data.ts` (Test-Konstanten)
Global Setup in `tests/e2e/global.setup.ts` (Firestore Test-Daten)

### Bekannte Probleme
- `package.json` Name ist `"zahntakt-dashboard"` (altes Naming)
- Auto-Logout: Code hat 4h, SOUL.md sagt 30min
- Keine CI/CD Pipeline (geplant, nicht implementiert)
- Analytics Pro + TerminRetter kostenlos (killen AI Pro Upsell)

## taktera-mobile (Expo)

### Tech-Stack
- Expo SDK 54 + React Native + TypeScript
- React Context + Hooks (kein Zustand)
- Firestore mit `persistentLocalCache` (Offline)
- Expo Push Notifications

### Architektur
```
app/(tabs)/
  ├── index.tsx    ← Home (18.877 Zeilen ⚠️ MONOLITH)
  ├── two.tsx      ← Dienstplan (35.214 Zeilen ⚠️ MONOLITH)
  ├── three.tsx    ← Abwesenheiten (27.115 Zeilen ⚠️ MONOLITH)
  └── four.tsx     ← Chat/Profil (18.877 Zeilen ⚠️ MONOLITH)
components/
  ├── CustomTabBar.tsx
  └── PracticeSwitcher.tsx
context/
  └── EmployeeContext.tsx
```

### ⚠️ KRITISCH: Mobile Monolithen
Die Tab-Screens sind 18k-35k Zeilen groß! Muss refactored werden.

### iOS (taktera-ios)
- Swift/SwiftUI Code liegt in `taktera-ios/` aber **Swift-Dateien nicht im Repo**
- Nur Xcode-Projekt-Dateien committed
- Muss lokal auf Mac bearbeitet werden

### Deploy
```bash
cd /Volumes/DevDrive/Projects/taktera-mobile
eas build --platform ios
eas build --platform android
eas update                    # OTA Update
```

## Cloud Functions

### Region
Alle Functions in `europe-west3` (Frankfurt)

### Wichtige Functions
| Function | Trigger | Zweck |
|---|---|---|
| `onTimeEventCreated` | Firestore Trigger | Zeiterfassung: Event → Summary |
| `recalculateTimeDay` | Callable | Zeiterfassung: Summary neu berechnen |
| `unstampedReminder` | Scheduled (60min) | Push: "Vergessen auszustempeln?" |
| `monthlyTimeReport` | Callable | Monatsaggregat erstellen |
| `lockApprovedMonth` | Callable | Monat sperren |
| `datevExport` | Callable | DATEV Lodas CSV Export |
| `syncTimeTrackingSeats` | Scheduled (täglich) | Stripe Quantity Sync |
| `switchPractice` | Callable | Praxis wechseln (Rate Limited) |
| `approveVacation` | Callable | Urlaub genehmigen |
| `runPraxisAssistent` | Callable | KI Assistent |

### Environment Variables
```
STRIPE_PRICE_CORE_MONTHLY
STRIPE_PRICE_CORE_YEARLY
STRIPE_PRICE_AI_PRO
STRIPE_PRICE_TIME_TRACKING    ← FEHLT (Blocker!)
```

## Vault (Dokumentation)

### Struktur
```
01_Projects/          ← Projekte (CICD, Launch, MultiPraxis)
02_Areas/             ← Areas (Finanzen, Legal, Ops, Taktera)
03_Resources/         ← Resources (FeatureDevelopment)
04_Archive/           ← Archiv
05_AI_Agents/         ← AI Agents (Company, Prompts, Routinen, Skills)
```

### Wichtige Docs
- `02_Areas/Taktera/TAKTERA_OVERVIEW.md` – Produktvision
- `02_Areas/Taktera/FEATURES_OVERVIEW.md` – Feature-Übersicht
- `02_Areas/Taktera/CODE_OVERVIEW.md` – Code-Übersicht
- `02_Areas/Taktera/CODE_STORES.md` – Store-Dokumentation
- `02_Areas/Taktera/AI_DRAFT_MODE.md` – KI Draft Mode
- `02_Areas/Taktera/OWL_CODE_ANALYSIS.md` – OWL Code-Analyse

## Workflow: Änderungen machen

1. **Code lesen** → Verstehen was ist
2. **Änderung planen** → Kurz notieren
3. **Implementieren** → Code schreiben
4. **Testen** → `npm test` / manuell
5. **Deploy** → `firebase deploy`
6. **Dokumentieren** → Vault aktualisieren

## Workflow: Bug Fix

1. Bug reproduzieren
2. Root Cause finden (Store? Component? Function?)
3. Fix implementieren
4. Test schreiben (wenn möglich)
5. Deploy
6. In Vault dokumentieren

## Workflow: Neues Feature

1. Feature-Doc in Vault erstellen (unter `02_Areas/Taktera/`)
2. Types in `src/types.ts` erstellen
3. Store-Slice erstellen (wenn nötig)
4. UI implementieren
5. Cloud Functions (wenn nötig)
6. Tests schreiben
7. Deploy
8. Vault aktualisieren
