-- Deploy mappamundi:dev to pg

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

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
    NEW.uuid = mappa.uuid_generate_v4();
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
  IF NEW.user_id IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send the user_id field';
  ELSE
    NEW.user_id = current_setting('request.jwt.claim.sub', true);
  END IF;
  IF NEW.org IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send org field';
  ELSE
    NEW.org = current_setting('request.jwt.claim.org', true);
  END IF;

  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE mappa.comments (
  uuid        UUID        UNIQUE,
  created_at  TIMESTAMPTZ,
  user_email  NAME,
  user_id     UUID,
  message     TEXT,
  org         JSONB
);

CREATE TRIGGER override_comment_cols BEFORE INSERT ON mappa.comments FOR EACH ROW EXECUTE PROCEDURE mappa.override_server_columns();

CREATE OR REPLACE VIEW "1".comments as
  SELECT uuid, user_email, user_id, org, created_at, message from mappa.comments;

GRANT SELECT, INSERT ON mappa.comments to member;
GRANT all ON "1".comments to member;