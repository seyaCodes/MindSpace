# MindSpace — Final Build Plan (v2)

**Senior Flutter Developer Spec · Locked Decisions · Parallel Backend Timeline**
Version 2.0 | All UX decisions resolved | 15-day plan for solo PFE

---

## HOW TO USE THIS FILE

This is your locked spec. Every decision is final.
When an AI helper writes code for you, hand it the relevant section.
Do not re-decide things mid-build — that's how projects break.

Four rules govern everything below:

1. **Build UI first, backend second, both in parallel from Day 4 onward**
2. **Every screen ships with mock data first, real data swapped in later**
3. **No hardcoded values anywhere — all tokens, all strings, all colors via constants**
4. **Backend schema is frozen by end of Day 1 — never edit it mid-build**

---

## PART 0 — LOCKED DECISIONS (do not revisit)

| #   | Decision                        | Final answer                                                                                                                                                        |
| --- | ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1   | Home grid layout                | Always 4 slots (2×2). Slot 4 is always the dashed "+ New Thread" card. Slots 1–3 are arc folders. Empty slots show muted placeholder "Start a new thread"           |
| 2   | Home vs View All                | Home = glanceable (name + relative date only). View All from Home navigates directly to History → Arcs tab. No separate S2b screen                                  |
| 3   | Search bar in Timeline          | Keep it. Client-side filter on already-loaded reflections list. No DB full-text search in v1                                                                        |
| 4   | Whole card tappable in Timeline | Yes — entire card opens S8. "View Reflection →" link is decorative (visual cue only, not a separate tap target)                                                     |
| 5   | Arc pill chevron in chat        | Removed. The chevron implied dropdown but the menu is on the "..." button, not the pill. Pill becomes a non-interactive label                                       |
| 6   | "..." menu in chat              | Bottom sheet with: arc context card + "this feels like it belongs to" re-routing + "view past sessions in this arc" (collapsible list)                              |
| 7   | Wrap Up button location         | Two places: top-right pill in chat header, AND bottom of the "..." menu sheet. Both call the same `chatProvider.wrapUp()` method                                    |
| 8   | Sage messages style             | Bubbled (slightly lighter `--bg-elevated` background, no border). Original brief said floating text but the design's bubbled version is cleaner                     |
| 9   | Quick-reply chips               | Static hardcoded array of 3 strings. Shown only when `messageCount == 0`. Disappear forever once user sends any message                                             |
| 10  | Bottom nav structure            | 5 visual slots: Home, History, [center FAB], Analysis, Settings. The 3rd slot in the nav is reserved empty space, FAB sits on top with elevation. 4 functional tabs |
| 11  | Analysis is a tab               | Yes — first-class destination, not buried in History. Update GoRouter ShellRoute to 4 tabs                                                                          |
| 12  | Streak counter                  | Show the number on Analysis stats row only. Not gamified. Never push notifications about it                                                                         |
| 13  | Profile v2 features             | Sage's tone, Aurora palette, Quiet hours, Daily nudge, Auto-archive — all show as rows with "Coming soon" badge. Do not build the logic                             |
| 14  | Light mode                      | Not in v1. Dark mode only. No theme toggle anywhere                                                                                                                 |
| 15  | Push notifications              | Not in v1                                                                                                                                                           |
| 16  | Drag and drop reorder           | Not in v1. "Organize" button opens a simple bottom sheet with arcs list + archive/delete buttons per row                                                            |
| 17  | Folder PNGs                     | User-provided custom PNGs per arc color. Bundle as assets, name by color: `folder_purple@2x.png` etc.                                                               |
| 18  | Arc color palette               | 6 colors matching the emotion palette: purple, green, blue, orange, red, yellow-green                                                                               |
| 19  | Emotion line chart              | Use `fl_chart` package. Build in isolation Day 11                                                                                                                   |
| 20  | Heatmap (Analysis)              | GitHub-style intensity grid, single purple ramp 4 levels. Custom widget, no library                                                                                 |

---

## PART 1 — FROZEN BACKEND SCHEMA (do this Day 1, never touch again)

The schema is frozen now. If you discover you need a new field on Day 9, **add a JSON column** to store ad-hoc data — never run a migration mid-build.

### Tables (run all migrations in one SQL script on Day 1)

