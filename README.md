<div align="center">

<br />

# MindSpace

**Your emotional memory. Not a journal. Not a chatbot. A mirror that remembers.**

<br />

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=flat-square&logo=supabase&logoColor=white)](https://supabase.com)
[![Groq](https://img.shields.io/badge/Groq-F55036?style=flat-square)](https://groq.com)
[![Platform](https://img.shields.io/badge/Android-API_24+-3DDC84?style=flat-square&logo=android&logoColor=white)](https://developer.android.com)

<br />

![MindSpace preview](assets/preview.png)

</div>

---

MindSpace is a dark-first Flutter app that lets you talk through what's on your mind. It automatically groups conversations into recurring themes called **Arcs**, then generates longitudinal insights as the pattern develops — so you can see how you've been changing, not just what you said.

You just talk. The system handles the rest.

## Features

- 🧠 **Sage** — an EFT-informed AI that listens before it reflects. No advice. No platitudes. Streaming responses via Groq.
- 🔁 **Arcs** — your conversations are automatically clustered into themes using embedding similarity. Arcs evolve as you keep talking.
- ✨ **Arc Insights** — after 3+ sessions, generate a macro reflection on how a theme has moved. Powered by DeepSeek R1.
- 🛡️ **Safety classifier** — every message is screened before it reaches Sage. Fails closed — if the API is down, chat is blocked.
- 💬 **Post-chat reflections** — a structured card after every session: the emotion underneath, a question to sit with, a shared perspective.

## Stack

| | |
|---|---|
| Frontend | Flutter · Riverpod · GoRouter |
| Backend | Supabase Edge Functions (Deno) |
| Database | PostgreSQL + pgvector |
| Auth | Supabase Auth (Google OAuth + magic link) |
| LLM | Groq `llama-3.3-70b` · `llama-3.1-8b` · OpenRouter `deepseek-r1` |
| Embeddings | OpenAI `text-embedding-3-small` |

## Getting started

**Prerequisites:** Flutter 3.x · Dart 3.x · Android device (API 24+) · Supabase project

```bash
git clone https://github.com/your-username/mind_space.git
cd mind_space
flutter pub get
```

Create a `.env` file at the project root:

```env
SUPABASE_URL=your_project_url
SUPABASE_ANON_KEY=your_anon_key
```

> All LLM keys (`GROQ_API_KEY`, `OPENAI_API_KEY`, `OPENROUTER_API_KEY`) go in Supabase Edge Function secrets — never in Flutter source.

Then set up Supabase:

1. Enable the **pgvector** extension — Dashboard → Database → Extensions
2. Run migrations in `/supabase/migrations/` in order
3. Deploy Edge Functions: `supabase functions deploy`
4. Seed the `emotion_spirits` table (6 entries)

Run on a physical device:

```bash
flutter run
```

## Project structure

```
lib/
├── core/           # Theme tokens, shared components, constants
├── features/       # auth · home · chat · reflection · history · arc_detail · settings
└── services/       # Supabase client, LLM callers, Arc service
supabase/
├── functions/      # safety-check · chat-stream · end-chat · assign-arc · generate-arc-insight
└── migrations/     # Ordered SQL migrations
```

## License

MIT