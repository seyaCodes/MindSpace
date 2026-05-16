# MindSpace — Flutter Developer Master Guide
**Senior-level build roadmap for a beginner-to-intermediate Flutter dev**
Version 1.0 | Based on all 6 project documents + UX decisions

---

## HOW TO READ THIS FILE

This document is your single source of truth for building MindSpace.
Read it top to bottom once before writing a single line of code.
Then use it as a checklist — tick off every item as you complete it.

Four principles drive every decision below:
1. **Build shells first, fill with real data later** — never let missing backend block UI progress
2. **Reusable components are your foundation** — build them before any screen
3. **State management from day one** — Riverpod providers, not setState, everywhere
4. **Never hard-code colors, sizes, or strings inline** — tokens live in one file

---

## PART 1 — COMPLETE SCREEN & VARIANT INVENTORY

Every screen, every variant, every interactive state. Nothing left out.

---

### S0 — Onboarding

**Shown:** first launch only (check `onboarding_completed` in Supabase profiles)

**Pages inside (PageView — 3 slides):**
- [ ] Slide 1 — tagline + ambient spirit orb (neutral state, slow pulse)
- [ ] Slide 2 — what Arcs are (simple visual metaphor, no jargon)
- [ ] Slide 3 — privacy promise + "Get Started" CTA → navigates to S1

**Interactive elements:**
- [ ] Page dots indicator (3 dots, active dot = --accent-purple)
- [ ] Swipe left/right gesture to change slides
- [ ] Skip button (ghost, top-right, jumps to slide 3)
- [ ] "Get Started" primary button on slide 3 only

**Variants:**
- [ ] Default (not-seen state — first ever launch)
- *(If user is already signed in, this screen never shows — router skips it)*

---

### S1 — Auth

**Shown:** after onboarding OR when session expires

**Variants:**
- [ ] Default state — two buttons: "Continue with Google", "Continue with Email"
- [ ] Email input state — text field appears below "Continue with Email" tap, + "Send Magic Link" button
- [ ] Email sent state — confirmation message: "Check your inbox", back button
- [ ] Session expired state — same UI + muted banner at top: "Please sign in again"
- [ ] Account deleted state — same UI + toast: "Your account has been removed"
- [ ] Loading state — subtle LinearProgressIndicator at top of screen (not a centered spinner)

**Interactive elements:**
- [ ] Google OAuth button (calls Supabase signInWithOAuth)
- [ ] Email field (TextFormField, keyboard type = email, auto-focus)
- [ ] "Send Magic Link" button → triggers Supabase sendOTP
- [ ] Error handling: show SnackBar for network errors, invalid email, rate limit

---

### S2 — Home

**This is the emotional heartbeat of the app. Design the empty state first.**

**Variants:**
- [ ] Empty state — first-time user, no arcs, no sessions
- [ ] Populated state — has arcs, has a most-recent spirit
- [ ] Loading state — skeleton shimmer on arc cards, neutral orb

**Sections (top to bottom):**
- [ ] Status bar area (dark, matches --bg-primary)
- [ ] Greeting text — "Morning, Seya." (Display size, 34–40sp, weight 700)
- [ ] Date line — "Friday, April 24" (Label, 12–14sp, --text-secondary)
- [ ] Ambient spirit orb — 120–140px, centered or top-left dominant, continuous breath animation
- [ ] Sub-greeting — "Pick up where you left off, or start fresh" (--text-secondary)
- [ ] "Open threads" section header + "view all" link (right-aligned)
- [ ] Arc cards grid — 2-column, max 4 shown (3 arcs + 1 new thread card)
- [ ] Bottom tab bar (Home, History, +FAB, -, Settings — 5 slots)

**Arc card (inside the grid):**
- [ ] Default — arc color folder icon + arc name + relative date ("2d ago")
- [ ] New Thread card — circle with + icon, "New Thread" label below
- [ ] Long-press on arc card — shows context menu: "View Arc", "Start Chat", "Archive"