```
profiles
  id uuid PK (= auth.users.id)
  display_name text
  status_intention text          -- "KEEPING A QUIET PRACTICE" etc. — v2 editable
  preferences jsonb              -- catch-all for v2 settings (quiet hours, tone, etc.)
  onboarding_completed boolean default false
  created_at timestamptz default now()
  updated_at timestamptz default now()

emotion_spirits (seed once, never modify)
  id integer PK
  name text                       -- 'anxious'|'calm'|'frustrated'|'sad'|'hopeful'|'overwhelmed'
  color_hex text
  animation_type text

chats
  id uuid PK
  user_id uuid → profiles.id
  arc_id uuid → arcs.id NULL      -- null = unassigned
  title text                       -- AI-generated session title (e.g. "Picking back up — what's shifted?")
  status text default 'active'    -- 'active'|'completed'|'abandoned'
  started_at timestamptz default now()
  ended_at timestamptz             -- set on Wrap Up
  message_count integer default 0

messages
  id uuid PK
  chat_id uuid → chats.id
  user_id uuid → profiles.id
  role text                        -- 'user'|'assistant'
  content text
  flagged_for_safety boolean default false
  created_at timestamptz default now()

reflections
  id uuid PK
  user_id uuid → profiles.id
  chat_id uuid → chats.id          -- one-to-one
  arc_id uuid → arcs.id NULL
  spirit_id integer → emotion_spirits.id      -- dominant spirit (EFT layer)
  emotion_distribution jsonb        -- ★ NEW: { "anxious": 54, "calm": 22, "sad": 14, "frustrated": 10 }
  what_sage_heard text
  question_to_sit_with text
  shared_perspective text
  moment_of_clarity text
  carry_forward text                -- ★ NEW: one sentence to feed next session's "last time" card
  embedding vector(1536)
  needs_arc_assignment boolean default false
  processing_stage_at_creation text
  created_at timestamptz default now()

arcs
  id uuid PK
  user_id uuid → profiles.id
  name text                          -- LLM-generated, user can override
  user_renamed boolean default false
  description text                   -- ★ NEW: AI-generated subtitle "Threads of anxiety, validation..."
  dominant_spirit_id integer → emotion_spirits.id
  color_hex text                     -- ★ from fixed 6-color palette only
  centroid_embedding vector(1536)
  session_count integer default 1
  processing_stage text default 'forming'
  status text default 'active'       -- 'active'|'archived'
  archived_at timestamptz NULL
  last_session_at timestamptz default now()
  created_at timestamptz default now()

arc_insights
  id uuid PK
  arc_id uuid → arcs.id
  user_id uuid → profiles.id
  lead_paragraph text                -- ★ NEW: "Across N sessions over X days, the core motion is..."
  how_it_evolved text                -- the section labeled "PATTERN" in design
  pattern_noticed text
  turning_point text                 -- ★ NEW: "Around session 3, you stopped..."
  user_note text                     -- ★ NEW: user's own annotation, stored separately
  session_count_at_generation integer
  generated_at timestamptz default now()
```

### One-time seed (run after table creation)

```sql
INSERT INTO emotion_spirits (id, name, color_hex, animation_type) VALUES
  (1, 'anxious',     '#6C5CE7', 'fast_pulse'),
  (2, 'calm',        '#00C48C', 'slow_breath'),
  (3, 'frustrated',  '#F39C12', 'medium_pulse'),
  (4, 'sad',         '#5B8DEF', 'slow_droop'),
  (5, 'hopeful',     '#A8E063', 'rising_glow'),
  (6, 'overwhelmed', '#EA88DB', 'rapid_unstable');
```

### RLS — enable on every table immediately

For every user-data table (profiles, chats, messages, reflections, arcs, arc_insights):

```sql
ALTER TABLE [table] ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users access own data" ON [table]
  FOR ALL USING (auth.uid() = user_id);
```

For profiles, the column is `id` not `user_id` — adjust the policy.
For emotion_spirits, no RLS — it's public reference data.

### Indexes

```sql
CREATE INDEX reflections_user_embedding_idx
  ON reflections USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 100)
  WHERE embedding IS NOT NULL;

CREATE INDEX reflections_arc_idx ON reflections(arc_id) WHERE arc_id IS NOT NULL;
CREATE INDEX chats_user_status_idx ON chats(user_id, status);
CREATE INDEX arcs_user_status_idx ON arcs(user_id, status);
```

### Profile auto-create trigger

```sql
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id) VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION handle_new_user();
```

---

## PART 2 — FINAL FILE STRUCTURE

Build this exact structure on Day 1. Never deviate.

