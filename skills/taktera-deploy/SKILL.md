---
name: taktera-deploy
description: "taktera Deploy-Workflow: Build, Test, Firebase Deploy für Web, Mobile, Functions, Rules, Indexes."
---

# taktera Deploy

## Voraussetzungen

- DevDrive gemounted: `ls /Volumes/DevDrive`
- Firebase CLI installiert: `firebase --version`
- Node.js + npm
- Für iOS: Xcode, EAS CLI

## taktera-core (Web-App)

### Build
```bash
cd /Volumes/DevDrive/Projects/taktera-core
npm install              # Bei neuen Dependencies
npm run build            # TypeScript check + Vite build
```

### Tests
```bash
npm test                 # Vitest (Utils only)
```

### Deploy
```bash
# Alles (Hosting + Functions + Rules + Indexes)
firebase deploy -P dev        # Development
firebase deploy -P default    # Production

# Nur bestimmte Teile
firebase deploy --only hosting
firebase deploy --only functions
firebase deploy --only firestore:rules
firebase deploy --only firestore:indexes
```

### Environment Variables
```bash
# .env für lokale Entwicklung
# .env.production für Production
# Wichtig: VITE_ Prefix für Client-seitige Vars
```

## taktera-mobile (Expo)

### Build
```bash
cd /Volumes/DevDrive/Projects/taktera-mobile
npm install

# iOS Build
eas build --platform ios

# Android Build
eas build --platform android

# OTA Update (kein Store-Update nötig)
eas update --branch production
```

### Lokal testen
```bash
npx expo start
```

## Cloud Functions

### Lokal testen
```bash
cd /Volumes/DevDrive/Projects/taktera-core
firebase emulators:start --only functions
```

### Deploy
```bash
cd /Volumes/DevDrive/Projects/taktera-core
firebase deploy --only functions
```

### Functions Logs
```bash
firebase functions:log
firebase functions:log --only onTimeEventCreated
```

## Firestore Rules

### Deploy
```bash
cd /Volumes/DevDrive/Projects/taktera-core
firebase deploy --only firestore:rules
```

### Emulator testen
```bash
firebase emulators:start --only firestore
```

## Firestore Indexes

### Deploy
```bash
cd /Volumes/DevDrive/Projects/taktera-core
firebase deploy --only firestore:indexes
```

⚠️ Index-Deploy kann bei großen Collections dauern!

## iOS (Swift)

### Voraussetzung
- Xcode installiert
- Apple Developer Account
- Provisioning Profiles konfiguriert

### Build
```bash
cd /Volumes/DevDrive/Projects/taktera-mobile
# Xcode öffnen
open taktera-ios/Taktera.xcodeproj
```

### EAS Build
```bash
eas build --platform ios --profile production
```

## E2E Tests (Playwright)

### Ausführen
```bash
cd /Volumes/DevDrive/Projects/taktera-core

# Alle Tests
npm run test:e2e

# Mit UI (Debug)
npm run test:e2e:ui

# Headed (Browser sichtbar)
npm run test:e2e:headed

# Debug-Modus
npm run test:e2e:debug
```

### Test-Setup (einmalig)
```bash
npm install -D @playwright/test
npx playwright install chromium firefox
```

### Test-Daten
Test-Daten werden im `global.setup.ts` automatisch in Firestore angelegt.
Voraussetzung: `FIREBASE_SERVICE_ACCOUNT` env var gesetzt.

## Rollback

### Hosting Rollback
```bash
firebase hosting:rollback
```

### Functions Rollback
```bash
# Manuell: Alte Version redeployen
firebase deploy --only functions
```

## Bekannte Deploy-Probleme

1. **Index-Deploy fehlschlägt**: Collection Group Indexe brauchen Zeit
2. **Functions Timeout**: Max 10 Instanzen, ggf. erhöhen
3. **EAS Build fehlschlägt**: Provisioning Profile prüfen
4. **Env Vars fehlen**: `.env` vs `.env.production` prüfen
