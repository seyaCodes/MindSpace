# MindSpace — Claude Code Rules
## Read this before every single response. These rules override everything else.

---

## VISUAL RULES — NON-NEGOTIABLE

### Folder icons
- ALWAYS `Image.asset('assets/folders/folder_purple.png')` etc.
- NEVER use Icon, Container with color, BoxDecoration, or any shape as a folder substitute
- Available: folder_purple.png, folder_blue.png, folder_green.png, folder_orange.png, folder_red.png, folder_yellow_green.png, folder_teal.png, folder_archived.png
- If arc color doesn't map to a known filename, ASK — do not substitute

### Colors — copy these exactly, never guess
```dart
// Backgrounds
static const bgPrimary    = Color(0xFF0D0D1A); // near-black purple tint
static const bgCard       = Color(0xFF151528); // slightly lifted
static const bgElevated   = Color(0xFF1C1C35); // modals, sheets

// Text
static const textPrimary  = Color(0xFFF5F5F7);
static const textSecondary= Color(0xFF9B9BA0);
static const textTertiary = Color(0xFF5A5A60);

// Accent
static const accentPurple = Color(0xFF6C5CE7);
static const accentGreen  = Color(0xFF00C48C);
static const accentOrange = Color(0xFFF39C12);
static const accentBlue   = Color(0xFF5B8DEF);
static const accentRed    = Color(0xFFE74C3C);
static const border       = Color(0xFF2A2A2E);

// Home gradient (top to bottom)
static const homeGradientTop    = Color(0xFF2D1B69);
static const homeGradientBottom = Color(0xFF0D0D1A);
```

### Background gradient — every screen
Every Scaffold body wraps content in:
```dart
Container(
  decoration: const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF2D1B69), Color(0xFF0D0D1A)],
      stops: [0.0, 0.6],
    ),
  ),
  child: // your content
)
```

### Typography — Inter only, via google_fonts
```dart
// Display (screen titles like "History", "Profile")
GoogleFonts.inter(fontSize: 40, fontWeight: FontWeight.w700, color: AppColors.textPrimary)

// Heading (arc names, card titles)
GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimary)

// Body
GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimary)

// Label (metadata, timestamps)
GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textSecondary)

// Tag/pill text
GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 0.5)
```

### Border radius constants
```dart
static const double radiusSm   = 8.0;
static const double radiusMd   = 12.0;
static const double radiusLg   = 16.0;
static const double radiusXl   = 20.0;
static const double radiusFull = 999.0;
```

### Cards
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.bgCard,
    borderRadius: BorderRadius.circular(AppRadius.lg), // 16
    border: Border.all(color: AppColors.border, width: 0.5),
  ),
)
```

---

## BOTTOM NAV — exact implementation

```dart
// This is the ONLY correct implementation of the bottom nav
// Stack with clipBehavior: Clip.none is mandatory
Stack(
  clipBehavior: Clip.none,
  alignment: Alignment.topCenter,
  children: [
    Container(
      height: 64,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.home_outlined, index: 0),
          _NavItem(icon: Icons.menu_book_outlined, index: 1),
          const SizedBox(width: 64), // reserved FAB space — do not remove
          _NavItem(icon: Icons.trending_up_outlined, index: 2),
          _NavItem(icon: Icons.settings_outlined, index: 3),
        ],
      ),
    ),
    Positioned(
      top: -20,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: AppColors.accentPurple,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    ),
  ],
)
```

---

## SCREEN-BY-SCREEN PIXEL SPECS

### HOME SCREEN (S2)
```
Scaffold: extendBody: true, backgroundColor: transparent
Body: gradient container (see gradient rule above)
SafeArea: top: true, bottom: false

Top section padding: horizontal 20px, top 16px
Date label: "FRIDAY, APRIL 24" — Inter 12sp w500 textSecondary, letterSpacing 1.2
Title: "Morning," — Inter 40sp w700 textPrimary, line 1
        "Seya." — same style but color accentPurple (the name only)
Subtitle: "Pick up where you left off, or start fresh." — Inter 16sp w400 textSecondary, top margin 8px