```
mind_space/
├── android/
├── assets/
│   ├── folders/
│   │   ├── folder_purple.png       (1x, 2x, 3x)
│   │   ├── folder_blue.png
│   │   ├── folder_green.png
│   │   ├── folder_orange.png
│   │   ├── folder_red.png
│   │   ├── folder_yellow_green.png
│   │   └── folder_archived.png     (greyscale fallback for archived arcs)
│   └── fonts/                       (if you bundle Inter locally instead of google_fonts)
├── .env                             (gitignored — Supabase URL + anon key only)
├── pubspec.yaml
└── lib/
    ├── main.dart                    (15 lines — bootstrap only)
    │
    ├── app/
    │   ├── app.dart                 (MaterialApp.router setup)
    │   ├── router.dart              (GoRouter — all routes here)
    │   └── theme.dart               (ThemeData + AppColors + AppSpacing + AppRadius)
    │
    ├── core/
    │   ├── constants/
    │   │   ├── spirits.dart         (SpiritType enum, color map, animation map)
    │   │   ├── arc_palette.dart     (6 arc colors + folder asset paths)
    │   │   ├── quick_replies.dart   (3 hardcoded quick reply strings)
    │   │   └── crisis_resources.dart (SAMU 15, Algeria emergency, etc.)
    │   ├── env/
    │   │   └── env.dart             (loads from .env, exposes typed AppConfig)
    │   ├── extensions/
    │   │   ├── datetime_x.dart      (relative time: "2d ago", "yesterday", "just now")
    │   │   └── context_x.dart       (theme/MediaQuery shortcuts)
    │   ├── widgets/                 (truly app-wide reusable widgets)
    │   │   ├── ms_button.dart       (4 variants: primary, secondary, destructive, ghost)
    │   │   ├── ms_card.dart
    │   │   ├── ms_bottom_sheet.dart
    │   │   ├── ms_text_field.dart
    │   │   ├── ms_skeleton.dart
    │   │   ├── ms_loading_overlay.dart
    │   │   ├── arc_color_dot.dart
    │   │   ├── arc_folder_icon.dart (renders the right PNG for the arc color)
    │   │   ├── spirit_orb.dart      (animated, configurable size)
    │   │   ├── spirit_icon.dart     (static, for lists)
    │   │   └── emotion_distribution_bar.dart (gradient bar for analysis screens)
    │   └── utils/
    │       ├── cosine_sim.dart      (local utility — duplicate of Edge Fn logic for tests)
    │       └── logger.dart
    │
    ├── data/
    │   ├── models/                   (Dart classes mapping DB tables)
    │   │   ├── profile.dart
    │   │   ├── arc.dart
    │   │   ├── chat.dart
    │   │   ├── message.dart
    │   │   ├── reflection.dart
    │   │   ├── arc_insight.dart
    │   │   ├── emotion_spirit.dart
    │   │   └── emotion_distribution.dart (typed wrapper around the jsonb)
    │   ├── mock/
    │   │   └── mock_data.dart        (all mocks here)
    │   ├── repos/                    (data access layer — every screen talks to a repo, never to Supabase directly)
    │   │   ├── auth_repo.dart
    │   │   ├── arcs_repo.dart
    │   │   ├── chats_repo.dart
    │   │   ├── reflections_repo.dart
    │   │   └── insights_repo.dart
    │   └── services/
    │       ├── supabase_service.dart (singleton client)
    │       ├── edge_function_service.dart (calls all Edge Functions)
    │       └── stream_chat_service.dart (SSE consumer for streaming Sage replies)
    │
    ├── features/
    │   ├── onboarding/
    │   │   └── onboarding_screen.dart           (S0)
    │   ├── auth/
    │   │   ├── auth_screen.dart                 (S1)
    │   │   └── auth_provider.dart
    │   ├── home/
    │   │   ├── home_screen.dart                 (S2)
    │   │   ├── home_provider.dart
    │   │   └── widgets/
    │   │       ├── home_greeting.dart
    │   │       ├── arc_grid_card.dart
    │   │       └── new_thread_card.dart
    │   ├── chat/
    │   │   ├── chat_screen.dart                 (S3 — handles both free + arc modes)
    │   │   ├── chat_provider.dart
    │   │   └── widgets/
    │   │       ├── message_bubble.dart
    │   │       ├── chat_input_bar.dart
    │   │       ├── quick_reply_chips.dart
    │   │       ├── last_time_card.dart
    │   │       ├── arc_pill.dart                (non-interactive label)
    │   │       ├── wrap_up_pill.dart
    │   │       └── chat_menu_sheet.dart         (the "..." menu bottom sheet)
    │   ├── reflection/
    │   │   ├── reflection_screen.dart           (S4 — post-chat, animated)
    │   │   ├── reflection_readonly_screen.dart  (S8 — historical view)
    │   │   ├── reflection_provider.dart
    │   │   └── widgets/
    │   │       ├── reflection_section.dart      (one for each: spirit, heard, question, etc.)
    │   │       └── arc_update_footer.dart
    │   ├── history/
    │   │   ├── history_screen.dart              (shell with segmented control)
    │   │   ├── timeline_tab.dart                (S5)
    │   │   ├── arcs_tab.dart                    (S6)
    │   │   ├── history_provider.dart
    │   │   └── widgets/
    │   │       ├── timeline_session_card.dart
    │   │       ├── emotion_filter_chips.dart
    │   │       ├── search_bar.dart
    │   │       ├── arc_grid_tile.dart
    │   │       └── organize_sheet.dart
    │   ├── arc_detail/
    │   │   ├── arc_detail_screen.dart           (S7 — handles active + archived states)
    │   │   ├── arc_analysis_screen.dart         (S7c — "What this arc is teaching you")
    │   │   ├── arc_detail_provider.dart
    │   │   ├── arc_insight_provider.dart
    │   │   └── widgets/
    │   │       ├── arc_header.dart              (name editable inline, stats row)
    │   │       ├── emotion_line_chart.dart      (fl_chart wrapper — hardest widget)
    │   │       ├── arc_session_card.dart
    │   │       ├── revive_banner.dart           (only on archived arcs)
    │   │       ├── pattern_card.dart            (PATTERN section)
    │   │       └── turning_point_card.dart      (TURNING POINT section)
    │   ├── analysis/
    │   │   ├── analysis_screen.dart             (SA — global)
    │   │   ├── analysis_provider.dart
    │   │   └── widgets/
    │   │       ├── stats_row.dart               (42 sessions, 4 arcs, 17 day streak)
    │   │       ├── activity_heatmap.dart        (GitHub-style grid — second hardest)
    │   │       └── arc_analysis_preview_card.dart
    │   └── settings/
    │       ├── settings_screen.dart             (S9 — Profile)
    │       ├── settings_provider.dart
    │       └── widgets/
    │           ├── profile_card.dart
    │           ├── settings_row.dart            (reusable row with icon + label + trailing)
    │           └── coming_soon_badge.dart
    └── shell/
        ├── app_shell.dart                       (ShellRoute body — 4-tab nav + FAB)
        └── bottom_nav.dart                       (5-slot custom nav with centered FAB)
```

