-- Restricts uuid, created_at, user_id

-- for these three columns we never let the caller control the contents
CREATE OR REPLACE FUNCTION mappa.override_survey_response_columns()
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
  IF NEW.user_id IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send the user_id field';
  ELSE
    NEW.user_id = current_setting('request.jwt.claim.sub', true);
  END IF;

  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TABLE mappa.survey_responses (
  uuid        UUID        UNIQUE,
  created_at  TIMESTAMPTZ,
  user_id     UUID,
  survey_id   UUID,
  collector_id UUID
);

CREATE TRIGGER override_survey_response_cols
BEFORE INSERT ON mappa.survey_responses
FOR EACH ROW
EXECUTE PROCEDURE mappa.override_survey_response_columns();

CREATE OR REPLACE VIEW "1".survey_responses as
  SELECT uuid, created_at, user_id, survey_id, collector_id from mappa.survey_responses;

GRANT SELECT, INSERT ON mappa.survey_responses to member;
GRANT all ON "1".survey_responses to member;