Section row: top margin 32px
  "Open threads" — Inter 18sp w600 textPrimary
  "view all ›" right-aligned — Inter 14sp w400 accentPurple, onTap → /history (arcs tab)

Grid: top margin 16px, horizontal padding 20px
  2 columns, crossAxisSpacing 16, mainAxisSpacing 16
  childAspectRatio: 0.85 (taller than wide)
  Slot 4 (index 3): ALWAYS the NewThreadCard

ArcGridCard:
  folder image: width 100%, height ~120px, fit: BoxFit.contain
  arc name: Inter 16sp w700 textPrimary, top margin 8px
  subtitle: "[relative date] · [N] sessions" Inter 13sp textSecondary

NewThreadCard:
  same dimensions as ArcGridCard
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: AppColors.textSecondary.withOpacity(0.3), width: 1.5,
      strokeAlign: BorderSide.strokeAlignInside) — dashed effect via CustomPaint
  )
  center: Icon(Icons.add, color: textSecondary, size: 32)
  below icon: "New Thread" Inter 13sp textSecondary

Bottom padding: 80px (nav height) + MediaQuery.of(context).padding.bottom
```

### CHAT SCREEN — FREE (S3a)
```
Scaffold: backgroundColor: transparent, resizeToAvoidBottomInset: true
Body: gradient container

Header: horizontal padding 16px, top = SafeArea top
  Back button: "< Home" — Inter 16sp w400 textSecondary
  Right side: dashed pill + "..." circle button
  
Dashed "no arc yet" pill:
  height 32, padding horizontal 12
  dashed border 1px textSecondary 40% opacity
  "+" icon 14px + " no arc yet" Inter 13sp textSecondary

"..." button: circle 36px, bgElevated background, Icon(Icons.more_horiz)

Session header (below nav): horizontal padding 20px, top 20px
  "NEW SESSION · JUST TALKING" — Inter 11sp w500 textSecondary letterSpacing 1.2
  Title "What's with you, right now?" — Inter 32sp w700 textPrimary, top 4px

Messages list: padding horizontal 16px
  Sage message: LEFT side, small spirit orb 36px left of bubble
    Bubble: bgElevated, radius 16px (no top-left radius = 4px), padding 14px
    text: Inter 16sp w400 textPrimary
  User message: RIGHT side, no orb
    Bubble: Color(0xFF2A2560), radius 16px (no top-right radius = 4px)
    text: Inter 16sp w400 textPrimary
  Timestamp: below bubble, Inter 11sp textTertiary, margin top 4px

Quick reply chips (show only when messageCount == 0, after first Sage message):
  Wrap widget, spacing 8px
  Each chip: Container, bgElevated bg, radius 20px, padding h16 v8
  text: Inter 14sp w400 textPrimary
  Disappear permanently on first user message send

Input bar: positioned at bottom, above keyboard
  Container: bgElevated, height 56px, radius 28px, margin h16 bottom 16px
  Left: Icon(Icons.mic_outlined) textSecondary 22px, padding left 16px
  Middle: TextField, hint "Message Sage..." textTertiary, no decoration
  Right: circle 40px accentPurple, Icon send arrow white 20px
```

### CHAT SCREEN — IN ARC (S3b)
```
Same as S3a except:

Header right side: SOLID pill (not dashed)
  bgElevated background, radius full
  folder icon 16px + arc name Inter 13sp w500 textPrimary + chevron down icon
  height 32, padding horizontal 12

Session header:
  "SESSION 6 · THE JOB HUNT" — Inter 11sp w500 accentPurple letterSpacing 1.2
  Title is AI-generated session title (from chats.title field)

"Last time" card: appears ABOVE first message, margin bottom 16px
  Container: bgElevated, radius 12, padding 12px, border 0.5px border color
  Left: Icon(Icons.history_outlined) 16px textSecondary
  Text: "Last time · [carry_forward text]" Inter 13sp textSecondary
  "Last time" in w600 textPrimary, rest in w400 textSecondary

No quick reply chips in arc mode
```

### OPEN THREADS / VIEW ALL (navigates to History Arcs tab)
```
This is NOT a separate screen — tapping "view all" on home calls:
context.go('/history') and sets the arcs tab as selected (index 1)
```

### HISTORY — TIMELINE (S5)
```
Scaffold: transparent, extendBody true
Header: horizontal 20px
  Back "< Mind Space" — textSecondary 16sp
  "History" — Inter 40sp w700 textPrimary
  "Your memory vault" — Inter 16sp textSecondary

