---
name: taktera-design-system
description: "Use when building or modifying ANY UI in taktera-core (Web) or taktera-mobile (iOS). Contains all design tokens: colors, typography, spacing, radii, shadows, button styles with cursor-pointer and hover effects, card styles, role badges, room categories. MUST be loaded before any UI coding task to ensure visual consistency."
---

# taktera Design System

## Overview

Single source of truth for ALL visual design in taktera. Every UI component, every screen, every feature MUST follow this guide. No exceptions.

**Core principle:** If it's visible on screen, it follows these rules.

## When to Use

- Building any new UI component or screen
- Modifying existing UI
- Reviewing code for design consistency
- Fixing visual inconsistencies
- Adding buttons, cards, badges, tables, or any interactive element

## Colors

### Brand (Teal/Cyan) — Primary Identity

| Token | Hex | Usage |
|-------|-----|-------|
| `brand-50` | `#e0fcff` | Backgrounds, hover states |
| `brand-100` | `#bef8fd` | Light badges, highlights |
| `brand-200` | `#87eaf2` | Secondary elements |
| `brand-300` | `#54d1db` | Gradient accents |
| `brand-400` | `#38bec9` | Hover states, active |
| `brand-500` | `#2cb1bc` | **Primary accent** |
| `brand-600` | `#14919b` | **Main color for text & buttons** |
| `brand-700` | `#0f7a82` | Dark mode accents |
| `brand-800` | `#0a616c` | High contrast areas |
| `brand-900` | `#044e54` | Deep dark accents |

### Slate — Neutrals

| Token | Hex | Usage |
|-------|-----|-------|
| `slate-50` | `#f8fafc` | Main background |
| `slate-100` | `#f1f5f9` | Card backgrounds |
| `slate-200` | `#e2e8f0` | Borders, dividers |
| `slate-300` | `#cbd5e1` | Disabled elements |
| `slate-400` | `#94a3b8` | Placeholder text |
| `slate-500` | `#64748b` | Secondary text |
| `slate-600` | `#475569` | Body text (dark) |
| `slate-700` | `#334155` | Headings |
| `slate-800` | `#1e293b` | Dark mode backgrounds |
| `slate-900` | `#0f172a` | Primary text, headlines |

### Semantic Colors

| Purpose | Hex | Token |
|---------|-----|-------|
| Success | `#10b981` | `emerald-500` |
| Warning | `#f59e0b` | `amber-500` |
| Error | `#ef4444` | `red-500` |
| Info | `#3b82f6` | `blue-500` |

### CSS Custom Properties (Copy-Paste)

```css
:root {
  /* Brand */
  --brand-50: #e0fcff;
  --brand-100: #bef8fd;
  --brand-200: #87eaf2;
  --brand-300: #54d1db;
  --brand-400: #38bec9;
  --brand-500: #2cb1bc;
  --brand-600: #14919b;
  --brand-700: #0f7a82;
  --brand-800: #0a616c;
  --brand-900: #044e54;

  /* Slate */
  --slate-50: #f8fafc;
  --slate-100: #f1f5f9;
  --slate-200: #e2e8f0;
  --slate-300: #cbd5e1;
  --slate-400: #94a3b8;
  --slate-500: #64748b;
  --slate-600: #475569;
  --slate-700: #334155;
  --slate-800: #1e293b;
  --slate-900: #0f172a;

  /* Semantic */
  --color-success: #10b981;
  --color-warning: #f59e0b;
  --color-error: #ef4444;
  --color-info: #3b82f6;
}
```

## Typography

### Font Family

**Web (taktera-core):** Inter via Google Fonts
```css
font-family: 'Inter', -apple-system, BlinkMacSystemFont, system-ui, sans-serif;
```

**Mobile (taktera-ios):** SF Pro (system font — no import needed)
```css
font-family: -apple-system, BlinkMacSystemFont, 'SF Pro Display', 'SF Pro Text', system-ui, sans-serif;
```

**Mobile (taktera-mobile/Expo):** System font
```typescript
fontFamily: {
  regular: 'System',
  medium: 'System',
  semibold: 'System',
  bold: 'System',
}
```

### Font Weights