---

## PART 3 — REUSABLE WIDGETS SPEC

Build these on Day 2 before any screen.

### `MsButton`

4 variants (`primary`, `secondary`, `destructive`, `ghost`).
Props: `String label`, `VoidCallback? onPressed`, `MsButtonVariant variant`, `Widget? leadingIcon`, `bool isLoading`.
Auto-disabled appearance when `onPressed == null`.
Loading state shows a small CircularProgressIndicator replacing the label.

### `MsCard`

Props: `Widget child`, `EdgeInsets? padding`, `VoidCallback? onTap`, `Color? borderColor`.
Default padding: `EdgeInsets.symmetric(horizontal: 16, vertical: 14)`.
Always `--bg-card`, 0.5px border, radius 16.
`onTap != null` → wrap in InkWell with subtle ripple.

### `MsBottomSheet`

A helper function, not a widget:

```dart
Future<T?> showMsBottomSheet<T>({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
  String? title,
  bool dismissible = true,
});
```

Handles all the standard setup: --bg-elevated background, 20px top corners only, handle bar, safe area padding.

### `SpiritOrb`

Props: `SpiritType type`, `double size`, `bool animate` (default true).
Uses `flutter_animate` for the breath/pulse animation. Different animation per spirit type.
This is the most-used widget — test all 6 spirits at 3 sizes (40, 80, 120) before declaring done.

### `ArcFolderIcon`

Props: `Color arcColor`, `double size`, `bool isArchived`.
Maps arcColor to one of 6 PNG asset names. Archived state uses `folder_archived.png` (greyscale).
Image.asset with proper width/height.

### `EmotionDistributionBar`

Props: `EmotionDistribution distribution`, `double height` (default 8).
Renders the gradient bar (purple→green→blue→orange) with stops mapped to percentages.
Used on S7c and SA. Same widget, two contexts.

### `MsSkeleton`

Props: `double width`, `double height`, `double? borderRadius`.
Shimmer animation. Pass to any layout to indicate loading.

### `MsLoadingOverlay`

Props: `String message`, `SpiritType? spirit`.
Full-screen overlay with spirit orb + message. Used during Wrap Up and arc insight generation.

### `ArcColorDot`

Props: `Color color`, `double size`.
Just a colored circle. Used in timeline cards, arc pills, etc.

### `SettingsRow`

Props: `IconData icon`, `String title`, `String? subtitle`, `Widget? trailing`, `VoidCallback? onTap`.
The reusable row from the profile screen.
`trailing` can be a `Switch`, a `Text` ("On >"), or a `ComingSoonBadge`.

---

## PART 4 — STATE MANAGEMENT (Riverpod)

**One provider file per feature folder.** Never a single God-Provider.

### Provider types you'll use