Segmented control: margin top 24px, horizontal 20px
  Container height 48px, bgCard, radius 24px, border 0.5px border color
  Two segments: "Timeline" (active = bgElevated + accentPurple text + clock icon)
                "Arcs" (inactive = transparent + textSecondary)
  Each segment: flex 1, centered, Inter 15sp w500

Search bar: margin top 16px, horizontal 20px
  Container height 44px, bgCard, radius 22px, border 0.5px border color
  Left: Icon(Icons.search_outlined) textTertiary 20px, padding left 14px
  TextField: hint "Search your reflections..." textTertiary 14sp
  Right: Icon(Icons.tune_outlined) textTertiary 20px, padding right 14px

Filter chips: margin top 12px
  SingleChildScrollView horizontal, padding horizontal 20px
  Chips: height 32px, radius 16px
  Active: accentPurple 20% opacity bg + accentPurple text + colored dot left
  Inactive: bgCard bg + textSecondary text
  First chip "All" has no dot

Date group header: "TODAY, APR 25 · 2 SESSIONS"
  Inter 11sp w500 textTertiary letterSpacing 1.0, margin v12 h20
  Left: small colored dot (accentPurple 6px)

Session card: horizontal 20px margin, margin bottom 12px
  Container: bgCard, radius 16px, border 0.5px border color, padding 16px
  Top row:
    Arc pill: bgElevated bg, radius 6px, padding h8 v4
      "THE JOB HUNT" — Inter 11sp w500 textSecondary letterSpacing 0.8
    Right: "7:30 PM · 14 min" — Inter 12sp textTertiary
  Arc name title: Inter 20sp w700, color = arc color, margin top 8px
  Quote text: Inter 14sp textSecondary, margin top 6px
    Italic, wrapped in curly quotes " "
    Max 3 lines, overflow ellipsis
  "View Reflection →" button: right-aligned, margin top 12px
    Container: bgElevated, radius 20px, padding h12 v6
    Icon(Icons.lightbulb_outline) 14px + " View Reflection" Inter 13sp textSecondary
  Entire card is InkWell → S8

Whole card onTap → S8 ReflectionReadonly
"View Reflection" is visual only, same tap target as card
```

### HISTORY — ARCS (S6) = OPEN THREADS (S2b)
```
Same screen, same component. Reached from:
- History tab → "Arcs" segment
- Home "view all ›" link (sets arcs segment as default)

Header:
  "< Home" OR "< Mind Space" depending on origin
  "Openthreads" — Inter 40sp w700 textPrimary (note: "Open" normal weight, "threads" lighter — 
    achieve with RichText: "Open" w700 + "threads" w300 same size, "s" fades off-screen edge)
  Subtitle: "Pick a thread to return to, or revive an archived one."

Stats row: "ACTIVE" label + "4 ongoing arcs" + "Organize" pill button right
  Organize pill: bgElevated, radius 20px, padding h12 v8
  Icon(Icons.grid_view_outlined) 16px + " Organize" Inter 13sp textPrimary

Active arc grid: same as home grid but shows ALL active arcs (not just 3)
  ArcGridCard here shows: folder image + name + "[Nd ago] · [N] sessions" + spirit dots row
  Spirit dots: Row of 4-5 colored circles 8px diameter, spacing 4px

Archived section divider:
  Row: Icon(Icons.archive_outlined) 14px textTertiary
  "ARCHIVED CHAPTERS · 2" Inter 11sp w500 textTertiary letterSpacing 1.0
  Chevron right/down icon, whole row is tappable to expand
  AnimatedSize wraps the archived grid below

Archived arc cards: same widget but
  folder: folder_archived.png (greyscale)
  name + text: textTertiary (dimmed)
  Opacity(opacity: 0.5) wrapping the card
  Shows: "archived · [N] sessions"
```

### ARC DETAIL — ACTIVE (S7a)
```
Scaffold: transparent, extendBody true

