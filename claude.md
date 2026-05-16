# Mind Space — Flutter Project Context

## What this app is
An emotional journaling app. Users talk to Sage (an AI). Sessions get grouped into Arcs (recurring themes via embedding-based clustering). After 3+ sessions, users generate Arc Analysis (macro insight).

## Stack
- Flutter (Dart), Android target, API 24+
- State: flutter_riverpod ^2.x
- Routing: go_router ^13.x
- Backend: Supabase (auth, postgres, edge functions)
- Animations: flutter_animate ^4.x
- Gestures: flutter_slidable (swipe actions on list rows)
- Fonts: Google Fonts — Inter

## Project structure
lib/
  core/theme/          # AppTheme, color tokens, spacing
  core/components/     # Shared widgets: AppCard, EmotionSpirit, MindSpaceButton
  features/auth/       # S1 Auth screen
  features/home/       # S2 Home screen
  features/chat/       # S3 Chat modal
  features/reflection/ # S4 Post-chat + S8 Read-only reflection
  features/history/    # S5 Timeline + S6 Arcs grid
  features/arc_detail/ # S7 Arc Detail + Arc Analysis
  features/settings/   # S9 Settings
  services/            # Supabase, LLM, Arc service

## Design tokens — ALWAYS use these, never hardcode hex
```dart
// Colors
AppColors.bgPrimary      // #0D0D0D
AppColors.bgCard         // #151517
AppColors.bgElevated     // #1C1C1F
AppColors.textPrimary    // #F5F5F7
AppColors.textSecondary  // #9B9BA0
AppColors.textTertiary   // #5A5A60
AppColors.accentPurple   // #6C5CE7
AppColors.accentGreen    // #00C48C
AppColors.accentOrange   // #F39C12
AppColors.accentBlue     // #5B8DEF
AppColors.accentRed      // #E74C3C
AppColors.border         // #2A2A2E

// Spacing
AppSpacing.xs = 4.0
AppSpacing.sm = 8.0
AppSpacing.md = 16.0
AppSpacing.lg = 24.0
AppSpacing.xl = 32.0

// Radius
AppRadius.sm = 8.0AppRadius.md = 12.0
AppRadius.lg = 16.0
AppRadius.xl = 20.0
```

## Emotion spirits — 6 total
| id | name        | color token           | animation  |
|----|-------------|-----------------------|------------|
| 1  | anxious     | AppColors.accentPurple | fastPulse |
| 2  | calm        | AppColors.accentGreen  | slowBreath |
| 3  | frustrated  | AppColors.accentOrange | mediumPulse|
| 4  | sad         | AppColors.accentBlue   | slowDrop   |
| 5  | hopeful     | Color(0xFFA8E063)      | rising     |
| 6  | overwhelmed | Color(0xFFE17055)      | chaotic    |

## EFT processing stages (Arc model field)
forming → venting → stabilizing → processing → shifting → integrating

## Screen IDs for reference
S0=Onboarding, S1=Auth, S2=Home, S3=Chat(modal),
S4=Reflection(modal), S5=Timeline, S6=Arcs, S7=ArcDetail,
S8=ReflectionReadOnly, S9=Settings,
M1=CrisisCard, M2=AddPastChat, M3=EditArc

## Key UX rules — ALWAYS follow
- Dark theme only. Background always AppColors.bgPrimary
- Card borders: 0.5px, AppColors.border, radius AppRadius.lg
- NO drop shadows anywhere
- Sage messages: left-aligned, NO bubble, just text on bg
- User messages: right-aligned, gradient bubble (accentPurple→accentBlue)
- Bottom tab bar: 3 tabs only (Home, History, Settings) + center FAB
- Swipe left on session rows = flutter_slidable with Remove+Delete actions
- Long press on Arc cards = PopupMenuButton with Open/Rename/Archive/Delete
- Never show the H-xx debug labels in production widgets
- Swipe down dismisses all full-screen modals (enableDrag: true)

## What NOT to build
- No drag-and-drop organize mode (H-12) — use tap-to-assign instead
- No passcode lock (not in scope)
- No voice input (v2 only)
- No light mode

## Analysis types — use exact naming
- "Session Reflection" = post-chat card, always auto-generated (S4)
- "Arc Analysis" = per-arc, user-initiated, ≥3 sessions (S7/H-16)
- Never call them "insight" or "macro" in user-facing strings

## When creating a new screen
1. Create file at lib/features/{feature}/{screen_name}_screen.dart
2. Create a Riverpod provider if screen needs state
3. Add route to lib/core/router/app_router.dart
4. Never use setState — always Riverpod
5. Use go_router for navigation (context.push, context.pop, context.go)

## Gestures to always implement on list rows
Use flutter_slidable package:
- Session rows: swipe left → [SlidableAction(Remove from Arc, orange), SlidableAction(Delete, red)]
- Arc cards: swipe left → [SlidableAction(Archive, green), SlidableAction(Delete, red)]