| Use case                                                        | Provider type                            |
| --------------------------------------------------------------- | ---------------------------------------- |
| Read-only async data (arcs list, reflections list)              | `FutureProvider`                         |
| Streaming data (auth state, real-time messages if used)         | `StreamProvider`                         |
| Complex mutable state (chat session state)                      | `StateNotifierProvider<Notifier, State>` |
| Single value mutable (selected filter, segmented control index) | `StateProvider`                          |

### Key ChatState (most complex)

```dart
@immutable
class ChatState {
  final List<Message> messages;
  final bool isStreaming;        // Sage is mid-reply
  final bool isWrappingUp;       // post Wrap Up loading
  final bool canWrapUp;          // 4+ user messages
  final String? currentArcId;    // null = free chat
  final Arc? currentArc;         // hydrated from arcs cache
  final String? error;
  final bool isOffline;

  ChatState copyWith({ ... });
}
```

### Provider parent rule

If a provider depends on another (e.g. `arcDetailProvider(id)` depends on `arcsListProvider`), use `ref.watch` inside the provider — never make the widget chain through both.

---

## PART 5 — ROUTING

```dart
// app/router.dart
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(ref.watch(authProvider.stream)),
    redirect: (context, state) => _redirect(ref, state),
    routes: [
      // Auth & onboarding (no shell)
      GoRoute(path: '/onboarding', builder: (_, __) => OnboardingScreen()),
      GoRoute(path: '/auth', builder: (_, __) => AuthScreen()),

      // Main shell (bottom nav)
      ShellRoute(
        builder: (_, __, child) => AppShell(child: child),
        routes: [
          GoRoute(path: '/', builder: (_, __) => HomeScreen()),
          GoRoute(path: '/history', builder: (_, __) => HistoryScreen()),
          GoRoute(path: '/analysis', builder: (_, __) => AnalysisScreen()),
          GoRoute(path: '/settings', builder: (_, __) => SettingsScreen()),
        ],
      ),

      // Modal full-screen routes (no shell)
      GoRoute(
        path: '/chat',
        pageBuilder: (_, state) => MaterialPage(
          fullscreenDialog: true,
          child: ChatScreen(arcId: state.uri.queryParameters['arcId']),
        ),
      ),
      GoRoute(
        path: '/reflection',
        pageBuilder: (_, state) => MaterialPage(
          fullscreenDialog: true,
          child: ReflectionScreen(reflectionId: state.uri.queryParameters['id']!),
        ),
      ),

      // Pushed screens (no shell)
      GoRoute(path: '/arc/:id', builder: (_, state) =>
        ArcDetailScreen(arcId: state.pathParameters['id']!)),
      GoRoute(path: '/arc/:id/analysis', builder: (_, state) =>
        ArcAnalysisScreen(arcId: state.pathParameters['id']!)),
      GoRoute(path: '/reflection/:id/view', builder: (_, state) =>
        ReflectionReadonlyScreen(id: state.pathParameters['id']!)),
    ],
  );
});

// "View all" from home goes to /history (not a separate route)
// History tab opens with "Arcs" segment selected if navigated this way
```

---

## PART 6 — THE BOTTOM NAV (5 SLOTS, 4 TABS)

This is the trick most people get wrong. Here's the correct approach:

```dart
// shell/bottom_nav.dart
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // ★ critical — lets FAB overflow upward
      alignment: Alignment.topCenter,
      children: [
        // The 5-slot bar — slot 2 (index 2) is empty
        Container(
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Row(
            children: [
              _NavSlot(icon: Icons.home, index: 0, ...),
              _NavSlot(icon: Icons.menu_book, index: 1, ...),
              const SizedBox(width: 56), // ★ reserved space for FAB
              _NavSlot(icon: Icons.trending_up, index: 2, ...),
              _NavSlot(icon: Icons.settings, index: 3, ...),
            ],
          ),
        ),
        // FAB floats on top, positioned slightly above the bar
        Positioned(
          top: -16,
          child: FloatingActionButton(
            onPressed: () => context.go('/chat'),
            backgroundColor: AppColors.accentPurple,
            elevation: 0,
            child: Icon(Icons.add, size: 28),
          ),
        ),
      ],
    );
  }
}
```

Key points:

- `Stack` with `clipBehavior: Clip.none` lets the FAB overflow upward without getting cut off
- The 5-slot bar reserves a `SizedBox(width: 56)` where the FAB visually sits — keeps spacing even
- FAB is positioned with `Positioned(top: -16)` to float above the bar
- The shell route's Scaffold uses `extendBody: true` so content scrolls behind the nav bar
- Bottom padding on every screen: `SafeArea(bottom: false)` + manually add bottom padding equal to nav height + safe area

---