Header: "< Threads" textSecondary 16sp
  "ARC · ACTIVE" — Inter 11sp w500 accentPurple letterSpacing 1.2, top 8px

Arc name: Inter 36sp w700 textPrimary (tappable → inline TextField)
Arc description: Inter 16sp w400 textSecondary, top 8px, max 2 lines

Stats row: top 20px
  "5 SESSIONS" · "APR 11 STARTED" · "14D SPAN"
  Inter 11sp w500 textTertiary letterSpacing 0.8
  Items separated by 16px spacing

Emotion chart container: top 24px
  bgCard, radius 16px, border 0.5px border color, padding 16px
  Header row: "EMOTION · LAST 7 SESSIONS" Inter 11sp textTertiary w500 + "peaks marked" right textTertiary
  
  Chart (fl_chart LineChart):
    height: 200px
    Y-axis: 7 emotion labels left (Happy, Calm, Anxious, Sad, Frustr., Angry, Numb)
      each label: Inter 11sp textTertiary, left side
    X-axis: S1 S2 S3 S4 S5 S6 S7 — Inter 11sp textTertiary
    Grid: horizontal lines only, 0.5px border color 30% opacity
    Lines: one per emotion present, colored per emotion, strokeWidth 2
    Dots: circle 8px fill = emotion color, shown at each data point
    Peak dots: slightly larger (12px) with a subtle glow marker

Sessions section: top 24px
  "Sessions" Inter 22sp w600 textPrimary + "most recent first" Inter 12sp textTertiary right

Session card:
  bgCard, radius 12px, border 0.5px, padding 14px, margin bottom 10px
  Top: "TODAY · APR 25 · 7:30 PM" Inter 11sp textTertiary
  Title: Inter 18sp w600 textPrimary, margin top 4px
  Body: Inter 14sp textSecondary, margin top 4px, max 2 lines
  Bottom: emotion tag pill left (accentPurple bg 20% + "ANXIOUS" Inter 11sp accentPurple)
          "Open →" right Inter 13sp textSecondary
  Entire card → S8

Bottom sticky bar: bgCard, padding 16px + safe area bottom
  "Continue this Arc →" — full-width primary button, accentPurple, height 54px, radius 12px
```

### ARC DETAIL — ARCHIVED (S7b)
```
Same as S7a except:

Banner at very top (before header):
  bgCard, radius 12px, border 0.5px, padding 14px, margin h20 top 16px
  Icon(Icons.archive_outlined) 16px textSecondary
  "This arc has ended." Inter 15sp w600 textPrimary
  Body text: "You can revive it to pick the thread back up..." Inter 13sp textSecondary
  Row of 2 buttons below:
    "Revive arc" — primary small button, accentPurple, radius 20px
    "Continue reading" — secondary small button, transparent + border

"ARC · ARCHIVED" label (not ACTIVE)
Stats row adds "MAR 18 CLOSED"

No "Continue this Arc" sticky bar — replaced with nothing (read-only)
Sessions are read-only (no swipe actions)
```

### ARC ANALYSIS (S7c)
```
Header: "< Arc" textSecondary
  "ANALYSIS · THE JOB HUNT" Inter 11sp w500 textTertiary letterSpacing 1.0, top 4px

Hero title: top 8px
  "What this arc" — Inter 40sp w700 textPrimary
  "is teaching you." — Inter 40sp w700 accentPurple (entire second line colored)

Lead paragraph: Inter 16sp textSecondary, top 16px, lineHeight 1.6
  Contains italicized phrases — use TextSpan with FontStyle.italic for em-dashed phrases

Dominant emotional weight card: top 24px
  bgCard, radius 16px, border 0.5px, padding 16px
  Header: "Dominant emotional weight" Inter 15sp w500 textPrimary
          "[N] sessions" Inter 12sp textTertiary right
  
  Gradient bar: top 12px, height 8px, radius 4px
    LinearGradient with stops at cumulative emotion percentages
    Colors: [accentPurple, accentGreen, accentBlue, accentOrange] (for anxious/calm/sad/frustrated)
  
  Emotion labels below bar: Wrap widget, spacing h16 v8, top 12px
    Each: colored dot 8px + " EmotionName " Inter 13sp textPrimary + "XX%" Inter 13sp textSecondary

