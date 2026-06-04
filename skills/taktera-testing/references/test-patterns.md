# Playwright Test Patterns für taktera

## Login Flow Helper

```typescript
import { login, navigateToPlanner } from '../helpers/auth';

test.describe('Feature Name', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/login');
    await login(page, {
      email: 'admin@test-praxis.taktera.de',
      password: 'TestPassword123!',
    });
    await navigateToPlanner(page);  // oder andere Zielseite
  });

  test('sollte etwas tun', async ({ page }) => {
    await expect(page.getByText(/erwarteter text/i)).toBeVisible();
  });
});
```

## Selektor-Patterns

```typescript
// Role-based (bevorzugt)
page.getByRole('button', { name: /speichern|save/i })
page.getByRole('link', { name: /plan|dashboard/i })
page.getByRole('dialog')

// Text-based
page.getByText(/willkommen bei taktera/i)
page.getByText(/08:00/)  // Zeitslot

// CSS-Fallback mit or()-Kette
page.locator('[class*="card"], table').first()
page.locator('td:empty, [class*="cell"]:not(:has(*))')

// Formulare
page.locator('input[type="email"]')
page.locator('input[type="password"]')
page.locator('input[placeholder*="praxis"]')
page.locator('textarea, input[name*="kommentar"]')

// Navigation
page.locator('nav a[href*="plan"]')
page.getByRole('link', { name: /plan|planer/i })
```

## Drag & Drop Pattern

```typescript
// @dnd-kit Drag & Drop
const employeeCard = page.locator('[draggable="true"]').first();
const targetCell = page.locator('td').nth(5);  // Erste Zelle nach Provider-Spalte

if (await employeeCard.isVisible() && await targetCell.isVisible()) {
  await employeeCard.dragTo(targetCell);
  await page.waitForTimeout(1000);
}
```

## Firestore-abhängige Tests

```typescript
// Immer Warten auf Firestore-Operationen
await page.waitForTimeout(2000);  // Firestore Latenz

// URL-Weiterleitung prüfen
await page.waitForURL(/\/dashboard|\/mein-plan/, { timeout: 15000 });

// Toast-Nachrichten prüfen
await expect(page.getByText(/gespeichert|erfolgreich|erstellt/i)).toBeVisible({ timeout: 10000 });
```

## Test-Daten Pattern

```typescript
// Timestamp für eindeutige Daten
const timestamp = Date.now();
const testName = `E2E Test ${timestamp}`;
const testEmail = `e2e-${timestamp}@taktera.de`;
```

## Häufige Fehler

1. **Timeout zu kurz**: Firestore braucht 2-3s – immer 10-15s Timeouts
2. **Animationen**: Framer Motion Animationen können Tests bremsen – `waitForTimeout(1000)` nach Navigation
3. **Lazy Loading**: Routes werden lazy geladen – `waitForURL()` statt `waitForSelector()`
4. **Draft Mode**: Änderungen sind erst im Draft Store – erst nach "Speichern" in Firestore
