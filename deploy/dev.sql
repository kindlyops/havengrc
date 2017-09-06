-- Deploy mappamundi:dev to pg

BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA "1";
CREATE SCHEMA mappa;
CREATE TABLE mappa.regulation
(
  id SERIAL PRIMARY KEY,
  identifier TEXT NOT NULL,
  uri TEXT,
  description TEXT
);

-- the schema "1" is our versioned public API
-- the schema mappa is private
-- grants are done to the private schema "mappa" because
-- the view needs to read from that schema with the role
-- of the authenticated caller
CREATE OR REPLACE VIEW "1".regulation as
  SELECT id, identifier, uri, description from mappa.regulation;

GRANT usage ON schema mappa to member;
GRANT usage ON schema "1" to member;


GRANT all ON mappa.regulation to member;
GRANT usage, select ON sequence mappa.regulation_id_seq to member;

CREATE TABLE mappa.comment (
  uuid        UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  time        TIMESTAMP NOT NULL DEFAULT now(),
  user_email  NAME      NOT NULL DEFAULT current_setting('request.jwt.claim.email', true),
  message     TEXT
);

CREATE OR REPLACE VIEW "1".comment as
  SELECT uuid, user_email, time, message from mappa.comment;

GRANT all ON mappa.comment to member;
GRANT all ON "1".comment to member;

COMMIT;