Pattern card: top 16px
  bgCard, radius 16px, border 0.5px, padding 16px
  "· PATTERN" — accentPurple dot + "PATTERN" Inter 11sp w500 accentPurple letterSpacing 1.0
  Title (pattern headline): Inter 22sp w700 textPrimary, top 8px, max 2 lines
  Body: Inter 14sp textSecondary, top 8px, lineHeight 1.6

Turning point card: top 16px (same structure as pattern card)
  "· TURNING POINT" — accentGreen dot + "TURNING POINT" Inter 11sp w500 accentGreen
  Content from turning_point field
```

### GLOBAL ANALYSIS (SA)
```
Header: "< Mind Space" textSecondary
  "Analysis" Inter 40sp w700 textPrimary
  "Patterns across all of your arcs." Inter 16sp textSecondary

Stats row: top 24px, 3 equal cards
  Each card: bgCard, radius 12px, padding 14px, flex 1
  Number: Inter 28sp w700 textPrimary
  Label: Inter 11sp w500 textTertiary letterSpacing 0.8 (SESSIONS / ACTIVE ARCS / DAYS STREAK)

Heatmap card: top 24px
  bgCard, radius 16px, border 0.5px, padding 16px
  Header: "Reflection intensity" Inter 15sp w500 textPrimary
          "last 14 weeks" Inter 12sp textTertiary right
  
  Row labels (left column, fixed): Mon / Wed / Fri
    Inter 11sp textTertiary, spaced vertically to align with grid rows
  
  Grid (SingleChildScrollView horizontal):
    14 weeks × 7 days
    Each cell: 14×14px Container, margin 2px, radius 3px
    Colors:
      0 sessions: transparent with Border.all(color: border, width: 0.5)
      1 session:  accentPurple.withOpacity(0.25)
      2 sessions: accentPurple.withOpacity(0.50)
      3 sessions: accentPurple.withOpacity(0.75)
      4+ sessions: accentPurple (full)
  
  Footer row: "← drag to scroll" Inter 11sp textTertiary left
              "Less □□□□ More" right — 4 boxes showing opacity ramp

Arc analyses list: top 24px
  "Arc analyses" Inter 22sp w600 textPrimary + "[N] arcs" textTertiary right
  
  Preview card per arc (bgCard, radius 16px, border 0.5px, padding 16px, margin bottom 12px):
    Left: folder icon 48px (Image.asset arc folder PNG)
    Right: arc name Inter 18sp w600 textPrimary
           pattern preview Inter 14sp textSecondary max 2 lines
    Gradient bar (same as S7c, smaller, height 4px): top 12px
    Emotion dots row + "Open analysis →" link: Inter 13sp accentPurple right
```

### SETTINGS / PROFILE (S9)
```
Header: "< Mind Space" textSecondary
  "Profile" Inter 40sp w700 textPrimary
  "Tune your space and your boundaries." Inter 16sp textSecondary

Profile card: bgCard, radius 16px, border 0.5px, padding 16px, top 24px
  Row: avatar circle 52px (accentPurple bg, initial letter Inter 22sp w600 white)
       Column right: name Inter 18sp w600 textPrimary
                     "42 sessions · 4 active arcs · 17-day streak" Inter 13sp textSecondary
  Status pill below name: bgElevated, radius 20px, padding h12 v4
    green dot 6px + "KEEPING A QUIET PRACTICE" Inter 11sp w500 textSecondary letterSpacing 0.8

Section label: "YOUR SPACE" Inter 11sp w500 textTertiary letterSpacing 1.2, top 24px, margin left 20px

Settings rows (bgCard, radius 12px, border 0.5px, margin bottom 8px, horizontal 20px):
  Each row height 56px, padding horizontal 16px
  Left: icon circle 32px bgElevated + icon 16px textSecondary
  Middle: title Inter 15sp w500 textPrimary / subtitle Inter 12sp textSecondary
  Right: trailing widget (text + chevron, Switch, or ComingSoon badge)
  
  ComingSoon badge: bgElevated, radius 12px, padding h8 v2
    "Coming soon" Inter 11sp textTertiary

  Sage's tone: trailing "Soft ›" + ComingSoon badge
  Aurora palette: trailing Switch (disabled, coming soon)
  Quiet hours: trailing "On ›" + ComingSoon badge
  Daily check-in nudge: trailing "9:00 PM ›" + ComingSoon badge
  Auto-archive arcs: trailing Switch (disabled, coming soon)

