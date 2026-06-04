# taktera-skills

Hermes Agent Skills für das taktera SaaS Projekt. Enthält Coding Standards, Design System, TDD-Workflows und Codebase-Dokumentation für taktera-core (Web), taktera-mobile (Expo/iOS) und Cloud Functions.

## Struktur

```
skills/
├── taktera-feature-development/  # TDD + Gate-basierter Feature-Entwicklung (START HIER)
├── taktera-design-system/        # Design Tokens: Farben, Typo, UI-Komponenten
├── taktera-core/                 # Web-App Coding Standards (React/TS/Zustand)
├── taktera-swift/                # iOS/SwiftUI Coding Standards
├── taktera-testing/              # Test-Struktur: Playwright E2E, Vitest Unit
├── taktera-codebase/             # Codebase-Übersicht: Architektur, Deploy, Debugging
├── taktera-deploy/               # Deploy-Workflow: Build, Test, Firebase Deploy
├── taktera-ai/                   # KI-System: Gemini-Assistent, Draft Mode
└── taktera-time-tracking/        # Zeiterfassung: Firestore-Modell, Functions
```

## Installation

### Option A: Symlink (empfohlen)

Skills werden verlinkt, Änderungen im Repo sind sofort in Hermes verfügbar:

```bash
./install.sh
```

### Option B: Kopieren

```bash
cp -r skills/* ~/.hermes/skills/taktera/
```

## Skill-Nutzung

Die Skills werden automatisch geladen wenn du OWL (Hermes Agent) um etwas bittest:

- **Neues Feature bauen** → lädt `taktera-feature-development` + `taktera-design-system` + `taktera-core`/`taktera-swift`
- **UI bauen/ändern** → lädt `taktera-design-system`
- **Tests schreiben** → lädt `taktera-testing`
- **iOS Code** → lädt `taktera-swift`
- **Web Code** → lädt `taktera-core`

## Design System Highlights

- **Farben**: Brand (Teal/Cyan) + Slate Neutrals als Tailwind-Tokens
- **Buttons**: IMMER `cursor-pointer` + Hover-Effekt + `transition-all duration-200`
- **Typografie**: Systemfont (SF Pro/Inter Fallback)
- **Radii**: min 12px Buttons, 20px Cards

## TDD Workflow

1. Plan mit Test-Kriterien pro Task
2. Test schreiben (muss FAILEN)
3. Minimal-Implementation
4. Test muss PASSEN
5. Gate: TS + Build + Tests + Design System
6. Erst dann "Done"

## Verwandte Repos

| Repo | Pfad | Zweck |
|------|------|-------|
| taktera-core | `/Volumes/DevDrive/Projects/taktera-core` | Web-App |
| taktera-mobile | `/Volumes/DevDrive/Projects/taktera-mobile` | Mobile App |
| Vault | `/Volumes/DevDrive/taktera-vault/taktera` | Obsidian Docs |

## Contributing

Wenn du neue Patterns in der Codebase findest:
1. Entsprechenden Skill aktualisieren
2. Datum + Kontext als Kommentar hinzufügen
3. Commit + Push
