-- Deploy mappamundi:dev to pg

BEGIN;

CREATE SCHEMA "1";
CREATE SCHEMA mappa;
CREATE TABLE mappa.regulation
(
  id SERIAL PRIMARY KEY,
  identifier TEXT NOT NULL,
  uri TEXT,
  description TEXT
);

CREATE OR REPLACE VIEW "1".regulation as
  SELECT id, identifier, uri, description from mappa.regulation;

COMMIT;
