-- Migration: align vector columns with gte-small output (384 dims).
-- Safe to run when all embedding/centroid values are NULL.
-- If columns were already vector(384) this is a no-op.

-- Drop any existing dimension-specific indexes first (they'd conflict).
DROP INDEX IF EXISTS reflections_embedding_idx;
DROP INDEX IF EXISTS arcs_centroid_idx;

-- Change reflections.embedding to vector(384).
ALTER TABLE reflections
  ALTER COLUMN embedding TYPE vector(384);

-- Change arcs.centroid to vector(384).
ALTER TABLE arcs
  ALTER COLUMN centroid TYPE vector(384);

-- Approximate-nearest-neighbour indexes (uncomment once you have >100 rows).
-- CREATE INDEX reflections_embedding_idx ON reflections
--   USING ivfflat (embedding vector_cosine_ops) WITH (lists = 10);
-- CREATE INDEX arcs_centroid_idx ON arcs
--   USING ivfflat (centroid vector_cosine_ops) WITH (lists = 10);
