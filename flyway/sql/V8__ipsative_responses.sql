-- Deploy mappamundi:dev to pg

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";



-- for these three columns we never let the caller control the contents
CREATE OR REPLACE FUNCTION mappa.override_ipsative_response_columns()
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

CREATE TABLE mappa.ipsative_responses (
  uuid        UUID        UNIQUE,
  created_at  TIMESTAMPTZ,
  user_email  NAME,
  user_id     UUID,
  survey_id     INTEGER,
  response     JSONB,
  org         JSONB
);

CREATE TRIGGER override_ipsative_response_cols
BEFORE INSERT ON mappa.ipsative_responses
FOR EACH ROW
EXECUTE PROCEDURE mappa.override_ipsative_response_columns();

CREATE OR REPLACE VIEW "1".ipsative_responses as
  SELECT uuid, created_at, user_email, user_id, survey_id, response, org from mappa.ipsative_responses;

GRANT SELECT, INSERT ON mappa.ipsative_responses to member;
GRANT all ON "1".ipsative_responses to member;
