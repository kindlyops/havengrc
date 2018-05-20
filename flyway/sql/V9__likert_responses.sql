
CREATE TABLE mappa.likert_responses (
  uuid        UUID        UNIQUE,
  created_at  TIMESTAMPTZ,
  user_email  NAME,
  user_id     UUID,
  org         JSONB,
  answer_id     UUID,
  choice_id UUID
);

CREATE TRIGGER override_likert_response_cols
BEFORE INSERT ON mappa.likert_responses
FOR EACH ROW
EXECUTE PROCEDURE mappa.override_server_columns();

CREATE OR REPLACE VIEW "1".likert_responses as
  SELECT uuid, created_at, user_email, user_id, org, answer_id, choice_id from mappa.likert_responses;

GRANT SELECT, INSERT ON mappa.likert_responses to member;
GRANT all ON "1".likert_responses to member;
