---
name: taktera-ai
description: "taktera KI-System: Gemini-basierter Assistent, Draft Mode, Write-Tools, praxisAiTools, praxisAiGemini."
---

# taktera KI-System

## Übersicht

taktera hat zwei KI-Systeme:
1. **AI Pro** (Web, Marketplace-Add-on, 29€/Mo) – Vertex AI, Admin-only
2. **KI-Assistent** (Mobile, Admin-only) – Gemini 3.1 Flash Lite

## KI Draft Mode (Web)

### Warum Draft Mode?
KI-gesteuerte Schichtänderungen landen **nicht direkt in Firestore**, sondern als lokale Entwürfe im Zustand Store. Der User behält volle Kontrolle.

### Dual-Layer-Architektur
```
assignmentsByDate        → Firestore (gespeichert)
draftAssignmentsByDate   → Zustand Store (lokale Entwürfe)
unsavedChanges           → Trackt ungespeicherte Änderungen
```

### Ablauf
1. **Aktivierung**: Web-Clients senden `webContext` → Draft Mode aktiv
2. **Backend** (`praxisAiTools.ts`): Schicht-Tools mit `draftMode = true`
3. **DraftInstruction**: Statt Firestore-Write wird Instruction zurückgegeben
4. **Gemini** (`praxisAiGemini.ts`): Sammelt Instructions, gibt sie im Result zurück
5. **Frontend** (`AiChatWidget.tsx`): Wendet Instructions via `assignEmployee`/`unassignEmployee` auf Zustand Store an

### DraftInstruction Format
```typescript
interface DraftInstruction {
  action: "add" | "remove";
  date: string;          // "2026-06-02"
  slotKey: string;       // "behandlerId::slot-0800"
  employeeId: string;    // "abc123"
  time: string;          // "08:00"
}
```

### Slot-Format
- **cellKey**: `{behandlerId}::{slotId}` → z.B. `dr_mueller_id::slot-0830`
- **slotId**: `slot-HHMM` in 30-Min-Intervallen

### Bulk-Tools
- `bulkRemoveShifts`: Entfernt Mitarbeiter aus allen Schichten eines Tages
- `bulkAddShifts`: Fügt mehrere Mitarbeiter zu allen 30-Min-Slots eines Behandlers hinzu

### Betroffene Dateien
| Datei | Rolle |
|---|---|
| `functions/src/praxisAiTools.ts` | `manageShift()`, `bulkRemoveShifts()`, `bulkAddShifts()` mit `draftMode` |
| `functions/src/praxisAiGemini.ts` | Sammelt `DraftInstruction`s, gibt sie im Result zurück |
| `functions/src/index.ts` | Leitet `draftInstructions` an Client weiter |
| `src/components/ai/AiChatWidget.tsx` | Wendet Instructions via Zustand Actions an |

## KI Write Confirmation

Write-Tools (Daten ändern) brauchen eine Bestätigung vom User:
1. KI gibt `confirmationRequired: true` + `preview` zurück
- User sieht Preview der Änderung
- User bestätigt oder verwirft
- Erst dann wird die Änderung ausgeführt

### Write-Tools
| Tool | Beschreibung |
|---|---|
| `addAnnouncement` | Ankündigung erstellen |
| `addAbsence` | Abwesenheit eintragen |
| `manageShift` | Schicht hinzufügen/entfernen |
| `publishPlans` | Pläne veröffentlichen |

### Read-Tools
| Tool | Beschreibung |
|---|---|
| `getEmployees` | Mitarbeiterliste |
| `getAbsences` | Urlaub/Krankheit |
| `getEvents` | Dienstplan |
| `getAnnouncements` | Ankündigungen |

## Mobile KI-Assistent

### Tech
- Gemini 3.1 Flash Lite
- Chat-Oberfläche: WhatsApp-Style mit Markdown-Rendering
- @Mention-System: Tippe `@` → Mitarbeiterliste

### Limits
- Monatliches Anfragenlimit pro Praxis (Standard: 100)
- Usage-Tracking in Firestore
- Nur Admins (Auth + Claims Check)
- Alle Queries auf `practiceId` beschränkt

## AI Pro (Vertex AI)

### Tech
- Firebase Vertex AI Integration
- Nur Admins
- Preis: 29€/Monat pro Praxis (Flat)

### Kosten
- ~5-15€/Monat pro Praxis (Vertex AI Usage)
- Marge: ~14-24€/Monat pro Praxis

## Bekannte Probleme

1. **Analytics Pro + TerminRetter kostenlos** – Killen AI Pro Upsell
2. **KI monthly limit 100** – Könnte für große Praxen zu niedrig sein
3. **Keine KI-Tests** – Weder Tools noch Gemini-Orchestrierung getestet

## Verknüpfungen

- [[AI_DRAFT_MODE]]
- [[AI_WRITE_CONFIRMATION]]
- [[AI_DSGVO_PRIVACY]]
- [[AI_SCALABILITY]]
- [[MOBILE_FEATURE_AI_ASSISTANT]]
- [[IOS_FEATURE_AI_MENTION]]