## PART 7 — THE 15-DAY PARALLEL BUILD TIMELINE

The single biggest change from your original plan: **Days 4–10 run UI and backend in parallel.** You're solo so you switch contexts, but the days are split.

```
DAY     |  UI WORK                                 |  BACKEND WORK
--------|------------------------------------------|---------------------------------
 1      |  Project setup, folder structure,        |  Supabase project created,
        |  pubspec.yaml, .env, theme.dart          |  ALL tables + RLS + indexes
        |  AppShell + bottom nav skeleton          |  + seed emotion_spirits
        |                                          |  + auth trigger
--------|------------------------------------------|---------------------------------
 2      |  All reusable widgets (Part 3)           |  (none — schema is frozen)
        |  Test screen with every component        |
--------|------------------------------------------|---------------------------------
 3      |  Data models + mock data                 |  hello-world Edge Function
        |  Repos with mock implementations         |  Groq key in Edge Fn secrets
        |  GoRouter wired with placeholder screens |  Test: curl call returns text
--------|------------------------------------------|---------------------------------
 4      |  S2 Home (with mock arcs)                |  ★ Sage system prompt v1
        |  S0 Onboarding                           |  Iterate on 10 test messages
        |  S1 Auth (UI only, no Supabase yet)      |  Save versions sage_v1, v2, v3
--------|------------------------------------------|---------------------------------
 5      |  S5 Timeline (with mock reflections)     |  chat-stream Edge Function
        |  S6 Arcs grid                            |  (deploy + curl test SSE works)
        |  S9 Settings (static)                    |
--------|------------------------------------------|---------------------------------
 6      |  S3 Chat (with mock messages)            |  safety-check Edge Function
        |  Quick reply chips                       |  Test 15 messages, tune prompt
        |  Wrap Up pill, chat menu sheet           |
--------|------------------------------------------|---------------------------------
 7      |  S4 Reflection screen + cascade anim     |  end-chat Edge Function
        |  S8 Reflection read-only                 |  (structured JSON output)
        |  M1 Crisis sheet                         |  Cross-arc context injection
--------|------------------------------------------|---------------------------------
 8      |  ★ WIRE AUTH: connect S1 to Supabase     |  embed-text Edge Function
        |  Auth provider, redirect logic           |  pgvector queries tested in
        |  Test with 2 accounts, verify RLS        |  SQL editor
--------|------------------------------------------|---------------------------------
 9      |  ★ WIRE CHAT: SSE streaming              |  assign-arc Edge Function
        |  Replace mock messages with real         |  Full cosine similarity logic
        |  Confirm streaming works on device       |  Test 20 fabricated reflections
--------|------------------------------------------|---------------------------------
10      |  ★ WIRE END-CHAT: real reflection        |  generate-arc-insight Edge Fn
        |  Real data flows S3→S4→S2                |  OpenRouter + deepseek-r1
        |  Cross-arc context plumbed end-to-end    |  Caching logic
--------|------------------------------------------|---------------------------------
11      |  S7 Arc Detail (mock + real data)        |  Emotion line chart deep dive
        |  Inline rename, color picker             |  fl_chart configuration
        |  emotion_line_chart.dart (HARD)          |
--------|------------------------------------------|---------------------------------
12      |  S7c Arc Analysis screen                 |  Real insight generation
        |  Pattern + Turning point cards           |  wired end-to-end
        |  Distribution bar widget                 |
--------|------------------------------------------|---------------------------------
13      |  SA Global Analysis screen               |  Heatmap data query
        |  Activity heatmap widget (HARD)          |  (aggregation by date)
        |  Stats row                               |
--------|------------------------------------------|---------------------------------
14      |  ★ EVALUATION DAY                        |
        |  30 test conversations, grade 5 dims     |
        |  Identify bottom 5, tune prompts         |
        |  Re-run, document before/after          |
--------|------------------------------------------|---------------------------------
15      |  ★ DEMO PREP                             |
        |  Install on 3 devices, fix top 5 bugs   |
        |  Demo script, practice 3x                |
        |  Offline fallback mode behind kDebugMode|
        |  Hide all H-xx debug labels             |
```

### Why this parallel structure works

- **Day 1** locks the schema so all downstream work proceeds without DB surprises
- **Days 4–7** UI flies forward with mock data while backend prompts are tested in isolation (curl-only, no Flutter wiring)
- **Days 8–10** are integration days — each day swaps one mock for real backend
- **Days 11–13** build the visualization-heavy screens (charts, heatmap) which only need the data shape, which is already locked
- **Day 14** is pure evaluation — the deliverable for your thesis defense table
- **Day 15** is buffer for everything that will go wrong

---

## PART 8 — WHEN TO START SUPABASE WORK