| Weight | Value | Usage |
|--------|-------|-------|
| Regular | 400 | Body text, descriptions |
| Medium | 500 | Subheadlines, labels |
| Semibold | 600 | Buttons, card titles |
| Bold | 700 | Section headlines |
| Extrabold | 800 | Hero headlines |

### Font Sizes (Desktop)

| Element | Size | Weight | Line-Height |
|---------|------|--------|-------------|
| Hero H1 | 4.5rem (72px) | 800 | 1.1 |
| Section H2 | 3rem (48px) | 800 | 1.15 |
| Card H3 | 1.25rem (20px) | 700 | 1.3 |
| Body | 1rem (16px) | 400 | 1.6 |
| Small | 0.875rem (14px) | 400 | 1.5 |
| Label | 0.75rem (12px) | 600 | 1.4 |
| Micro | 0.65rem (10px) | 600 | 1.3 |

### Text Styling Patterns

**Gradient Headlines:**
```css
background: linear-gradient(to right, #14919b, #38bec9);
-webkit-background-clip: text;
-webkit-text-fill-color: transparent;
background-clip: text;
```

**Uppercase Labels:**
```css
font-size: 0.75rem;
font-weight: 600;
letter-spacing: 0.2em;
text-transform: uppercase;
color: #14919b; /* brand-600 */
```

## Spacing & Radii

| Token | Value | Usage |
|-------|-------|-------|
| `radius-sm` | 8px | Small elements, inputs |
| `radius-md` | 12px | Buttons, badges |
| `radius-lg` | 16px | Large buttons |
| `radius-xl` | 20px | Cards |
| `radius-2xl` | 28px | Large cards, sections |
| `radius-full` | 100px | Badges, avatars |

## Shadows

| Token | Value | Usage |
|-------|-------|-------|
| `shadow-sm` | `0 1px 3px rgba(15, 23, 42, 0.08)` | Subtle elevation |
| `shadow-md` | `0 4px 20px rgba(15, 23, 42, 0.05)` | Cards |
| `shadow-lg` | `0 12px 32px rgba(15, 23, 42, 0.1)` | Hover cards |
| `shadow-glass` | `0 20px 35px rgba(15, 23, 42, 0.45)` | Mockups, modals |

## UI Components

### Buttons — ⚠️ CRITICAL RULES

**Every interactive button MUST have:**
1. `cursor: pointer` — ALWAYS, no exceptions
2. Hover effect — ALWAYS (color change, scale, or shadow)
3. `transition` — for smooth hover animation
4. `border-radius` — minimum 12px, never square

**Primary Button (Brand):**
```tsx
// Tailwind classes
className="bg-brand-600 text-white font-semibold rounded-xl px-6 py-3 
           cursor-pointer hover:bg-brand-700 hover:shadow-lg 
           active:scale-[0.98] transition-all duration-200"
```

**Primary Button (Dark):**
```tsx
className="bg-slate-900 text-white font-bold rounded-xl px-12 py-4 
           cursor-pointer hover:bg-black hover:scale-[1.03] 
           shadow-lg transition-all duration-200"
```

**Secondary Button (Ghost):**
```tsx
className="bg-white/50 backdrop-blur-md border border-slate-200 
           text-slate-600 font-bold rounded-xl px-12 py-4 
           cursor-pointer hover:bg-white hover:shadow-lg 
           transition-all duration-200"
```

**Brand Gradient Button:**
```tsx
className="bg-gradient-to-r from-brand-600 to-brand-700 text-white 
           font-semibold rounded-xl px-6 py-3 
           cursor-pointer hover:from-brand-700 hover:to-brand-800 
           hover:shadow-lg active:scale-[0.98] 
           transition-all duration-200"
```

**Destructive Button:**
```tsx
className="bg-red-500 text-white font-semibold rounded-xl px-6 py-3 
           cursor-pointer hover:bg-red-600 hover:shadow-lg 
           active:scale-[0.98] transition-all duration-200"
```

**Button Component Fix (taktera-core):**
The existing `Button.tsx` uses shadcn/ui's `class-variance-authority`. It is MISSING `cursor-pointer` and proper hover transitions. When modifying it, add to the base CVA string:
```
cursor-pointer transition-all duration-200 active:scale-[0.98]
```

