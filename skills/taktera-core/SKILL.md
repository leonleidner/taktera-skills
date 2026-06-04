---
name: taktera-core
description: "Use when writing or modifying code in taktera-core (Web app, app.taktera.de). Contains React/TypeScript/Zustand/Firebase patterns, component architecture, store conventions, and taktera-specific web patterns. Load taktera-design-system for UI consistency."
---

# taktera Core (Web) Development

## Overview

React/TypeScript development standards for taktera-core. Covers general web best practices AND taktera-specific patterns. This skill evolves iteratively — when you discover new patterns in the codebase, update this skill.

**Related skills:** `taktera-design-system` (UI consistency), `taktera-feature-development` (TDD process), `taktera-testing` (test patterns)

## Tech Stack

- **Framework:** React 19 + TypeScript + Vite
- **State:** Zustand (7-Slice architecture)
- **Styling:** Tailwind CSS 4
- **Backend:** Firebase (Auth, Firestore, Functions v2, Vertex AI)
- **D&D:** @dnd-kit
- **Animation:** Framer Motion
- **Routing:** React Router v7 with lazy loading

## Project Structure

```
src/
├── main.tsx                 # Entry point
├── App.tsx                  # Router with lazy loading
├── types.ts                 # Global types
├── index.css                # Global styles (Tailwind)
├── config/
│   └── marketplace.ts       # App registry
├── store/
│   ├── clinicStore.ts       # Main Zustand store (317 lines)
│   └── slices/
│       ├── planSlice.ts     # Planner state (739 lines, most complex)
│       ├── employeeSlice.ts # Employee management
│       ├── absenceSlice.ts  # Absence management
│       ├── roomSlice.ts     # Room management
│       ├── roleSlice.ts     # Role definitions
│       └── announcementSlice.ts # Announcements
├── components/
│   ├── ui/                  # Base components (Button, Card, Modal, etc.)
│   └── ai/                  # AI chat components
├── features/
│   ├── auth/                # Login, auth flow
│   ├── planner/             # FluentPlanner
│   ├── absences/            # Absence management
│   ├── analytics-pro/       # Analytics dashboard
│   └── time-tracking/       # Time tracking admin view
├── lib/
│   ├── utils.ts             # Common utilities (cn function)
│   ├── firebase.ts          # Firebase config
│   ├── holidays.ts          # Holiday calculations
│   └── *.test.ts            # Unit tests
└── layout/
    └── AppLayout.tsx        # Main layout
```

## TypeScript Standards

### Type Definitions

```typescript
// Define types in src/types.ts for global types
// Define local types in feature files

// Use interfaces for objects
interface TimeEvent {
  id: string;
  employeeId: string;
  date: string; // yyyyMMdd
  type: TimeEventType;
  timestamp: Date;
  source: 'web' | 'mobile' | 'manual';
}

// Use type unions for variants
type TimeEventType = 'stampIn' | 'stampOut' | 'breakStart' | 'breakEnd';
type TrackingStatus = 'idle' | 'tracking' | 'paused';

// Use enums sparingly — prefer const objects
const ShiftStatus = {
  DRAFT: 'draft',
  PUBLISHED: 'published',
  LOCKED: 'locked',
} as const;
type ShiftStatus = typeof ShiftStatus[keyof typeof ShiftStatus];

// Avoid 'any' — use 'unknown' if type is truly unknown
// NOT: function process(data: any)
// YES: function process(data: unknown)
```

### Component Typing

```typescript
// Use React.FC sparingly — prefer direct function typing
interface TimeCardProps {
  employee: Employee;
  events: TimeEvent[];
  onStampIn: () => void;
  onStampOut: () => void;
}

export function TimeCard({ employee, events, onStampIn, onStampOut }: TimeCardProps) {
  // ...
}

// Use forwardRef for components that need ref forwarding
export const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ variant, size, ...props }, ref) => {
    return <button ref={ref} className={buttonVariants({ variant, size })} {...props} />;
  }
);
```

## Zustand Store Patterns

### Slice Pattern