**Interactive elements:**
- [ ] Tap arc card → S7 Arc Detail
- [ ] Tap "New Thread" → S3 Chat (free chat mode)
- [ ] Tap "view all" → S6 Arcs Grid (full screen)
- [ ] Tap ambient orb → no navigation (it's decorative, not interactive)
- [ ] Center FAB (+) in bottom nav → same as New Thread → S3 Chat
- [ ] Tab bar: Home (active), History, Settings

**Empty state specific:**
- [ ] Neutral orb (gray/dim), no arc cards section, single CTA: "Start your first conversation"

---

### S3 — Chat

**Full-screen modal — slides up from bottom, hides tab bar entirely.**

**Two modes (visually slightly different):**
- [ ] Free chat mode — header shows only "Sage" + phase indicator
- [ ] Arc chat mode — header shows "Sage" + arc name pill (arc color dot + name)

**Variants by state:**
- [ ] Initial / waiting — Sage greeting message visible, input field focused
- [ ] Typing state — user typing in input bar
- [ ] Sage streaming — Sage text appears token by token (no bubble, floating left-aligned text)
- [ ] Wrap Up visible — after 4+ user messages, "Wrap Up" pill appears top-right
- [ ] Loading (post-Wrap Up) — full-screen loading: spirit orb + "Sage is sitting with this..."
- [ ] Offline state — soft banner at top: "You're offline. Sage will reply when you're back."
- [ ] Crisis state — M1 bottom sheet slides up over chat

**Message layout:**
- [ ] User message — right-aligned, --bg-elevated bubble, --text-primary, 16sp
- [ ] Sage message — LEFT-ALIGNED, NO BUBBLE, floating on --bg-primary, 16sp, --text-primary
- [ ] Sage typing indicator — 3 animated dots (while streaming has not started yet)
- [ ] System message — centered, small, --text-tertiary (e.g. "Session started")

**Input bar (bottom):**
- [ ] --bg-elevated container, rounded pill shape
- [ ] Mic icon (left, --text-secondary) — inactive in v1, visual only
- [ ] TextField (flex, multiline up to 4 lines, then scrolls)
- [ ] Send button (right, --accent-purple arrow icon) — disabled when field is empty

**Header:**
- [ ] Back/close button (X — top left, goes back to Home)
- [ ] "Sage" title + "· Listening" phase indicator (--text-secondary, italic or mono)
- [ ] Arc pill (only in Arc mode) — colored dot + arc name, centered below title
- [ ] "Wrap Up" pill — top right, --accent-purple background, appears after 4 user messages
- [ ] "..." menu (top right, BEFORE wrap up appears) — bottom sheet: current arc info, view past sessions

**"..." menu bottom sheet contents:**
- [ ] Arc name + spirit icon (if in arc mode), or "Unassigned" if free chat
- [ ] "View past sessions in this Arc" → another bottom sheet with session list
- [ ] "This feels like it belongs to..." → opens M3 Edit Arc for pre-routing

---

### S4 — Post-Chat Reflection

**Full-screen modal — replaces S3 after loading completes. Cannot go back to S3.**

**Variants:**
- [ ] Loading state — spirit orb pulsing + "Sage is sitting with this..." (2–6s)
- [ ] Loaded state — cascade animation reveals all content
- [ ] Error state — retry card: "Sage couldn't finish reflecting. [Try again] [Skip]"
- [ ] moment_of_clarity present — extra section between question and shared perspective
- [ ] moment_of_clarity null — that section simply doesn't render

**Content sections (rendered via cascade animation):**
- [ ] Spirit orb — 120px, centered, animates per spirit type — FIRST (300ms fade-in)
- [ ] Spirit tooltip — one-time only, 3-second auto-dismiss (stored in SharedPreferences)
- [ ] `what_sage_heard` — body text, --text-primary, 16–18sp — SECOND (200ms delay)
- [ ] `question_to_sit_with` — italic or slightly distinct style, --text-secondary — THIRD (400ms delay)
- [ ] `moment_of_clarity` — if present, soft bordered card — between question and shared perspective
- [ ] `shared_perspective` card — distinct soft border color (warmer tint, not --border), small label "A shared perspective" above in --text-tertiary — FOURTH (600ms delay)
- [ ] Arc update line — "This started a new Arc: [Name]" OR "This deepened: [Arc name] ([N] sessions)" — at bottom, muted, --text-secondary, colored arc dot
- [ ] "Save Reflection & Continue" — primary CTA, full-width, pinned to bottom

**Interactive elements:**
- [ ] "Save Reflection & Continue" → saves to DB (if not already saved) → navigate to S2 Home
- [ ] Spirit tooltip dismisses after 3s (also dismisses on tap)
- [ ] No back navigation — the chat is over

---

### S5 — History: Timeline

**Default view of the History tab.**

**Layout:**
- [ ] Segmented control at top: "Timeline" | "Arcs" | "Insights" (3 segments)
- [ ] Emotion filter chips (horizontal scroll row below segmented control): All, Anxious, Calm, Frustrated, Sad, Hopeful, Overwhelmed
- [ ] Weekly group headers (sticky): "This week", "May 5–11", etc.
- [ ] Reflection rows (see below)
- [ ] Activity toggle button (top-right icon) → switches to weekly bubble calendar view

**Reflection row:**
- [ ] Arc color dot (4px wide left-edge accent bar OR colored circle dot, left side)
- [ ] Spirit icon (small, 16–18px)
- [ ] Date + time (--text-secondary, Label size)
- [ ] First line of `what_sage_heard` (--text-primary, truncated at 1 line)
- [ ] Arc name pill (--text-tertiary, small, right side)
- [ ] Chevron right (→)

**Weekly bubble calendar view (toggle):**
- [ ] 7 circles per row (7 days of the week), rows = weeks
- [ ] Empty day = faint ring only
- [ ] Session day = dominant Arc color filled circle
- [ ] Multiple sessions = dominant Arc color fill + up to 2 smaller satellite dots orbiting edge
- [ ] 3+ sessions = 2 satellites + "+N" label
- [ ] Tap a circle → shows sessions for that day as a mini bottom sheet

**Variants:**
- [ ] Empty state — spirit illustration + "Your reflections will appear here"
- [ ] Loading state — skeleton shimmer rows
- [ ] Filtered (emotion chip selected) — only matching rows show
- [ ] No results for filter — "No [Emotion] sessions yet"

**Interactive elements:**
- [ ] Tap reflection row → S8 Reflection Read-Only
- [ ] Tap emotion chip → filters list
- [ ] Tap "All" chip → clears filter
- [ ] Toggle calendar view → switches layout
- [ ] Segmented control → switches to S6 or Insights view (same screen, swap child widget)

---

### S6 — History: Arcs Grid

**Accessed via History tab segmented control (segment 2).**

**Layout:**
- [ ] Segmented control (same as S5, segment 2 active)
- [ ] 2-column grid of Arc cards
- [ ] "Archived Chapters (N)" collapsible section divider below active arcs
- [ ] Archived arc cards — 40% opacity, grayscale filter

**Arc card (in grid):**
- [ ] Arc color background (gradient tint, not solid fill) OR arc color folder icon
- [ ] Arc name (Heading size)
- [ ] Dominant spirit icon row (up to 3 most recent spirits as small icons)
- [ ] Session count + last session date
- [ ] Processing stage label (forming / venting / stabilizing / etc.) — mono font, --text-tertiary
- [ ] Long-press → context menu: "Edit Arc", "Archive Arc", "Delete Arc"

**Variants:**
- [ ] Default (active arcs visible, archived section collapsed)
- [ ] Archived section expanded
- [ ] Empty state — drifting faded spirits + "Arcs form when conversations cluster around a theme..."
- [ ] Loading state — skeleton cards

**Interactive elements:**
- [ ] Tap arc card → S7 Arc Detail
- [ ] Tap "Archived Chapters" divider → toggles collapsed/expanded
- [ ] Long-press arc card → ContextMenu or showModalBottomSheet with options
- [ ] Archive CTA inside options → animates card to archived section (400ms fade + dim)

---

### S7 — Arc Detail

**Pushed screen (not a modal). Accessed from S6 grid or Home arc card.**

**Sections (top to bottom):**
- [ ] Back button (← Ghost button, "← Arcs")
- [ ] Arc color header area (tinted, not solid)
- [ ] Arc name — tappable inline (becomes TextField on tap, blurs to save, sets user_renamed=true)
- [ ] Dominant spirit icon (large, ~48px) + processing stage label (mono font)
- [ ] Stats row: "[N] sessions" + "Last: [relative date]" + Arc color swatch (tappable → color picker)
- [ ] Emotional journey snake (see below)
- [ ] Session list (below the snake, each row is a session)
- [ ] Arc Insight section (below session list) — locked or unlocked CTA, then insight card
- [ ] "Continue this Arc →" button — primary CTA, sticky bottom bar

**Emotional journey snake:**
- [ ] Spirit icons (20px each), connected by 0.5px line
- [ ] Ordered chronologically left to right (or top to bottom if >5 sessions)
- [ ] Tap a spirit node → mini card slides up: spirit name + what_sage_heard one-liner + date
- [ ] Tap that card → pushes S8 Read-Only Reflection

**Session list rows:**
- [ ] Spirit icon (small) + date + first line of what_sage_heard
- [ ] Chevron → opens S8
- [ ] Swipe-left → "Move to Arc" action (opens M3 Edit Arc)

**Arc Insight section — LOCKED state (<3 sessions):**
- [ ] Disabled button: "Generate Arc Analysis"
- [ ] Muted subtitle: "Sage needs at least 3 sessions. You have [N]."
- [ ] No pulse animation

**Arc Insight section — UNLOCKED state (≥3, no insight yet):**
- [ ] Pulsing CTA button: "Generate Arc Analysis" (--accent-purple, pulse animation)
- [ ] Tap → loading state (spirit orb + "Sage is reviewing this Arc..." 5–10s)

**Arc Insight section — INSIGHT EXISTS:**
- [ ] Section header: "How this story moved" + how_it_evolved text
- [ ] Section header: "A pattern Sage noticed" + dominant spirit icon + pattern_noticed text (slightly different background --bg-elevated)
- [ ] Metadata line: "Based on [N] sessions · [date generated]" (--text-tertiary, small)
- [ ] Ghost button: "Regenerate" — ONLY visible if session_count has changed since generation
- [ ] Freeform text input: "Add your own reflection on this..." (--bg-card, placeholder text, stores in separate field)

**Arc customization:**
- [ ] Tapping arc name → inline TextField (save on blur)
- [ ] Tapping color swatch → color picker bottom sheet (6 swatches, emotion palette)
- [ ] Long-press arc name → Edit mode with delete option

**Interactive elements:**
- [ ] "Continue this Arc →" → S3 Chat (arc mode, this arc's ID)
- [ ] Tap session row → S8
- [ ] Swipe session row → M3
- [ ] Tap spirit node in snake → mini preview card
- [ ] Tap mini preview card → S8
- [ ] Generate CTA → loading → insight reveals
- [ ] Color swatch → M (color picker bottom sheet)
- [ ] Arc name tap → inline edit

---

### S8 — Reflection Read-Only

**Pushed screen. Accessed from Timeline, Arc Detail snake, session list.**

**This is identical to S4 content but without animations and without the CTA.**

- [ ] Back button (←)
- [ ] Spirit orb (80–100px, still animates)
- [ ] Date + Arc name pill header
- [ ] `what_sage_heard`
- [ ] `question_to_sit_with`
- [ ] `moment_of_clarity` (if not null)
- [ ] `shared_perspective` card
- [ ] Arc info footer: which arc, session number in arc (e.g. "Session 3 of 5 in The Job Hunt")
- [ ] No CTA — no edits — pure read

**Variants:**
- [ ] Unassigned reflection (arc was deleted) — no arc footer
- [ ] Loading state — skeleton

---

### S9 — Settings

**Tab root. Minimal.**

- [ ] Account section: email address (read-only, --text-secondary)
- [ ] "Sign Out" button — secondary style, triggers Supabase signOut + navigate to S1
- [ ] "Export Data" button — secondary style, triggers JSON download of user data
- [ ] "Delete Account" button — destructive style (--accent-red border + text)
  - [ ] Confirmation dialog: "This will permanently delete all your data. This cannot be undone." + Cancel + Delete (red)
  - [ ] On confirm: cascading delete via Supabase + navigate to S1 with "deleted" toast

**Variants:**
- [ ] Default
- [ ] Delete confirmation dialog open
- [ ] Loading (delete in progress) — show progress indicator inside button

---

### M1 — Crisis Resources Card (Bottom Sheet)

**Slides up OVER S3 chat. Cannot be dismissed by swipe — only by "I'm safe" button.**

- [ ] Handle bar (standard)
- [ ] Calm headline: "You're not alone right now."
- [ ] Brief warm message (pre-written, not LLM-generated)
- [ ] Resources list:
  - [ ] SAMU Algeria: 15
  - [ ] Oran emergency resources (localized)
  - [ ] International: can add
- [ ] "I'm safe, continue" button — returns to chat with M1 dismissed
- [ ] Resources are tappable (phone links)

**This sheet CANNOT be dismissed by swiping down. Only via the button.**

---

### M2 — Add Past Chat Sheet

**Bottom sheet over S7 Arc Detail. Pulls unassigned sessions into this arc.**

- [ ] Handle bar
- [ ] Title: "Add sessions to this Arc"
- [ ] Multi-select list: each row = date + spirit icon + first line of what_sage_heard + checkbox
- [ ] "Unassigned" section header + sessions with `arc_id = null`
- [ ] "From other Arcs" section header + sessions from other arcs (with their arc name)
- [ ] "Add selected ([N])" primary CTA — disabled if 0 selected
- [ ] Cancel ghost button

---

### M3 — Edit Arc Bottom Sheet

**Slides up over S7 or from session swipe in S7.**

- [ ] Handle bar
- [ ] Title: "Move this session"
- [ ] Current arc (highlighted, checked)
- [ ] List of other active arcs (radio select)
- [ ] "Create new Arc" option at bottom
- [ ] "Confirm" primary CTA
- [ ] Cancel ghost button

---

### History: Insights View (S5 segment 3)

- [ ] Segmented control (segment 3 active)
- [ ] Activity heatmap (12-week grid, see Part 3 for spec)
- [ ] Insight cards list (below heatmap)
- [ ] Each card: arc color left-edge bar + arc name + dominant spirit + session count + date generated + first 80 chars of pattern_noticed
- [ ] Tap card → expands inline (AnimatedContainer) showing full how_it_evolved + pattern_noticed + user note
- [ ] Empty state: "Arc analyses appear here once you generate them from an Arc with 3 or more sessions."
- [ ] Loading: skeleton shimmer

---

## PART 2 — REUSABLE COMPONENTS (build these before any screen)

These are widgets you will use 2+ times. Build them once, test them, then never re-implement inline.

### 2A — Design Token File (build FIRST, before any widget)

**`lib/core/theme/app_theme.dart`**

```dart
// Every color, size, font, radius — NOTHING hardcoded in widgets
class AppColors {
  static const bgPrimary    = Color(0xFF0D0D0D);
  static const bgCard       = Color(0xFF151517);
  static const bgElevated   = Color(0xFF1C1C1F);
  static const textPrimary  = Color(0xFFF5F5F7);
  static const textSecondary= Color(0xFF9B9BA0);
  static const textTertiary = Color(0xFF5A5A60);
  static const accentPurple = Color(0xFF6C5CE7);
  static const accentGreen  = Color(0xFF00C48C);
  static const accentOrange = Color(0xFFF39C12);
  static const accentBlue   = Color(0xFF5B8DEF);
  static const accentRed    = Color(0xFFE74C3C);
  static const border       = Color(0xFF2A2A2E);
  // Spirit colors
  static const spiritAnxious    = Color(0xFF6C5CE7);
  static const spiritCalm       = Color(0xFF00C48C);
  static const spiritFrustrated = Color(0xFFF39C12);
  static const spiritSad        = Color(0xFF5B8DEF);
  static const spiritHopeful    = Color(0xFFA8E063);
  static const spiritOverwhelmed= Color(0xFFE17055);
}

class AppRadius {
  static const double sm  = 8.0;
  static const double md  = 12.0;
  static const double lg  = 16.0;
  static const double xl  = 20.0;
  static const double full= 999.0;
}

class AppSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
}
```

**`lib/core/constants/spirits.dart`**

```dart
enum SpiritType { anxious, calm, frustrated, sad, hopeful, overwhelmed }

class SpiritDefinition {
  final int id;
  final SpiritType type;
  final String name;
  final Color color;
  final String animationType; // 'fast_pulse', 'slow_breath', 'medium_pulse', etc.
  // ...
}

// Seed data — matches emotion_spirits table in DB
const List<SpiritDefinition> kSpirits = [ ... ];
```

---

### 2B — Core Reusable Widgets

Build these in this exact order:

#### 1. `EmotionSpiritOrb` widget
**Location:** `lib/core/components/emotion_spirit_orb.dart`
**Props:** `SpiritType type`, `double size`, `bool animate`
**What it does:** Renders the animated orb. Different animation per spirit type using `flutter_animate`. This is the most important widget in the app — used on S2, S4, S7, S8, loading states everywhere.
**Variants:**
- Animated (home, S4, loading)
- Static (small, in lists)
- Neutral/gray (empty state)

#### 2. `AppCard` widget
**Location:** `lib/core/components/app_card.dart`
**Props:** `Widget child`, `EdgeInsets? padding`, `VoidCallback? onTap`
**What it does:** A card with --bg-card background, 0.5px --border, radius 16px, 16/14px padding. Wraps any content. Used everywhere.

#### 3. `MindSpaceButton` widget
**Location:** `lib/core/components/mind_space_button.dart`
**Props:** `String label`, `VoidCallback? onPressed`, `ButtonVariant variant`
**Enum ButtonVariant:** `primary`, `secondary`, `destructive`, `ghost`
**What it does:** All four button styles from the design brief. `onPressed = null` auto-disables with reduced opacity.

#### 4. `ArcCard` widget
**Location:** `lib/core/components/arc_card.dart`
**Props:** `Arc arc`, `VoidCallback onTap`
**What it does:** The 2-column grid card for arcs. Used in S2 home grid and S6 arc grid. Arc color tint background, name, spirit icons row, date, session count.

#### 5. `SpiritIcon` widget
**Location:** `lib/core/components/spirit_icon.dart`
**Props:** `SpiritType type`, `double size`
**What it does:** Small non-animated spirit representation for lists, snake, chips.

#### 6. `ReflectionRow` widget
**Location:** `lib/core/components/reflection_row.dart`
**Props:** `Reflection reflection`, `VoidCallback onTap`
**What it does:** The Timeline list row. Arc color dot + spirit icon + date + what_sage_heard preview + arc pill.

#### 7. `AppBottomSheet` wrapper
**Location:** `lib/core/components/app_bottom_sheet.dart`
**Props:** `Widget child`, `String? title`
**What it does:** Standard bottom sheet container: --bg-elevated, radius 20px (top only), handle bar (4×32px, --text-tertiary, 8px from top).
**Usage:** `showModalBottomSheet(context, builder: (_) => AppBottomSheet(child: ..., title: ...))`

#### 8. `LoadingOverlay` widget
**Location:** `lib/core/components/loading_overlay.dart`
**Props:** `String message`, `SpiritType? spiritType`
**What it does:** Full-screen dark overlay with spirit orb + message text. Used during Wrap Up processing and Arc insight generation.

#### 9. `SkeletonLoader` widget
**Location:** `lib/core/components/skeleton_loader.dart`
**Props:** `double width`, `double height`, `double? borderRadius`
**What it does:** Shimmer animation for loading states. One reusable widget covers all skeleton needs.

#### 10. `ArcColorDot` widget
**Location:** `lib/core/components/arc_color_dot.dart`
**Props:** `Color color`, `double size`
**What it does:** The small colored dot that appears next to arc names everywhere.

---

### 2C — Mock Data Layer (build alongside widgets, before Supabase)

**`lib/core/mock/mock_data.dart`**

```dart
// Static mock objects for every model type
// Use these during widget development
// Replace with real Supabase calls only after all UI is done

final mockUser = Profile(id: 'mock-user', displayName: 'Seya', ...);

final mockArcs = [
  Arc(id: '1', name: 'The Job Hunt',    color: AppColors.accentPurple, sessionCount: 3, ...),
  Arc(id: '2', name: 'Family',          color: AppColors.accentBlue,   sessionCount: 2, ...),
  Arc(id: '3', name: 'Relationships',   color: AppColors.accentGreen,  sessionCount: 1, ...),
];

final mockReflections = [ ... ];
final mockMessages    = [ ... ];
final mockInsight     = ArcInsight(howItEvolved: '...', patternNoticed: '...');
```

**Rule:** Every screen should work 100% with mock data before you connect Supabase. This means you can build and test the full UI in 7 days, then spend days 8–15 on the backend wiring without touching the widget code.

---

## PART 3 — DATA MODELS (Dart classes)

Create one file per model in `lib/models/`.

```
lib/models/
  profile.dart
  arc.dart
  chat.dart
  message.dart
  reflection.dart
  arc_insight.dart
  emotion_spirit.dart
```

Each model needs:
- `fromJson(Map<String, dynamic> json)` factory constructor
- `toJson()` method
- `copyWith(...)` method (for Riverpod state updates)
- All nullable fields properly typed as `String?`, `DateTime?` etc.

**Arc model — key fields:**
```dart
class Arc {
  final String id;
  final String userId;
  final String name;
  final bool userRenamed;      // if true, never let LLM rename
  final String colorHex;
  final int? dominantSpiritId;
  final int sessionCount;
  final String processingStage; // 'forming' | 'venting' | 'stabilizing' | ...
  final String status;          // 'active' | 'archived'
  final DateTime lastSessionAt;
  // centroid_embedding NOT in Dart model — never sent to client
}
```

**Reflection model — key fields:**
```dart
class Reflection {
  final String id;
  final String chatId;
  final String? arcId;
  final int spiritId;
  final String whatSageHeard;
  final String? questionToSitWith;
  final String? sharedPerspective;
  final String? momentOfClarity;
  final String? processingStageAtCreation;
  final DateTime createdAt;
  // embedding vector NOT in Dart model — never sent to client
}
```

---

## PART 4 — RIVERPOD PROVIDERS ARCHITECTURE

**Never use setState for app data. Use Riverpod providers from day one.**

```
lib/features/
  auth/
    providers/auth_provider.dart          → StreamProvider<User?>
  home/
    providers/home_provider.dart          → FutureProvider<List<Arc>> (recent arcs)
  chat/
    providers/chat_provider.dart          → StateNotifierProvider<ChatNotifier, ChatState>
    providers/current_arc_provider.dart   → StateProvider<Arc?> (which arc we're chatting in)
  reflection/
    providers/reflection_provider.dart    → StateProvider<Reflection?> (current reflection)
  history/
    providers/timeline_provider.dart      → FutureProvider<List<Reflection>>
    providers/arcs_provider.dart          → FutureProvider<List<Arc>>
    providers/insights_provider.dart      → FutureProvider<List<ArcInsight>>
  arc_detail/
    providers/arc_detail_provider.dart    → FutureProvider<Arc>
    providers/arc_insight_provider.dart   → StateNotifierProvider<InsightNotifier, InsightState>
```

**ChatState class (most complex provider):**
```dart
class ChatState {
  final List<Message> messages;
  final bool isLoading;        // Sage is generating
  final bool isWrappingUp;     // post-Wrap Up loading
  final bool canWrapUp;        // 4+ user messages sent
  final String? error;
  final Arc? currentArc;       // null = free chat
}
```

---

## PART 5 — ROUTING (GoRouter)

**`lib/core/router/app_router.dart`**

```dart
// Routes
/                  → redirect based on auth + onboarding state
/onboarding        → S0OnboardingScreen
/auth              → S1AuthScreen
/home              → S2HomeScreen (ShellRoute with bottom nav)
/history/timeline  → S5TimelineScreen
/history/arcs      → S6ArcsGridScreen
/history/insights  → SInsightsScreen
/settings          → S9SettingsScreen
/arc/:arcId        → S7ArcDetailScreen
/reflection/:id    → S8ReflectionReadOnlyScreen
/chat              → S3ChatScreen (fullScreenDialog: true)
/reflection/new    → S4ReflectionScreen (fullScreenDialog: true)
```

**Bottom nav lives in a ShellRoute wrapping Home, History, Settings.**
Chat and Reflection are fullScreenDialog routes — they slide up and have no bottom nav.

**Redirect logic:**
```dart
redirect: (context, state) {
  final isLoggedIn = ref.read(authProvider).value != null;
  final onboardingDone = prefs.getBool('onboarding_complete') ?? false;
  if (!onboardingDone) return '/onboarding';
  if (!isLoggedIn) return '/auth';
  return null; // go to intended route
}
```

---

## PART 6 — BUILD ORDER (day-by-day, beginner-safe)

**The rule: Never connect real backend until the UI is complete and tested with mock data.**

### PHASE 0 — Foundation (do this before any screen, 1 day)
1. [ ] `flutter create mind_space` — run on physical device, confirm it works
2. [ ] Add all packages to `pubspec.yaml`:
   - `supabase_flutter`, `flutter_riverpod`, `go_router`, `flutter_animate`, `flutter_dotenv`, `http`, `shared_preferences`, `google_fonts`
3. [ ] Create `lib/core/theme/app_theme.dart` — all color tokens, spacing, radius
4. [ ] Create `lib/core/constants/spirits.dart` — spirit definitions
5. [ ] Create `lib/models/` — all model classes with mock constructors
6. [ ] Create `lib/core/mock/mock_data.dart` — mock lists for every model
7. [ ] Set up GoRouter with all routes (each route points to a placeholder `Scaffold` for now)
8. [ ] Apply `AppTheme` to `MaterialApp.router` — dark theme, Inter font, correct background color
9. [ ] Confirm: app launches, shows placeholder screens, routing works, bottom nav visible

### PHASE 1 — Reusable components (1 day)
10. [ ] Build `EmotionSpiritOrb` — test all 6 spirits + neutral + sizes
11. [ ] Build `AppCard`
12. [ ] Build `MindSpaceButton` — all 4 variants
13. [ ] Build `SpiritIcon`
14. [ ] Build `ArcCard` — using mock Arc data
15. [ ] Build `ReflectionRow`
16. [ ] Build `AppBottomSheet` wrapper
17. [ ] Build `LoadingOverlay`
18. [ ] Build `SkeletonLoader`
19. [ ] Build `ArcColorDot`
20. [ ] Create a temporary `ComponentTestScreen` route — place all components on one screen to visually verify them

### PHASE 2 — Static screens with mock data (3 days)
Build every screen top-to-bottom with mock data. No Supabase yet.

21. [ ] S0 Onboarding — 3 slides, animations, "Get Started" navigates to S1
22. [ ] S1 Auth — UI only (buttons don't call Supabase yet, just navigate to S2)
23. [ ] S2 Home — both empty and populated variants using mock arcs
24. [ ] S9 Settings — static layout, buttons log to console
25. [ ] S6 Arc Grid — mock arc cards, archived section toggle
26. [ ] S7 Arc Detail — mock arc, mock sessions, snake, locked/unlocked insight states
27. [ ] S8 Reflection Read-Only — mock reflection content
28. [ ] S5 History Timeline — mock reflection rows, filter chips work (filter mock data locally)
29. [ ] S5 History Insights — heatmap (with mock date/count data), mock insight cards
30. [ ] S3 Chat — mock messages list, input bar functional, message sending adds to local list, "Wrap Up" pill appears after 4 mock messages
31. [ ] S4 Reflection — cascade animation, all 5 content sections, "Save & Continue" navigates to S2
32. [ ] M1 Crisis Sheet — static, "I'm safe" dismisses it
33. [ ] M2 Add Past Chat Sheet — mock session list, multi-select works
34. [ ] M3 Edit Arc Sheet — mock arc list, selection works

**At this point: the entire app is navigable with mock data. Show it to someone.**

### PHASE 3 — Supabase auth + profiles (1 day)
35. [ ] Create Supabase project, save URL + anon key in `.env`
36. [ ] Connect `supabase_flutter` in `main.dart`
37. [ ] Replace S1 Auth buttons with real Supabase calls
38. [ ] Set up auth stream provider → auto-navigate on sign-in/sign-out
39. [ ] Test: sign in, profile auto-created via trigger, sign out, session expiry redirect
40. [ ] Add RLS test: two accounts cannot see each other's data

### PHASE 4 — Chat + streaming (2 days)
41. [ ] Write `chat-stream` Edge Function (Deno/TypeScript) — deploy to Supabase
42. [ ] Write `safety-check` Edge Function — deploy
43. [ ] Replace mock chat send with real SSE stream consumption
44. [ ] Implement streaming: `Stream<String>` → append tokens to `ChatState.messages`
45. [ ] Test streaming: send a message, watch tokens arrive one by one
46. [ ] Implement Wrap Up → end-chat Edge Function call
47. [ ] Display real reflection in S4 from API response
48. [ ] Connect crisis flow: safety-check returns CRISIS → M1 slides up

### PHASE 5 — Embeddings + Arc assignment (1 day)
49. [ ] Write `embed-text` Edge Function
50. [ ] Write `assign-arc` Edge Function with cosine similarity logic
51. [ ] Wire into `end-chat` pipeline: after reflection, embed, assign, return arc_id
52. [ ] S4 now shows real arc name in footer
53. [ ] S2 Home now shows real arc cards from DB

### PHASE 6 — Arc insight generation (1 day)
54. [ ] Write `generate-arc-insight` Edge Function (OpenRouter, deepseek-r1)
55. [ ] Wire S7 "Generate" CTA to real Edge Function
56. [ ] Implement caching check in Edge Function
57. [ ] Real insight appears in S7, and in S5 Insights view

### PHASE 7 — History, settings, export (1 day)
58. [ ] Wire S5 Timeline to real reflections query (with pagination if needed)
59. [ ] Wire S6 Arcs Grid to real arcs query
60. [ ] Wire S5 Insights to real arc_insights query
61. [ ] Wire activity heatmap to real chat date counts
62. [ ] Implement Settings: sign out, export JSON, delete account

### PHASE 8 — Polish + evaluation (2 days)
63. [ ] All micro-interactions (haptics, cascade animation timing, orb breath)
64. [ ] All empty states wired to real data checks
65. [ ] All error states wired to real API failures
66. [ ] Offline detection banner in S3
67. [ ] Sprint through 30-message eval harness (Day 14 in implementation plan)
68. [ ] Demo mode behind `kDebugMode` flag
69. [ ] Hide all H-xx debug labels behind `kDebugMode`

---

## PART 7 — THINGS BEGINNERS MISS (read this before you start)

### 7A — Flutter-specific gotchas

**`const` constructors everywhere.**
If a widget takes no dynamic props, make it `const`. This prevents unnecessary rebuilds.
```dart
const AppCard(child: SomeStaticContent()); // ✓
AppCard(child: SomeStaticContent());       // ✗ rebuilds on every parent rebuild
```

**`Key` on list items.**
Any list built with `ListView.builder` where items can be reordered or added — always pass `key: ValueKey(item.id)` to list items. Without this, Flutter confuses which item is which and animations break.

**`MediaQuery` for safe areas.**
Always wrap your Scaffold body with `SafeArea` or use `MediaQuery.of(context).padding` to avoid content hiding behind the status bar or home indicator. The bottom nav must sit above the home indicator.

**`TextEditingController` disposal.**
Every `TextEditingController` and `AnimationController` must be created in `initState` and disposed in `dispose`. Forgetting this leaks memory. With Riverpod, prefer `StateNotifier` over `StatefulWidget` when possible.

**`mounted` check after async.**
After any `await`, the widget might have been removed from the tree. Always check `if (!mounted) return;` before calling `setState` or `context.read` after awaiting.
```dart
await someAsyncCall();
if (!mounted) return;  // ← always do this
setState(() { ... });
```

**RenderFlex overflow.**
When you get the yellow/black "overflow" error, it means a `Column` or `Row` child is too big. Wrap it in `Expanded`, `Flexible`, or `SingleChildScrollView`.

**`ListView` inside `Column`.**
You cannot put an unbounded-height `ListView` inside a `Column` directly — Flutter doesn't know how tall to make it. Solution: wrap the `ListView` in an `Expanded` widget inside the `Column`.

### 7B — Riverpod beginner mistakes

**Don't call `ref.watch` inside a callback.**
`ref.watch` is only for use in `build()` methods. Inside button callbacks, use `ref.read`.
```dart
// ✓ Correct
ElevatedButton(onPressed: () => ref.read(chatProvider.notifier).sendMessage(text));
// ✗ Wrong
ElevatedButton(onPressed: () => ref.watch(chatProvider.notifier).sendMessage(text));
```

**Use `AsyncValue` for any async data.**
Supabase queries return futures. Wrap them in `FutureProvider` and handle all 3 states:
```dart
final arcsAsync = ref.watch(arcsProvider);
return arcsAsync.when(
  loading: () => SkeletonLoader(...),
  error:   (e, st) => ErrorWidget(e.toString()),
  data:    (arcs) => ArcGrid(arcs: arcs),
);
```

**`StateNotifier` for complex state.**
If state has multiple fields (like `ChatState`), use `StateNotifier`, not `StateProvider`.
`StateProvider` is fine only for single simple values (a bool, a selected tab index).

### 7C — Supabase beginner mistakes

**Never put SERVICE_ROLE_KEY in Flutter.**
The anon key goes in Flutter (it's public). The service role key goes ONLY in Edge Function secrets. If you put the service role key in Flutter code, anyone can read/write any user's data.

**RLS must be ON before you write data.**
If you write data to a table with RLS off, you'll get rows that no user can read (because RLS will be enforced when you turn it on later). Turn on RLS on every table immediately after creating it.

**Test RLS with two real accounts.**
Don't just test with one account. Create account A and account B. Confirm B cannot query A's arcs. This is the only way to know RLS is actually working.

**SSE streaming in Flutter.**
Groq streaming uses Server-Sent Events (SSE). The `http` package doesn't handle SSE natively. Use the `http` package's `send()` with a `StreamedResponse` and read it as bytes:
```dart
final request = http.Request('POST', uri);
final streamedResponse = await client.send(request);
streamedResponse.stream.transform(utf8.decoder).listen((chunk) {
  // parse SSE chunk: split on '\n', find 'data:' prefix
  final lines = chunk.split('\n');
  for (final line in lines) {
    if (line.startsWith('data: ')) {
      final json = line.substring(6);
      if (json == '[DONE]') return;
      final delta = jsonDecode(json)['choices'][0]['delta']['content'];
      if (delta != null) ref.read(chatProvider.notifier).appendToken(delta);
    }
  }
});
```

**Edge Function cold starts.**
Supabase Edge Functions (Deno) can take 500–1000ms to cold-start. The loading state UX ("Sage is sitting with this...") covers this. Don't add a timeout that's too short.

### 7D — Architecture mistakes to avoid

**Don't put business logic in widgets.**
A widget should only display data and call provider methods. Never put an `if` statement that decides what API to call inside a widget's `build()` method.

**Don't use `Navigator.push` for major navigation.**
Use GoRouter everywhere. Direct `Navigator.push` bypasses the router and breaks deep linking, back button behavior, and auth redirects.

**Don't share a single `TextEditingController` between screens.**
Each screen that has a text field needs its own controller. If you reuse one controller, clearing the chat input will accidentally clear other fields.

**One provider per concern.**
Don't make a single `AppProvider` that holds all state. Split by feature: `ChatProvider`, `ArcsProvider`, `AuthProvider`. When `ChatProvider` updates, only chat widgets rebuild — not the home screen.

---

## PART 8 — FILE STRUCTURE (create this exactly)

```
lib/
├── main.dart
├── core/
│   ├── theme/
│   │   └── app_theme.dart           ← colors, spacing, radius, typography
│   ├── constants/
│   │   └── spirits.dart             ← spirit definitions, enum, color map
│   ├── components/
│   │   ├── emotion_spirit_orb.dart
│   │   ├── app_card.dart
│   │   ├── mind_space_button.dart
│   │   ├── arc_card.dart
│   │   ├── spirit_icon.dart
│   │   ├── reflection_row.dart
│   │   ├── app_bottom_sheet.dart
│   │   ├── loading_overlay.dart
│   │   ├── skeleton_loader.dart
│   │   └── arc_color_dot.dart
│   ├── mock/
│   │   └── mock_data.dart           ← all mock instances
│   └── router/
│       └── app_router.dart          ← GoRouter config
├── models/
│   ├── profile.dart
│   ├── arc.dart
│   ├── chat.dart
│   ├── message.dart
│   ├── reflection.dart
│   ├── arc_insight.dart
│   └── emotion_spirit.dart
├── features/
│   ├── auth/
│   │   ├── screens/auth_screen.dart
│   │   └── providers/auth_provider.dart
│   ├── onboarding/
│   │   └── screens/onboarding_screen.dart
│   ├── home/
│   │   ├── screens/home_screen.dart
│   │   └── providers/home_provider.dart
│   ├── chat/
│   │   ├── screens/chat_screen.dart
│   │   ├── widgets/message_bubble.dart
│   │   ├── widgets/chat_input_bar.dart
│   │   └── providers/chat_provider.dart
│   ├── reflection/
│   │   ├── screens/reflection_screen.dart      ← S4 (animated, post-chat)
│   │   ├── screens/reflection_readonly_screen.dart  ← S8
│   │   └── providers/reflection_provider.dart
│   ├── history/
│   │   ├── screens/history_screen.dart          ← shell with segmented control
│   │   ├── screens/timeline_tab.dart            ← S5
│   │   ├── screens/arcs_grid_tab.dart           ← S6
│   │   ├── screens/insights_tab.dart            ← new insights view
│   │   ├── widgets/activity_heatmap.dart        ← heatmap chart widget
│   │   └── providers/history_provider.dart
│   ├── arc_detail/
│   │   ├── screens/arc_detail_screen.dart       ← S7
│   │   ├── widgets/journey_snake.dart           ← the emotional journey snake
│   │   ├── widgets/arc_insight_card.dart
│   │   └── providers/arc_detail_provider.dart
│   └── settings/
│       ├── screens/settings_screen.dart         ← S9
│       └── providers/settings_provider.dart
└── services/
    ├── supabase_service.dart        ← singleton Supabase client
    ├── edge_function_service.dart   ← all Edge Function callers
    └── arc_service.dart             ← arc assignment + local logic
```

---

## PART 9 — WHAT TO NEVER HARD-CODE

| Thing | Wrong | Right |
|-------|-------|-------|
| Color | `Color(0xFF6C5CE7)` inline in widget | `AppColors.accentPurple` |
| Padding | `padding: EdgeInsets.all(16)` random | `AppSpacing.md` |
| Border radius | `BorderRadius.circular(12)` random | `AppRadius.md` |
| Spirit color | `color: Colors.purple` | `spirit.color` from `SpiritDefinition` |
| Screen strings | `'Morning, Seya.'` with username baked in | Pass username from provider |
| Route strings | `Navigator.push(MaterialPageRoute(...))` | `context.go('/arc/${arc.id}')` |
| API URL | `'https://...'` inline in a widget | In `.env`, accessed via `AppConfig` |
| Processing stage string | `if (stage == 'forming')` inline | Enum `ProcessingStage.forming` |

---

## PART 10 — WHAT TO HARD-CODE (for now, intentionally)

These things don't need abstraction in v1:

- The 6 spirit definitions (they're fixed, not user-configurable)
- The 6 emotion color swatches for the arc color picker (fixed palette)
- The crisis resources (SAMU 15, fixed strings — localized but not dynamic)
- The onboarding slide content (3 slides, fixed copy)
- The processing stage labels and descriptions (enum + static map)
- The EFT stage → Sage behavior description (internal to prompt, not in Flutter)

---

## PART 11 — BACKEND DEPENDENCY MAP

This tells you which UI features you can build without any backend at all.

| Feature | Needs backend? | Can mock? |
|---------|---------------|-----------|
| All screen layouts | ✗ | ✓ fully |
| All animations | ✗ | ✓ fully |
| Navigation + routing | ✗ | ✓ fully |
| Auth sign-in | ✓ Supabase Auth | ✓ mock: skip to home |
| Arc cards on home | ✓ DB query | ✓ use mock arcs |
| Chat messages display | ✗ (local state) | ✓ fully |
| Sage streaming reply | ✓ Edge Function + Groq | ✓ mock: setTimeout + fake stream |
| Reflection card | ✓ end-chat Edge Function | ✓ mock: hardcoded reflection |
| Arc assignment | ✓ assign-arc Edge Function | ✓ mock: always assign to arc[0] |
| Arc insight | ✓ generate-arc-insight + OpenRouter | ✓ mock: hardcoded insight text |
| History timeline | ✓ DB query | ✓ use mock reflections |
| Activity heatmap | ✓ DB aggregation query | ✓ mock: hardcoded date/count map |
| Crisis flow | ✓ safety-check Edge Function | ✓ mock: add debug button that triggers M1 |
| Export data | ✓ DB query + JSON | build last |
| Delete account | ✓ cascading delete | build last |

---

## CRITICAL WARNINGS

**1. Build the reflection cascade animation early.**
It's the emotional peak of the product. Don't leave it for day 12. Do a rough version in Phase 2 and polish it in Phase 8. Using `flutter_animate` package: chain `.fade().slideY().delay()` on each section.

**2. The SSE streaming is the hardest technical piece.**
Test it in isolation first (a simple test screen: one text field, one button, one text widget that streams) before integrating it into the full chat screen. Get streaming working in 10 lines of code before putting it in `ChatProvider`.

**3. Never let the AI keys touch Flutter code.**
Even during development. Put them in Supabase Edge Function secrets from day one. It takes 10 minutes and prevents a serious security hole.

**4. The `what_sage_heard` embedding drives everything.**
If the embed-text Edge Function fails silently, arc assignment breaks. Add explicit error handling: if embedding returns null, set `needs_arc_assignment = true` and surface a background retry. Don't let a single embedding failure cascade into broken arc cards.

**5. Physical device from day one.**
The implementation plan says this explicitly. Flutter animations and haptics behave very differently on a real device vs emulator. The ambient orb animation that looks smooth on your computer will reveal performance issues on a mid-range Android.

**6. Your `kDebugMode` flag for demo mode.**
Set this up on Day 14. Don't wait. If your wifi dies at the defense presentation, you need a script of pre-written messages and pre-generated reflections that play back locally. Build the flag, build the mock journey, test it end-to-end.

---

*This guide was generated from: PRD, TRD, App Flow, Design Brief, Backend Schema, Implementation Plan + all UX decisions. Last updated for MindSpace v1.*