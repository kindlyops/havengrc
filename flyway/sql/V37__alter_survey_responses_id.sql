ALTER TABLE mappa.survey_responses
RENAME COLUMN uuid TO id;

DROP VIEW "1".survey_responses;

CREATE OR REPLACE FUNCTION mappa.override_survey_response_columns()
RETURNS TRIGGER AS $$
BEGIN
  IF NEW.id IS NOT NULL THEN
    RAISE EXCEPTION 'You must not send id field';
  ELSE
    NEW.id = mappa.uuid_generate_v4();
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


CREATE OR REPLACE VIEW "1".survey_responses as
  SELECT id, created_at, user_id, survey_id, collector_id from mappa.survey_responses;

GRANT SELECT, INSERT ON mappa.survey_responses to member;
GRANT all ON "1".survey_responses to member;