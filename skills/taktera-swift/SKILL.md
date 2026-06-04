---
name: taktera-swift
description: "Use when writing or modifying Swift/SwiftUI code for taktera-ios or taktera-mobile iOS native modules. Contains Swift coding standards, SwiftUI patterns, iOS-specific conventions, and taktera-specific iOS architecture. Load taktera-design-system for UI consistency."
---

# taktera Swift / iOS Development

## Overview

Swift and SwiftUI coding standards for taktera's iOS components. Covers general Swift best practices AND taktera-specific iOS patterns. This skill evolves iteratively — when you discover new patterns in the taktera codebase, update this skill.

**Related skills:** `taktera-design-system` (UI consistency), `taktera-feature-development` (TDD process)

## External References (from SwiftUI-Agent-Skill by Paul Hudson)

These references are loaded from the [SwiftUI-Agent-Skill](https://github.com/twostraws/SwiftUI-Agent-Skill) repo and provide deep best-practice reviews:

- `references/api.md` — Modern SwiftUI API usage, deprecated API replacements
- `references/views.md` — View structure, composition, animation best practices
- `references/data.md` — Data flow, shared state, property wrappers
- `references/navigation.md` — NavigationStack, alerts, sheets, confirmation dialogs
- `references/accessibility.md` — Dynamic Type, VoiceOver, Reduce Motion
- `references/performance.md` — SwiftUI performance optimization
- `references/design.md` — Apple Human Interface Guidelines compliance
- `references/hygiene.md` — Code cleanliness, maintainability
- `references/swift.md` — Modern Swift concurrency, Swift 6.2+ patterns

> Load the relevant reference file when doing a code review or when the topic applies.

- Writing new Swift/SwiftUI views for taktera-ios
- Modifying existing iOS code
- Adding native iOS functionality
- Working with Xcode project files
- iOS-specific debugging

## Swift Coding Standards

### Naming Conventions

```swift
// Types: PascalCase
struct EmployeeCard: View {}
class TimeTrackingManager {}
enum ShiftStatus {}

// Variables/Functions: camelCase
let currentEmployee: Employee
func calculateWorkHours() -> Double {}
var isTracking: Bool = false

// Constants: camelCase (not SCREAMING_SNAKE_CASE)
let maxShiftHours: Double = 12.0
let brandColor = Color(hex: "#14919b")

// ViewModifiers: PascalCase + "Modifier" suffix
struct BrandButtonStyle: ButtonStyle {}
struct CardShadowModifier: ViewModifier {}
```

### Type Safety

```swift
// Prefer strong types over primitives
struct EmployeeID: RawRepresentable, Hashable {
    let rawValue: String
}

// Use enums for state
enum TrackingState {
    case idle
    case tracking(startTime: Date)
    case paused(elapsed: TimeInterval)
}

// Avoid force unwrap — use guard or if-let
guard let employee = currentEmployee else { return }
// NOT: let employee = currentEmployee!
```

### Optionals

```swift
// Use nil coalescing for defaults
let name = employee?.name ?? "Unbekannt"

// Use optional chaining for method calls
employee?.updateStatus(.active)

// Use guard-let for early returns
guard let practice = selectedPractice else {
    logger.error("No practice selected")
    return
}
```

### Error Handling

```swift
// Define domain errors
enum TimeTrackingError: LocalizedError {
    case noActiveShift
    case networkError(underlying: Error)
    case firestoreError(code: Int)
    
    var errorDescription: String? {
        switch self {
        case .noActiveShift: return "Keine aktive Schicht"
        case .networkError: return "Netzwerkfehler"
        case .firestoreError: return "Datenbankfehler"
        }
    }
}

// Use Result type for async operations
func syncTimeDay() async throws -> TimeDay
```

## SwiftUI Patterns

### View Structure

```swift
struct TimeTrackingView: View {
    // MARK: - State
    @StateObject private var viewModel = TimeTrackingViewModel()
    @State private var showingConfirmDialog = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Zeiterfassung")
                .toolbar { toolbarContent }
                .alert("Fehler", isPresented: $viewModel.hasError) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text(viewModel.errorMessage)
                }
        }
    }
    
    // MARK: - Content Views
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            idleView
        case .tracking:
            trackingView
        case .loading:
            ProgressView()
        }
    }
    
    // MARK: - Toolbar
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            PracticeSwitcher()
        }
    }
}
```

### State Management

```swift
// Use @StateObject for view-owned state
@StateObject private var viewModel = TimeTrackingViewModel()

// Use @ObservedObject for injected state
@ObservedObject var store: TimeTrackingStore

// Use @Environment for system/environment values
@Environment(\.dismiss) private var dismiss
@Environment(\.colorScheme) private var colorScheme

// Use @AppStorage for user preferences
@AppStorage("selectedPracticeId") private var selectedPracticeId: String = ""
```

### ViewModels

```swift
@MainActor
class TimeTrackingViewModel: ObservableObject {
    @Published var state: TrackingState = .idle
    @Published var currentDay: TimeDay?
    @Published var hasError = false
    @Published var errorMessage = ""
    
    private let repository: TimeTrackingRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: TimeTrackingRepository = .shared) {
        self.repository = repository
        setupBindings()
    }
    
    func startTracking() async {
        state = .loading
        do {
            let event = try await repository.createEvent(.stampIn)
            state = .tracking(startTime: event.timestamp)
        } catch {
            handleError(error)
        }
    }
    
    private func handleError(_ error: Error) {
        hasError = true
        errorMessage = error.localizedDescription
        state = .idle
    }
}
```

### taktera iOS Color System

```swift
import SwiftUI

extension Color {
    // Brand Colors
    static let brand50 = Color(hex: "#e0fcff")
    static let brand100 = Color(hex: "#bef8fd")
    static let brand200 = Color(hex: "#87eaf2")
    static let brand300 = Color(hex: "#54d1db")
    static let brand400 = Color(hex: "#38bec9")
    static let brand500 = Color(hex: "#2cb1bc")
    static let brand600 = Color(hex: "#14919b")
    static let brand700 = Color(hex: "#0f7a82")
    static let brand800 = Color(hex: "#0a616c")
    static let brand900 = Color(hex: "#044e54")
    
    // Slate Neutrals
    static let slate50 = Color(hex: "#f8fafc")
    static let slate100 = Color(hex: "#f1f5f9")
    static let slate200 = Color(hex: "#e2e8f0")
    static let slate300 = Color(hex: "#cbd5e1")
    static let slate400 = Color(hex: "#94a3b8")
    static let slate500 = Color(hex: "#64748b")
    static let slate600 = Color(hex: "#475569")
    static let slate700 = Color(hex: "#334155")
    static let slate800 = Color(hex: "#1e293b")
    static let slate900 = Color(hex: "#0f172a")
    
    // Semantic
    static let colorSuccess = Color(hex: "#10b981")
    static let colorWarning = Color(hex: "#f59e0b")
    static let colorError = Color(hex: "#ef4444")
    static let colorInfo = Color(hex: "#3b82f6")
}

// Hex initializer
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
```

### taktera Button Styles (SwiftUI)

```swift
// ⚠️ CRITICAL: Every button MUST have hover/press feedback
// SwiftUI handles cursor automatically on macOS, but press feedback is manual

struct BrandButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.brand600)
            .cornerRadius(12)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

struct DarkButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.white)
            .padding(.horizontal, 48)
            .padding(.vertical, 16)
            .background(Color.slate900)
            .cornerRadius(16)
            .shadow(color: Color.slate900.opacity(0.2), radius: 25, y: 10)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct GhostButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(.slate600)
            .padding(.horizontal, 48)
            .padding(.vertical, 16)
            .background(Color.white.opacity(0.5))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.slate200, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

// Usage:
Button("Schicht starten") { action }
    .buttonStyle(BrandButtonStyle())
```

### taktera Card Style (SwiftUI)

```swift
struct TakteraCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(28)
            .background(Color.white)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.slate200, lineWidth: 1)
            )
            .shadow(color: Color.slate900.opacity(0.05), radius: 4, y: 2)
    }
}

extension View {
    func takteraCard() -> some View {
        modifier(TakteraCardModifier())
    }
}
```

### taktera Badge Style (SwiftUI)

```swift
struct RoleBadge: View {
    let role: EmployeeRole
    
    var body: some View {
        Text(role.displayName)
            .font(.system(size: 11, weight: .semibold))
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(role.badgeColor)
            .foregroundColor(role.textColor)
            .cornerRadius(100)
    }
}

extension EmployeeRole {
    var badgeColor: Color {
        switch self {
        case .behandler: return Color(hex: "#e0e7ff")
        case .assistenz: return Color(hex: "#ecfdf5")
        case .prophylaxe: return Color(hex: "#f0f9ff")
        case .azubi: return Color(hex: "#fff7ed")
        case .empfang: return Color(hex: "#f1f5f9")
        }
    }
    
    var textColor: Color {
        switch self {
        case .behandler: return Color(hex: "#4338ca")
        case .assistenz: return Color(hex: "#047857")
        case .prophylaxe: return Color(hex: "#0369a1")
        case .azubi: return Color(hex: "#c2410c")
        case .empfang: return Color(hex: "#334155")
        }
    }
}
```

## taktera iOS Architecture

### Folder Structure
```
taktera-ios/
├── Views/           # SwiftUI Views
├── ViewModels/      # ObservableObject classes
├── Models/          # Data models
├── Services/        # Repositories, API clients
├── Extensions/      # Swift extensions (Color, View, etc.)
├── Utilities/       # Helpers, formatters
└── Resources/       # Assets, localization
```

### Firestore Integration
```swift
// Use Firebase iOS SDK
import FirebaseFirestore

class TimeTrackingRepository {
    static let shared = TimeTrackingRepository()
    private let db = Firestore.firestore()
    
    func fetchTimeDay(employeeId: String, date: String) async throws -> TimeDay {
        let doc = try await db.collection("timeDays")
            .document("\(date)_\(employeeId)")
            .getDocument()
        return try doc.data(as: TimeDay.self)
    }
    
    func createEvent(_ event: TimeEvent) async throws {
        try db.collection("timeDays")
            .document("\(event.date)_\(event.employeeId)")
            .collection("events")
            .addDocument(from: event)
    }
}
```

### Offline Support
```swift
// Enable persistent cache
let settings = FirestoreSettings()
settings.isPersistenceEnabled = true
settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
db.settings = settings
```

## Common Pitfalls

1. **No press feedback on buttons** — Always use `.scaleEffect(configuration.isPressed ? 0.98 : 1.0)`
2. **Force unwrapping optionals** — Use `guard let` or `if let`
3. **Main thread violations** — Use `@MainActor` for ViewModels
4. **Hardcoded colors** — Always use `Color.brand600` etc., never hex literals in views
5. **No error states** — Every async operation needs error handling
6. **Massive Views** — Extract subviews when body exceeds ~100 lines
7. **No accessibility** — Add `.accessibilityLabel()` to interactive elements

## Iterative Improvement

When you discover new patterns in the taktera iOS codebase:
1. Add them to this skill under the relevant section
2. Note the date and context of the discovery
3. Update related sections if needed