```typescript
// src/store/slices/timeTrackingSlice.ts
import { StateCreator } from 'zustand';

export interface TimeTrackingSlice {
  // State
  currentStatus: TrackingStatus;
  activeEvent: TimeEvent | null;
  timeDays: Record<string, TimeDay>;
  isLoading: boolean;
  error: string | null;
  
  // Actions
  setCurrentStatus: (status: TrackingStatus) => void;
  loadTimeDay: (employeeId: string, date: string) => Promise<void>;
  stampIn: () => Promise<void>;
  stampOut: () => Promise<void>;
  setError: (error: string | null) => void;
}

export const createTimeTrackingSlice: StateCreator<
  ClinicStore,
  [],
  [],
  TimeTrackingSlice
> = (set, get) => ({
  currentStatus: 'idle',
  activeEvent: null,
  timeDays: {},
  isLoading: false,
  error: null,
  
  setCurrentStatus: (status) => set({ currentStatus: status }),
  
  loadTimeDay: async (employeeId, date) => {
    set({ isLoading: true, error: null });
    try {
      const doc = await getDoc(doc(db, 'timeDays', `${date}_${employeeId}`));
      if (doc.exists()) {
        set(state => ({
          timeDays: { ...state.timeDays, [`${date}_${employeeId}`]: doc.data() as TimeDay },
          isLoading: false,
        }));
      }
    } catch (error) {
      set({ error: 'Fehler beim Laden', isLoading: false });
    }
  },
  
  stampIn: async () => {
    // Implementation
  },
  
  stampOut: async () => {
    // Implementation
  },
  
  setError: (error) => set({ error }),
});
```

### Store Composition

```typescript
// src/store/clinicStore.ts
import { create } from 'zustand';
import { devtools, persist } from 'zustand/middleware';
import { immer } from 'zustand/middleware/immer';

// Import slices
import { createPlanSlice } from './slices/planSlice';
import { createEmployeeSlice } from './slices/employeeSlice';
import { createTimeTrackingSlice } from './timeTrackingSlice';
// ... other slices

export const useClinicStore = create<ClinicStore>()(
  devtools(
    persist(
      immer((...a) => ({
        ...createPlanSlice(...a),
        ...createEmployeeSlice(...a),
        ...createTimeTrackingSlice(...a),
        // ... other slices
      })),
      { name: 'taktera-store' }
    )
  )
);
```

## React Component Patterns

### Component Structure

```typescript
// Feature component with hooks
interface TimeTrackingViewProps {
  practiceId: string;
}

export function TimeTrackingView({ practiceId }: TimeTrackingViewProps) {
  // 1. Hooks
  const { currentUser } = useAuth();
  const { timeDays, loadTimeDay } = useClinicStore();
  const [selectedMonth, setSelectedMonth] = useState(dayjs());
  
  // 2. Effects
  useEffect(() => {
    if (currentUser) {
      loadTimeDay(currentUser.id, selectedMonth.format('YYYYMM'));
    }
  }, [currentUser, selectedMonth, loadTimeDay]);
  
  // 3. Event handlers
  const handleStampIn = useCallback(async () => {
    // ...
  }, []);
  
  // 4. Render
  return (
    <div className="p-6">
      {/* ... */}
    </div>
  );
}
```

### Lazy Loading (Router)

```typescript
// src/App.tsx
import { lazy, Suspense } from 'react';

const PlannerView = lazy(() => import('./features/planner/PlannerView'));
const TimeTrackingView = lazy(() => import('./features/time-tracking/TimeTrackingView'));

export function App() {
  return (
    <BrowserRouter>
      <Suspense fallback={<LoadingSpinner />}>
        <Routes>
          <Route path="/planner" element={<PlannerView />} />
          <Route path="/time-tracking" element={<TimeTrackingView />} />
        </Routes>
      </Suspense>
    </BrowserRouter>
  );
}
```

## TailwindCSS Patterns

### Standard Classes

