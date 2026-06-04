/**
 * E2E Test: [FEATURE_NAME]
 *
 * Testet [BESCHREIBUNG DES FEATURES].
 */
import { test, expect } from '@playwright/test';
import { TEST_ADMIN, TEST_EMPLOYEE } from '../fixtures/test-data';
import { login } from '../helpers/auth';

test.describe('[FEATURE_NAME]', () => {
  test.beforeEach(async ({ page }) => {
    await page.goto('/login');
    await login(page, {
      email: TEST_ADMIN.email,
      password: TEST_ADMIN.password,
    });

    // Navigation zur Zielseite
    // const link = page.getByRole('link', { name: /zielseite/i });
    // if (await link.isVisible({ timeout: 5000 }).catch(() => false)) {
    //   await link.click();
    // }
  });

  test('[BESCHREIBUNG DES TESTS]', async ({ page }) => {
    // Arrange
    // ...

    // Act
    // ...

    // Assert
    // await expect(page.getByText(/erwarteter text/i)).toBeVisible();
  });

  test('[BESCHREIBUNG DES TESTS]', async ({ page }) => {
    // ...
  });
});