PRIVACY section: same section label style
  Sign out: SettingsRow with Icon(Icons.logout_outlined) accentRed, title "Sign Out" accentRed
  Export Data: normal row
  Delete Account: title accentRed, destructive style
```

### CHAT "..." MENU SHEET
```
showModalBottomSheet, isDismissible: true, isScrollControlled: true

Container: bgElevated, radius top-only 20px, padding 20px
Handle bar: 4×32px, color border, centered, top 12px

Arc context card: bgCard, radius 12px, border 0.5px, padding 14px
  Left: folder icon 40px (arc PNG)
  Right: arc name Inter 16sp w600 textPrimary
         "[N] sessions · dominant" Inter 13sp textSecondary
         emotion name in accentPurple Inter 13sp w600
  "this session" tag: bgElevated, radius 8px, Inter 11sp textTertiary, right-aligned top

"This feels like it belongs to..." row: bgCard, radius 12px, padding 14px, top 8px
  Left: icon circle bgElevated + Icon(Icons.compare_arrows) 16px
  Title: Inter 15sp w500 textPrimary
  Subtitle: "Suggest a different arc · still confirmed by ML" Inter 12sp textSecondary
  Right: Icon(Icons.chevron_right) textTertiary

"View past sessions in this arc" row: same structure, top 8px
  Subtitle: "[N] sessions · timeline below"
  Right: chevron up/down (animated, toggles session list)

Session list (AnimatedSize, collapsed by default):
  Each row: padding 12px, left border 0.5px accentPurple
  Left: spirit orb image/circle 32px with emotion color
  Title: Inter 15sp w500 textPrimary (what_sage_heard shortened)
  Subtitle: "Apr 25 · 7:30 PM" Inter 12sp textSecondary
  Right: Icon(Icons.chevron_right) textTertiary

Bottom buttons: Row, top 16px
  "Close" — flex 1, secondary button, height 48px, radius 12px
  "Wrap up session" — flex 2, primary button accentPurple, height 48px, radius 12px
  gap 12px between
```

---

## BEHAVIOR RULES

### Navigation
- "view all" on home → `context.go('/history')` and set history tab index to 1 (Arcs)
- Arc card tap → `context.push('/arc/${arc.id}')`
- Chat opens as fullscreenDialog: true — slides up, hides bottom nav
- Back from chat → never goes back to chat — pops to home or arc detail

### Mock data (use until Day 8)
- All repos check `kDebugMode || useMock` flag
- Never show empty states during development — always return mock data
- Mock arc colors: purple, blue, green, orange (4 arcs covers all designs)

### Wrap Up
- Appears after `messageCount >= 4` (user messages only, not Sage messages)
- Both the header pill AND the "..." sheet "Wrap up session" button call `ref.read(chatProvider.notifier).wrapUp()`
- Never duplicate the wrapUp logic — one method, called from two places

### Quick reply chips
- `const kQuickReplies = ['Something on my mind', 'Just want to vent', "I don't really know"]`
- Show only in free chat (no arcId), only when messageCount == 0
- Tapping a chip sends it as a user message (calls sendMessage with the chip text)
- Disappear permanently after any message is sent

---

## WHAT TO NEVER DO

1. Never use `Colors.purple`, `Colors.blue` etc — always AppColors constants
2. Never use `Text(...)` without specifying a style from the spec above
3. Never use `Icon(Icons.folder*)` for arc folders — Image.asset only
4. Never create a separate screen for "Open Threads" — it's the History Arcs tab
5. Never use `Navigator.push` — always GoRouter (`context.go` or `context.push`)
6. Never put business logic inside a widget build method
7. Never add packages not in pubspec.yaml without asking first
8. Never use `setState` for app data — Riverpod providers only
9. Never hardcode a color hex inline in a widget file
10. Never skip the bottom safe area — always account for it