```typescript
// Use cn() from src/lib/utils for conditional classes
import { cn } from '../../lib/utils';

// Card
className={cn(
  "bg-white rounded-2xl border border-slate-200 p-7",
  "shadow-md hover:shadow-lg hover:-translate-y-1",
  "transition-all duration-200",
  isActive && "border-brand-500 ring-2 ring-brand-100"
)}

// Button (with cursor-pointer!)
className={cn(
  "bg-brand-600 text-white font-semibold rounded-xl px-6 py-3",
  "cursor-pointer hover:bg-brand-700 hover:shadow-lg",
  "active:scale-[0.98] transition-all duration-200",
  disabled && "opacity-50 cursor-not-allowed"
)}

// Input
className={cn(
  "w-full rounded-xl border border-slate-200 px-4 py-3",
  "text-slate-900 placeholder:text-slate-400",
  "focus:border-brand-500 focus:ring-2 focus:ring-brand-100",
  "transition-all duration-200"
)}

// Table row hover
className={cn(
  "hover:bg-brand-50 transition-colors duration-150"
)}
```

### Color Usage

```typescript
// ✅ CORRECT: Use design tokens
className="bg-brand-600 text-white"
className="bg-slate-50 text-slate-900"
className="border-slate-200"

// ❌ WRONG: Arbitrary colors
className="bg-[#14919b]"
className="bg-gray-100"
className="text-black"
```

## UI Component Standards

### Button Component Fix

The existing `Button.tsx` is missing `cursor-pointer` and proper hover transitions. The base CVA string should include:

```typescript
const buttonVariants = cva(
  "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium ring-offset-background transition-all duration-200 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 cursor-pointer active:scale-[0.98]",
  {
    variants: {
      variant: {
        primary: "bg-brand-500 text-white hover:bg-brand-600 hover:shadow-lg",
        destructive: "bg-red-500 text-white hover:bg-red-600 hover:shadow-lg",
        outline: "border border-input bg-background hover:bg-accent hover:text-accent-foreground",
        secondary: "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        link: "text-primary underline-offset-4 hover:underline",
      },
      // ... sizes
    },
  }
);
```

**When adding new interactive components, ALWAYS include:**
1. `cursor-pointer` — on every clickable element
2. `hover:` state — color change, shadow, or scale
3. `transition-all duration-200` — smooth animation
4. `active:scale-[0.98]` — press feedback

## Firebase Patterns

### Firestore Reads

```typescript
import { collection, doc, getDoc, getDocs, query, where } from 'firebase/firestore';
import { db } from '../../lib/firebase';

// Single document
async function getEmployee(employeeId: string): Promise<Employee | null> {
  const docSnap = await getDoc(doc(db, 'employees', employeeId));
  return docSnap.exists() ? docSnap.data() as Employee : null;
}

// Collection query
async function getPracticeEmployees(practiceId: string): Promise<Employee[]> {
  const q = query(collection(db, 'employees'), where('practiceId', '==', practiceId));
  const snapshot = await getDocs(q);
  return snapshot.docs.map(doc => doc.data() as Employee);
}
```

### Cloud Functions Calls

```typescript
import { httpsCallable } from 'firebase/functions';
import { functions } from '../../lib/firebase';

const recalculateTimeDay = httpsCallable(functions, 'recalculateTimeDay');

export async function refreshTimeDay(employeeId: string, date: string) {
  const result = await recalculateTimeDay({ employeeId, date });
  return result.data;
}
```

## Common Pitfalls

1. **Missing `cursor-pointer`** on buttons/interactive elements — violates design system
2. **No hover effects** on interactive elements — feels broken
3. **Arbitrary Tailwind colors** instead of brand/slate tokens
4. **Direct Firestore calls** in components — should go through store slices
5. **Zustand store mutations** outside of `set()` — use immer middleware
6. **No error states** — every async operation needs error handling
7. **No loading states** — show skeletons/spinners during async operations
8. **Monolithic components** — extract subviews when >200 lines
9. **No TypeScript strictness** — avoid `any`, enable strict mode

## Iterative Improvement

When you discover new patterns in the taktera-core codebase:
1. Add them to this skill under the relevant section
2. Note the date and context
3. Update related sections if needed

## Quick Reference

```bash
# Dev server
npm run dev

# Build
npm run build

# TypeScript check
npx tsc --noEmit

# Unit tests
npm test

# E2E tests
npm run test:e2e

# Deploy
firebase deploy -P dev    # Development
firebase deploy -P default # Production
```
