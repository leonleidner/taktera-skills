---
name: taktera-testing
description: "taktera Testing: Playwright E2E Tests, Vitest Unit Tests, Test-Struktur, Fixtures, Helpers, Firebase Test-Setup."
---

# taktera Testing

## Verwandte Skills

- **`taktera-feature-development`** — TDD Feature Development Process (wann Tests geschrieben werden)
- **`taktera-core`** — Web-App Coding Standards (wo Tests liegen)
- **`taktera-codebase`** — Codebase-Übersicht (Architektur-Kontext)

## Übersicht

Zwei Test-Ebenen:
1. **Vest (Unit Tests)** – `src/lib/*.test.ts`, nur Utils (1.214 Zeilen)
2. **Playwright (E2E Tests)** – `tests/e2e/`, 52 Tests, kompletter User-Journey

## Playwright E2E Tests

### Struktur
```
tests/
├── e2e/
│   ├── global.setup.ts     ← Firebase Test-Data Setup (einmal vor allen Tests)
│   ├── 01-login.spec.ts    ← Login Flow (8 Tests)
│   ├── 02-planner.spec.ts  ← FluentPlanner (11 Tests)
│   ├── 03-dashboard.spec.ts← Dashboard & Navigation (8 Tests)
│   ├── 04-team.spec.ts     ← Teamverwaltung (7 Tests)
│   ├── 05-absences.spec.ts ← Abwesenheitsmanagement (6 Tests)
│   ├── 06-marketplace.spec.ts ← Marketplace (9 Tests)
│   └── 07-lockout.spec.ts  ← Abo-Sperre (3 Tests)
├── fixtures/
│   └── test-data.ts        ← Test-Konstanten (Practice ID, User Credentials)
└── helpers/
    └── auth.ts             ← Login/Logout Helpers (zweistufiger Flow)
```

### Test-Daten
- Praxis-ID: `test-praxis`
- Admin: `admin@test-praxis.taktera.de` / `TestPassword123!`
- Mitarbeiter: `mitarbeiter@test-praxis.taktera.de` / `TestPassword123!`
- Behandler: `dr-mueller@test-praxis.taktera.de` / `TestPassword123!`

### Ausführen
```bash
cd /Volumes/DevDrive/Projects/taktera-core
npm run test:e2e              # Alle Tests
npm run test:e2e:ui           # Mit UI (Debug)
npm run test:e2e:headed       # Browser sichtbar
npx playwright test tests/e2e/01-login.spec.ts  # Einzelne Datei
```

### Konfiguration (`playwright.config.ts`)
- Base URL: `http://localhost:5173` (oder `BASE_URL` env var)
- Browser: Chromium + Firefox
- Timeouts: 60s Test, 10s Expect, 15s Action
- Screenshots: `only-on-failure`
- Video: `retain-on-failure`
- Web Server: `npm run dev` auf Port 5173

## Test-Patterns für taktera

### Zweistufiger Login-Flow
Alle Tests mit Auth müssen den zweistufigen Flow beachten:
1. Praxis-ID eingeben → Weiter klicken
2. E-Mail + Passwort → Einloggen klicken

Helper in `tests/e2e/helpers/auth.ts`:
```typescript
await login(page, {
  email: 'admin@test-praxis.taktera.de',
  password: 'TestPassword123!',
});
```

### Firestore-Tests
- Tests laufen **gegen echte Firestore-Daten** (dev Projekt)
- Tests laufen **sequenziell** (nicht parallel) wegen Firestore-Operationen
- Test-Daten werden im `global.setup.ts` erstellt (Firebase Admin SDK)
- Voraussetzung: `FIREBASE_SERVICE_ACCOUNT` env var

### Selektor-Strategie
- **Bevorzugt**: `getByRole()`, `getByText()`, `getByLabel()` (accessibility-first)
- **Fallback**: CSS-Klassen mit `or()` Kette für dynamische Klassen
- **Drag & Drop**: `element.dragTo(target)` – funktioniert mit @dnd-kit

### Bekannte Einschränkungen
1. **Drag & Drop**: @dnd-kit D&D ist schwer zu testen – Test versucht es, kann nicht garantieren
2. **Stripe Checkout**: Kostenpflichtige Apps leiten zu Stripe weiter – Test prüft nur Redirect/Dialog
3. **Keine automatische Aufräumung**: Test-Daten bleiben in Firestore

## Vitest Unit Tests

### Ausführen
```bash
npm test                      # Alle Unit Tests
npm run test:watch            # Watch Mode
```

### Struktur
- Nur in `src/lib/*.test.ts`
- 5 Test-Dateien: holidays, vacationUtils, workHoursUtils, utils, responsive
- Keine Tests für Store, Cloud Functions, Feature-Komponenten

## Neuen Test erstellen

1. Test-Datei in `tests/e2e/` erstellen (Nummerierung fortsetzen)
2. `test.describe()` mit beschreibendem Namen
3. `test.beforeEach()` für Login + Navigation
4. Tests mit `test()` und aussagekräftigen Namen
5. Role-based Selektoren verwenden
6. Timeouts großzügig (15-60s für Firestore)

## Verknüpfungen
- [[taktera-codebase]]
- [[taktera-deploy]]
- [[OWL_CODE_ANALYSIS]]

## Support Files
- `references/test-patterns.md` – Playwright Selektor-Patterns, Login Flow, Drag & Drop, Firestore-Wait-Patterns
- `templates/test-template.spec.ts` – Vorlage für neue Test-Dateien