Three answers depending on how you read the question:

**When to create the project and run migrations: Day 1.**
This unblocks everything else and proves your schema works before you write Dart.

**When to start prompt engineering: Day 4.**
Sage's voice is the product. Don't wait until backend wiring day to discover the prompt is bad. Test prompts in the Groq playground (or curl) for 3–4 days before integrating.

**When to wire Supabase to Flutter: Day 8.**
Not earlier. Before this, every Flutter screen runs on mock data only. This means if your Edge Function changes shape on Day 9, you only update one file (`reflections_repo.dart`) — not 12 screens.

**Critical rule:** Keep mock data alive even after wiring real data. Your repos should have a flag:

```dart
class ReflectionsRepo {
  final bool useMockData; // controlled by kDebugMode + env

  Future<List<Reflection>> getRecent() {
    if (useMockData) return Future.value(MockData.reflections);
    return _supabase.from('reflections').select()...;
  }
}
```

This is your demo fallback. On Day 15, you flip a flag and the entire app runs on hardcoded perfect data.

---

## PART 9 — THE CHAT WRAP-UP "ANALYSIS" (what you said you don't know yet)

You wrote: _"didn't design wrap up chat analysis yet idk i taught its smt for backend i dont know how to do this analysis."_

This is the reflection generation. You **have** designed it — it's S4 (the post-chat reflection screen). What you might be missing is the AI-side spec. Here it is.

### When the user taps Wrap Up

```
1. UI: show MsLoadingOverlay with spirit orb + "Sage is sitting with this..."
2. Call POST /functions/end-chat with chat_id
3. Edge Function (end-chat):
   a. Fetch all messages from this chat (user + assistant)
   b. Fetch cross-arc context: last what_sage_heard from 2-3 other active arcs
   c. Call Groq llama-3.3-70b with this prompt structure:

      [SYSTEM]
      You are Sage, completing a session. Generate a reflection in strict JSON
      following the EFT framework. Identify the emotion layer beneath the surface.
      Do not advise. Do not prescribe. Use the user's own language.

      Background: other things currently in this person's life:
      - {arc1.name}: {arc1.last_what_sage_heard}
      - {arc2.name}: {arc2.last_what_sage_heard}

      Internal chain of thought (do not output): identify the underlying EFT
      emotion layer beneath whatever the user said on the surface.

      Output exactly this JSON structure:
      {
        "spirit_id": <1-6>,
        "what_sage_heard": "<one sentence reflecting the LAYER, not the surface>",
        "question_to_sit_with": "<one open question, not advice-shaped>",
        "shared_perspective": "<normalizing community voice, 'many people...'>",
        "moment_of_clarity": "<only if user expressed a real shift, else null>",
        "carry_forward": "<one sentence to remember in next session of this arc>",
        "emotion_distribution": {
          "anxious": <0-100>, "calm": <0-100>, "frustrated": <0-100>,
          "sad": <0-100>, "hopeful": <0-100>, "overwhelmed": <0-100>
        }
      }

      Percentages must sum to 100. Most sessions have 2-4 non-zero emotions.

      [USER]
      Here is the conversation:
      User: ...
      Sage: ...
      User: ...

   d. Parse JSON, save to reflections table
   e. Call embed-text on what_sage_heard, save vector
   f. Call assign-arc with the new reflection_id
   g. Return { reflection_id, arc_id, arc_was_new: bool }

4. UI: navigate to S4 with reflection_id, render with cascade animation
```

### What you don't need to do separately

The "chat wrap-up analysis" IS the reflection generation. There is no other AI analysis between the chat and the reflection screen. The reflection screen IS the wrap-up display.

The two other analyses (Arc Insight on S7c, Global Analysis on SA) are separate and triggered separately:

- **Arc Insight**: user taps "Generate" CTA on S7. Triggers `generate-arc-insight` Edge Function.
- **Global Analysis**: pure aggregation queries, no AI. Stats row counts sessions/arcs/streak. Heatmap counts sessions per date. Arc preview cards read existing arc_insights rows.

---

## PART 10 — THINGS THAT WILL BITE YOU (final warnings)

### 1. The streaming SSE consumer is the hardest piece of Flutter code in this project

Build it on Day 9 in a throwaway test screen first. Get this 15-line example working with a known endpoint:

```dart
Future<void> testStream() async {
  final req = http.Request('POST', Uri.parse('https://your-edge-fn/chat-stream'));
  req.headers['Authorization'] = 'Bearer ${anonKey}';
  req.headers['Content-Type'] = 'application/json';
  req.body = jsonEncode({'chat_id': 'test', 'message': 'hi'});

  final stream = (await req.send()).stream.transform(utf8.decoder);
  await for (final chunk in stream) {
    for (final line in chunk.split('\n')) {
      if (!line.startsWith('data: ')) continue;
      final data = line.substring(6);
      if (data == '[DONE]') return;
      final json = jsonDecode(data);
      final delta = json['choices']?[0]?['delta']?['content'];
      if (delta != null) print(delta); // ← see tokens stream
    }
  }
}
```

