-- Deploy mappamundi:dev to pg

BEGIN;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE SCHEMA "1";
CREATE SCHEMA mappa;

-- the schema "1" is our versioned public API
-- the schema mappa is private
-- grants are done to the private schema "mappa" because
-- the view needs to read from that schema with the role
-- of the authenticated caller


GRANT usage ON schema mappa to member;
GRANT usage ON schema "1" to member;

-- for these three columns we never let the caller control the contents
CREATE OR REPLACE FUNCTION mappa.override_server_columns()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.uuid IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send uuid field';
  ELSE
    NEW.uuid = uuid_generate_v4();
  END IF;
  IF NEW.created_at IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send created_at field';
  ELSE
    NEW.created_at = now();
  END IF;
  IF NEW.user_email IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send user_email field';
  ELSE
    NEW.user_email = current_setting('request.jwt.claim.email', true);
  END IF;

  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE mappa.comment (
  uuid        UUID        UNIQUE,
  created_at  TIMESTAMPTZ,
  user_email  NAME,
  message     TEXT
);

CREATE TRIGGER override_comment_cols BEFORE INSERT ON mappa.comment FOR EACH ROW EXECUTE PROCEDURE mappa.override_server_columns();

CREATE OR REPLACE VIEW "1".comment as
  SELECT uuid, user_email, created_at, message from mappa.comment;

GRANT SELECT, INSERT ON mappa.comment to member;
GRANT all ON "1".comment to member;

COMMIT;
