-- TODO: Consider if it is better for choice to be the actual choice or a pointer to the choices table

CREATE TABLE mappa.likert_responses (
  uuid        UUID        UNIQUE,
  created_at  TIMESTAMPTZ,
  user_email  NAME,
  user_id     UUID,
  org         JSONB,
  answer_id     UUID,
  choice TEXT
);

CREATE TRIGGER override_likert_response_cols
BEFORE INSERT ON mappa.likert_responses
FOR EACH ROW
EXECUTE PROCEDURE mappa.override_server_columns();

CREATE OR REPLACE VIEW "1".likert_responses as
  SELECT uuid, created_at, user_email, user_id, org, answer_id, choice from mappa.likert_responses;

GRANT SELECT, INSERT ON mappa.likert_responses to member;
GRANT all ON "1".likert_responses to member;