Once you see tokens print in the console, you're done with the hard part. Then wrap it in `ChatProvider.sendMessage()`.

### 2. The 4-tab bottom nav with center FAB

The trick is `Stack` with `clipBehavior: Clip.none`. If you forget that, the FAB gets clipped and you'll spend an hour debugging.

### 3. The emotion line chart on S7

Use `fl_chart` and study their `LineChartData` example before writing your version. Build the chart with hardcoded data first (a list of 7 data points per emotion), confirm visual fidelity, then plug in real `emotion_distribution` data.

### 4. The heatmap on SA

Don't use any chart library. Build it as a custom widget:

- A horizontal `SingleChildScrollView`
- Inside: a `Row` of `Column`s (each column = 1 week)
- Each cell: a 14×14 `Container` with calculated opacity
- 4 opacity levels: 0=transparent w/ border, 1=20%, 2=50%, 3=80%, 4+=100%
- Day labels (Mon/Wed/Fri) as a `Column` on the left, separate from the scrollable grid

### 5. Asset folder PNGs

Once you have the 6 PNGs:

- Add `assets/folders/` to your `pubspec.yaml`'s `flutter.assets` section
- Make sure each PNG has 1×, 2×, 3× versions (Flutter uses `pubspec.yaml` to find these)
- Test on a high-DPI device — if a PNG looks pixelated, the 3× version is missing

### 6. Don't run on emulator

Implementation plan rule. The emulator gives you false confidence on animation smoothness and haptic feedback. Use a physical Android device from Day 1.

### 7. Keep `kDebugMode` debug labels behind a flag

Show them during dev: small "H-01", "S-04" labels in screen corners. Hide them in release. This helps you map screens to documentation but should never appear in the demo.

### 8. The "Last time" card on arc chat (S3b)

This requires `carry_forward` from the previous reflection. On every new chat in an arc, your `chat-stream` Edge Function (or a setup call before it) needs to fetch the most recent reflection in this arc and surface its `carry_forward` to the UI. The UI renders this above the first message.

Implementation: when navigating to `/chat?arcId=xxx`, the chat screen first calls `arcsRepo.getLastReflection(arcId)`. If found, prepend a `LastTimeCard` widget at the top of the message list. Static, not part of the messages stream.

### 9. Session title

The chat header shows "SESSION 6 · THE JOB HUNT" + "Picking back up — what's shifted?" The first line is computed (`session_count` from arc + arc name). The second line is the AI-generated session title from `chats.title`.

Generate it as part of the first Sage reply: prepend to your chat-stream prompt:

```
First, generate a session title (5-8 words, no quotes, no clinical language)
that captures what the user might want to explore this session, given the
arc's history. Output it on its own line prefixed with "TITLE:" before
your reply.
```

Parse it client-side from the first SSE chunk, save to `chats.title`, strip it from the user-visible reply.

### 10. The "what to cut" list (from your implementation plan)

Refresh on Day 12 if you're behind:

- Cut: Aurora palette UI (already "coming soon")
- Cut: Quiet hours UI (already "coming soon")
- Cut: Auto-archive UI (already "coming soon")
- Cut: Search functionality (keep the search bar visually, disable input — already client-side anyway)
- Cut: Inline arc name editing (force user to long-press → bottom sheet — easier than inline TextField transitions)
- Keep no matter what: reflection generation, arc assignment, safety classifier, 3 working screens (Home, Chat, Reflection)

---

## PART 11 — DEFINITION OF DONE

By end of Day 15, the app must:

- [ ] Run cold-start in under 2 seconds on a mid-range Android device
- [ ] Complete a full 5-minute demo: onboarding → first chat → reflection → second chat → arc form → insight generation → analysis screen
- [ ] Survive a wifi cut at any point during the demo (offline fallback mode flag)
- [ ] Have 30 evaluated test conversations with before/after prompt quality scores
- [ ] Pass safety classifier on 15 test messages (0 false negatives)
- [ ] Show RLS proof (two accounts cannot see each other's data)
- [ ] Have 3 saved prompt versions for thesis evidence

That's it. Anything beyond that is gravy.

---

_This is your locked spec. Refer back to it instead of re-deciding.
When something feels missing, check if it's intentionally cut (Part 13 of original guide), in v2 (Part 10 decisions table), or actually missing.
The third case is the only one that warrants a real change._
