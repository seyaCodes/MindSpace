# MindSpace — Fix Application Guide

Apply these in order. Each step is small and testable.

---

## STEP 1 — Add new screens

Drop these files into your project:

| File | Goes to |
|------|---------|
| `reflection_readonly_screen.dart` | `lib/features/reflection/reflection_readonly_screen.dart` |
| `arc_analysis_screen.dart` | `lib/features/arc_detail/arc_analysis_screen.dart` |
| `widgets/activity_heatmap.dart` | `lib/features/analysis/widgets/activity_heatmap.dart` |
| `widgets/timeline_session_card.dart` | `lib/features/history/widgets/timeline_session_card.dart` (REPLACE existing) |
| `app_router.dart` | `lib/app/router.dart` (REPLACE — adjust import paths as needed) |

---

## STEP 2 — Apply navigation fixes via Claude Code

Give Claude Code this single prompt:

```
Apply these 6 navigation fixes. Each touches a specific file. 
Do not modify anything not listed.

═══ FIX 1: Home "view all" should go to history Arcs tab ═══
File: lib/features/home/home_screen.dart

Find: the "view all" GestureDetector onTap
Change to:
  onTap: () => context.go('/history?tab=arcs'),

═══ FIX 2: Arcs in history grid should be tappable ═══
File: lib/features/history/widgets/arc_grid_tile.dart

The ArcGridTile already has `onTap` parameter. 
Make sure it actually navigates when used. The GestureDetector wrapper 
in the build method should already work — just confirm.

═══ FIX 3: Wire arcs_tab.dart to pass onTap to ArcGridTile ═══
File: lib/features/history/arcs_tab.dart

For every ArcGridTile, add an onTap that navigates to arc detail.
For The Job Hunt: onTap: () => context.push('/arc/1'),
For Family:       onTap: () => context.push('/arc/2'),
For Relationships: onTap: () => context.push('/arc/3'),
For Creative Block: onTap: () => context.push('/arc/4'),
For archived ones: onTap: () => context.push('/arc/5'), etc.

Add this import at top: 
  import 'package:go_router/go_router.dart';

═══ FIX 4: History timeline segmented control gets stuck ═══
File: lib/features/history/history_screen.dart

In _HistoryScreenState's initState, the WidgetsBinding.addPostFrameCallback 
runs on every rebuild and resets the tab. Replace initState with:

@override
void initState() {
  super.initState();
  // Only set initial tab once, on first mount
  Future.microtask(() {
    if (mounted) {
      ref.read(historyProvider.notifier).setTab(widget.initialTab);
    }
  });
}

═══ FIX 5: Session cards in arc detail should navigate to S8 ═══
File: lib/features/arc_detail/arc_detail_screen.dart

The session cards (currently _SessionCard) need to navigate when tapped.
Wrap each _SessionCard in a GestureDetector:

GestureDetector(
  onTap: () => context.push('/reflection/1'),
  child: const _SessionCard(...)
)

Or modify _SessionCard to accept onTap parameter and add InkWell internally.

═══ FIX 6: Analysis screen arc preview cards navigate to per-arc analysis ═══
File: lib/features/analysis/analysis_screen.dart

Find the "Open analysis →" link or the entire ArcAnalysisPreview card.
Wrap in GestureDetector:

GestureDetector(
  onTap: () => context.push('/arc/1/analysis'),
  child: [the existing preview card widget]
)

═══ FIX 7: Remove Organize button entirely ═══
File: lib/features/history/arcs_tab.dart

DELETE the entire Row that contains the Organize Container.
Replace the Row that has 'ACTIVE THREADS' / 'Organize' with just 
the left column (ACTIVE THREADS + 4 ongoing arcs text).
Keep it as a Column instead of a Row.

═══ FIX 8: Replace heatmap in analysis_screen ═══
File: lib/features/analysis/analysis_screen.dart

The heatmap is currently broken/overflowing.
Find where the heatmap widget is rendered and REPLACE the entire 
heatmap widget with:

import 'widgets/activity_heatmap.dart';
...
ActivityHeatmap()

Use the new ActivityHeatmap widget I just provided in 
lib/features/analysis/widgets/activity_heatmap.dart

═══ FIX 9: History segmented buttons need more height ═══
File: lib/features/history/history_screen.dart

In _SegmentedToggle:
- Change height: 56 → height: 60
- Change padding: EdgeInsets.all(4) → EdgeInsets.all(5)

In _Segment:
- Add inside AnimatedContainer: constraints: const BoxConstraints.expand(),
  This makes each segment fill the full pill height.

═══ FIX 10: Add onTap to ArcGridTile constructor calls in HOME screen ═══
File: lib/features/home/widgets/arc_grid_card.dart (or wherever home arc cards live)

The home arc cards already navigate to arc detail. Confirm by checking
each card's onTap calls context.push('/arc/<id>').

═══════════════════════════════════════════════════════════════

Do not touch any other files. Do not refactor. Do not add features.
After applying, run flutter clean && flutter run.
Report which fixes you applied successfully and any errors.
```

---

## STEP 3 — Manual verifications

After Claude Code applies fixes, test these flows:

1. **Home → tap "view all"** → should land on History with Arcs tab selected
2. **History → tap Timeline segment** → should switch to timeline (not stuck)
3. **Arcs tab → tap any folder** → should push to arc detail
4. **Arc detail → tap any session card** → should push to reflection read-only
5. **Analysis tab → tap "Open analysis →" on Job Hunt card** → should push to arc analysis screen
6. **Heatmap** → should render contained, scrollable horizontally, no overflow

---

## STEP 4 — Set the initial state for testing

In your `main.dart`, after `ProviderScope`, manually set the providers 
to skip onboarding/auth during development:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      overrides: [
        onboardingCompleteProvider.overrideWith((ref) => true),
        authStateProvider.overrideWith((ref) => true),
      ],
      child: const MyApp(),
    ),
  );
}
```

When you actually want to test onboarding/auth flow, remove the overrides.

---

## What was NOT changed (intentionally)

These items from your message are intentionally deferred:

- **Delete arc/session buttons** — deferred to v2. Long-press menu pattern. 
  No place for them in PFE demo.
- **Drag-and-drop reorder** — deferred to v2. 
  Reason for removing Organize button entirely.
- **Aurora palette / Sage tone / Quiet hours** — already shown as 
  "Coming soon" in profile.

---

## File summary of what's new

```
lib/
├── app/
│   └── router.dart                                    [REPLACED]
└── features/
    ├── reflection/
    │   └── reflection_readonly_screen.dart            [NEW]
    ├── arc_detail/
    │   └── arc_analysis_screen.dart                   [NEW]
    ├── history/
    │   └── widgets/
    │       └── timeline_session_card.dart             [REPLACED with tinted version]
    └── analysis/
        └── widgets/
            └── activity_heatmap.dart                  [NEW]
```

That's it — 5 files touched manually, 10 fixes via Claude Code prompt.