### Cards

```tsx
className="bg-white rounded-2xl border border-slate-200 p-7 
           shadow-md hover:shadow-lg hover:-translate-y-1 
           transition-all duration-200"
```

### Badges

```tsx
// Base badge
className="inline-block text-xs font-semibold px-2.5 py-1 rounded-full"

// Brand badge
className="inline-block text-xs font-semibold px-2.5 py-1 rounded-full 
           bg-brand-100 text-brand-700"
```

### Tables

```tsx
// Header
className="bg-slate-50 text-xs font-semibold uppercase tracking-wider 
           text-slate-500 px-5 py-4"

// Cell
className="px-5 py-4 border-t border-slate-100"

// Row hover
className="hover:bg-brand-50 transition-colors duration-150"
```

### Inputs

```tsx
className="w-full rounded-xl border border-slate-200 px-4 py-3 
           text-slate-900 placeholder:text-slate-400 
           focus:border-brand-500 focus:ring-2 focus:ring-brand-100 
           transition-all duration-200"
```

## Role Badges (Mitarbeiter)

| Role | Background | Text | Border |
|------|------------|------|--------|
| Behandler/Zahnarzt | `bg-indigo-100` | `text-indigo-700` | `border-indigo-200` |
| Assistenz/ZFA | `bg-emerald-50` | `text-emerald-700` | `border-emerald-200` |
| Prophylaxe | `bg-sky-50` | `text-sky-700` | `border-sky-200` |
| Azubi | `bg-orange-50` | `text-orange-700` | `border-orange-200` |
| Empfang | `bg-slate-100` | `text-slate-700` | `border-slate-300` |

## Room Categories

| Category | Accent Color |
|----------|-------------|
| Standard | `emerald-400` |
| Chirurgie | `rose-500` |
| Röntgen | `sky-400` |
| Prophylaxe | `violet-400` |

## Background Elements

### Grid Pattern (Landing Page)
```css
.grid-background {
  background: 
    linear-gradient(to right, #80808022 1px, transparent 1px),
    linear-gradient(to bottom, #80808022 1px, transparent 1px);
  background-size: 64px 64px;
  mask-image: radial-gradient(ellipse 100% 100% at 50% 50%, #000 80%, transparent 100%);
  opacity: 0.8;
}
```

### Gradient Blobs
```css
.blob-1 {
  position: absolute;
  left: -10%; top: -10%;
  width: 800px; height: 800px;
  border-radius: 50%;
  background: linear-gradient(to bottom-right, rgba(84, 209, 219, 0.2), rgba(94, 234, 212, 0.1));
  filter: blur(120px);
}
```

## Do's & Don'ts

### ✅ Do's
- Always use `cursor-pointer` on every clickable element (buttons, links, clickable cards, tabs, dropdown items)
- Always add hover effects on interactive elements (color change, scale, shadow)
- Always use `transition-all duration-200` for smooth animations
- Use `brand-600` as the primary accent color
- Use `slate-900` instead of pure black
- Use `slate-50` for backgrounds, never pure white directly
- Minimum border-radius: 12px for buttons, 20px for cards
- Use Inter font on web, SF Pro / system font on mobile

### ❌ Don'ts
- NO clickable element without `cursor-pointer`
- NO button without hover effect
- NO square buttons (always rounded)
- NO pure black (`#000`) — use `slate-900`
- NO pure white backgrounds — use `slate-50`
- NO other blue tones outside the brand palette
- NO hard shadows — always soft, subtle shadows
- NO colorful backgrounds — always `slate-50` or white
- NO font other than Inter (web) or system font (mobile)

## Quick Reference

```
Primary:    #14919b (brand-600)
Accent:     #2cb1bc (brand-500)
Light:      #e0fcff (brand-50)
Text:       #0f172a (slate-900)
Subtext:    #64748b (slate-500)
Background: #f8fafc (slate-50)
Border:     #e2e8f0 (slate-200)
Error:      #ef4444 (red-500)
Success:    #10b981 (emerald-500)
Warning:    #f59e0b (amber-500)
```
