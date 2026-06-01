-- Add arc_topic to reflections: a short LLM-generated factual summary used as
-- the embedding source instead of full therapeutic text, so embeddings cluster
-- by life theme rather than emotional/reflective style.
ALTER TABLE reflections
  ADD COLUMN IF NOT EXISTS arc_topic TEXT;
