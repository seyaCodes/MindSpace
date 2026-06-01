// Exact mirror of the Postgres schema — no invented columns.

export interface Profile {
  id: string;
  display_name: string | null;
  created_at: string;
}

export interface Arc {
  id: string;
  user_id: string;
  name: string;
  status: string; // 'active' | 'archived'
  dominant_spirit_id: string | null;
  session_count: number;
  last_session_at: string | null;
  archived_at: string | null;
  created_at: string;
  centroid: string | number[] | null; // pgvector comes back as "[0.1,0.2,...]" string
  user_renamed: boolean;
}

export interface Chat {
  id: string;
  user_id: string;
  arc_id: string | null;
  status: string; // 'active' | 'archived'
  created_at: string;
  session_number: number | null;
}

export interface Message {
  id: string;
  chat_id: string;
  role: "user" | "assistant" | "system";
  content: string;
  created_at: string;
}

export interface Reflection {
  id: string;
  chat_id: string;
  user_id: string;
  arc_id: string | null;
  spirit_id: string | null;
  what_sage_heard: string;
  question_to_sit_with: string;
  shared_perspective: string;
  embedding: string | number[] | null; // pgvector
  arc_topic: string | null;            // LLM-generated topic summary used as embedding source
  created_at: string;
}

export interface ArcInsight {
  id: string;
  arc_id: string;
  user_id: string;
  how_it_evolved: string;
  pattern_noticed: string;
  turning_point: string | null;
  turning_point_context: string | null;
  session_count_at_generation: number;
  generated_at: string;
}

// ---- Response shapes --------------------------------------------------------

export interface SafetyCheckResult {
  safe: boolean;
  reason?: string;
}

export interface ReflectionResult {
  what_sage_heard: string;
  question_to_sit_with: string;
  shared_perspective: string;
}

export interface ArcInsightResult {
  how_it_evolved: string;
  pattern_noticed: string;
  turning_point?: string;
  turning_point_context?: string;
}

export interface AssignArcResult {
  arc_id: string;
  arc_name: string;
  is_new: boolean;
}
